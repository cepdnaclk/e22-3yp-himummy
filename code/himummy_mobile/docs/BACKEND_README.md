# HiMummy backend/data layer

The app data layer uses Firebase Authentication and Cloud Firestore. It does not
implement screens, navigation, BLE, camera, audio, or video handling. Only
synthetic demo readings should be used while developing this student prototype.
Raw audio and video are never written to Firebase.

## Setup

1. Install Flutter and the Firebase CLI. From the project root:

   ```powershell
   dart pub global activate flutterfire_cli
   flutterfire configure
   flutter pub get
   ```

   FlutterFire writes `lib/firebase_options.dart`, which is ignored by Git.
   `lib/firebase_options.example.dart` is a placeholder, not a working config.
2. Initialize Firebase before constructing repositories:

   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   if (kDebugMode) {
     await useFirebaseEmulator();
   }
   ```

   Import the generated `firebase_options.dart` and
   `lib/data/emulator_config.dart`. The emulator helper rejects release-mode
   calls and selects `10.0.2.2` for the Android emulator, otherwise
   `localhost`.
3. Configure the Firebase CLI project by copying
   `firebase/.firebaserc.example` to `.firebaserc` in the repository root and
   selecting the local demo project `demo-himummy`. The Firebase emulator does
   not require a real project or production credentials.
4. Start Auth, Firestore, and Emulator UI in a terminal from the repository root:

   ```powershell
   firebase emulators:start --config firebase/firebase.json --project demo-himummy
   ```

   Ports are Auth `9099`, Firestore `8080`, and UI `4000`.
5. In another terminal, install the seed script dependency and seed only while
   both emulators are running:

   ```powershell
   npm --prefix firebase install
   $env:FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080'
   $env:FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099'
   $env:GCLOUD_PROJECT = 'demo-himummy'
   npm --prefix firebase run seed
   ```

   The seed script refuses to run unless both environment variables identify
   local hosts. The printed passwords are emulator-only test credentials.

## Running tests

With the Firestore emulator running, run security rules tests from the project
root:

```powershell
npm --prefix firebase/rules-tests install
npm --prefix firebase/rules-tests test
```

Run Dart tests and static analysis from the project root:

```powershell
flutter pub get
flutter test
flutter analyze
```

The Dart tests use `fake_cloud_firestore` and `firebase_auth_mocks`; no live
Firebase project is needed for them.

## Repository API examples

All repositories are plain Dart classes. Constructors accept `FirebaseFirestore`
and `FirebaseAuth` for test injection and default to Firebase's initialized
instances in the app.

Mother-side reads and writes:

```dart
final hr = HrReadingRepository();
await hr.saveHrReading(HrReading(
  heartRateBpm: 82,
  recordedAt: DateTime.now(),
  signalQuality: 'poor',
  source: 'wearable_ble',
));
final recentEstimates = hr.watchHrReadings(limit: 30);

final rooms = RoomReadingRepository();
await rooms.saveRoomReading(RoomReading(
  roomTempC: 22.1,
  humidityPercent: 48.0,
  updatedAt: DateTime.now(),
  source: 'synthetic',
));
final latestRoomReading = rooms.watchLatestRoomReading();

final checkins = CheckinRepository();
await checkins.submitCheckin(Checkin(
  answers: const {'mood': 'okay'},
  submittedAt: DateTime.now(),
  consentGiven: true,
));
final history = await checkins.getCheckinHistory();
```

Clinician-side access:

```dart
final clinician = ClinicianRepository();
final assignedPatients = clinician.watchAssignedPatients();
final summary = await clinician.getPatientSummary(motherUid);
final hrEstimates = clinician.watchPatientHrReadings(motherUid);
final checkinHistory = await clinician.getPatientCheckins(motherUid);
final note = await clinician.addFollowUpNote(motherUid, 'Synthetic follow-up');
final patientNotes = clinician.watchPatientNotes(motherUid);
await clinician.updateReviewStatus(motherUid, noteId, 'reviewed');
```

`addFollowUpNote` and `updateReviewStatus` commit an audit record atomically
with the note write. Clinician operations independently verify the signed-in
profile and `assigned_clinician_uid`; Firestore rules remain the enforcement
boundary. `PatientSummary` contains the profile and latest HR, room, and
check-in values. A `null` latest value means no record exists.

Other read APIs:

```dart
final profiles = UserRepository();
final myProfile = await profiles.getProfile(uid);
final profileChanges = profiles.watchProfile(uid);

final audit = AuditRepository();
final myAuditEntries = audit.watchMyEntries();
```

`AuthService` exposes `signInWithEmail(email, password)`, `signOut()`,
`authStateChanges`, `currentUser`, and `currentUserProfile()`. The profile's role
is always read from `users/{uid}`. New profile and role provisioning must happen
through trusted setup/Admin SDK; the mobile client has no registration or role
assignment API. Input validation failures throw `AppException` with a stable
`AppErrorCode`. Firebase read/write failures are mapped to the same typed
exception family.

Use `isStale(timestamp, threshold)` from `lib/domain/data_freshness.dart` to
mark old values in a caller's presentation layer. Poor and invalid HR signals
are persisted and remain visible to callers.

## Assumptions

- Authenticated user profiles are provisioned by trusted administration. Client
  profile creation is denied; signed-in users can update only `display_name`
  and `email`, never `role` or `assigned_clinician_uid`.
- Clinicians can read assigned mother profiles, readings, check-ins, and notes;
  they can create their own notes and change only the review status of their
  own notes. Mothers can read/write/delete their own readings and check-ins, but
  cannot access clinician notes.
- Notes start in `pending`; a new note's author name is taken from the
  authoritative clinician profile.
- HR estimates are constrained to 30–220 BPM, room temperature to -10–60 C,
  and humidity to 0–100 percent. Timestamps later than the current client time
  are rejected locally and future timestamps are rejected by rules.
- Check-in answer maps must be non-empty and consent must be true before saving.
- Audit entries are append-only. A clinician can read only their own clinician
  audit entries; signed-in users can create an entry attributed to their own
  profile. Clinician note flows create their audit entry in the same batch.
- The seed writes 50 HR estimates per demo mother, four room readings, three
  check-ins per mother, and one synthetic clinician note per mother.

## Troubleshooting

- If app requests fail locally, confirm the emulators are running and that
  `useFirebaseEmulator()` ran after `Firebase.initializeApp()`.
- Android emulator traffic uses `10.0.2.2`; Android devices on a physical
  network need a reachable host configuration before connecting.
- If Firestore reports a missing index, deploy/enable the indexes in
  `firebase/firestore.indexes.json` or use the emulator's index guidance.
- If a clinician sees no patients, confirm the profile's role is `clinician`,
  each mother's `assigned_clinician_uid` matches that clinician UID, and the
  patient list query includes both `role` and assignment constraints.
- A missing Firestore user profile is an error, not a role fallback. Seed the
  emulator or provision the account through trusted administration.
- Never point the seed script at a production host; it intentionally requires
  local emulator environment variables.
