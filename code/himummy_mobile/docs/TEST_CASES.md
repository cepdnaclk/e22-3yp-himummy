# HiMummy backend test cases

Test date: 2026-11-26. Environment: Windows 11, Flutter 3.50.1, Node v24, Java 21,
Firebase Emulator Suite (Auth + Firestore, project `demo-himummy`). All data is synthetic.
Automated results: `flutter test` = 24 passed; `npm test` (rules) = 12 passed; `flutter analyze` = no issues.
Items marked "Not done" were not executed and must not be claimed as verified.

| ID | Steps | Expected result | Actual result | Pass/Fail | Evidence file |
|---|---|---|---|---|---|
| MODEL-01 | Serialize and parse each model | Contract fields round-trip | Passed in `flutter test` | Pass | `test/models/models_test.dart`, `flutter_test_2026-11-26.png` |
| MODEL-02 | Construct HR estimates below/above allowed range | Typed validation error | Passed in `flutter test`; harness also rejected out-of-range HR (must be 30 and 220 bpm) | Pass | `test/models/models_test.dart`, `harness_log_2026-11-26.png` |
| MODEL-03 | Save poor/invalid signal quality | Value remains available, no silent drop | Passed in `flutter test`; seeded `invalid` reading visible in emulator | Pass | `test/repositories/repositories_test.dart`, `emulator_firestore_2026-11-26.png` |
| MODEL-04 | Construct future timestamp, invalid room range, or no-consent check-in | Typed validation error | Passed in `flutter test` | Pass | `test/models/models_test.dart`, `flutter_test_2026-11-26.png` |
| AUTH-01 | Load signed-in profile from Firestore | Stored role is returned | Passed in `flutter test`; harness sign-in as mother and clinician OK | Pass | `test/services/auth_service_test.dart`, `harness_log_2026-11-26.png` |
| AUTH-02 | Load missing profile | Typed not-found error; no default role | Passed in `flutter test` | Pass | `test/services/auth_service_test.dart` |
| ROLE-01 | Check clinician/mother roles and assignment | Only assigned clinician can view patient | Passed in `flutter test`; harness listed only Demo Mother A for Clinician A | Pass | `test/services/role_guard_test.dart`, `harness_log_2026-11-26.png` |
| FRESH-01 | Compare timestamps around threshold | Old value is stale, recent value is fresh | Passed in `flutter test` | Pass | `test/services/role_guard_test.dart` |
| REPO-01 | Save/watch HR, room, check-in data | Data is returned by repository API | Passed in `flutter test`; harness saved and loaded HR 76 bpm, room 22.5 C / 45% | Pass | `test/repositories/repositories_test.dart`, `harness_log_2026-11-26.png` |
| REPO-02 | Query clinician patients, summary, readings, check-ins, notes | Assigned data is returned; other assignment denied | Passed in `flutter test`; harness loaded Mother A summary, Mother B denied | Pass | `test/repositories/repositories_test.dart`, `harness_log_2026-11-26.png` |
| REPO-03 | Create clinician note and change status | Note and audit entries are both written | Passed in `flutter test`; harness created note and audit log `clinician_note_created` confirmed in emulator | Pass | `test/repositories/repositories_test.dart`, `emulator_clinician_notes_2026-11-26.png`, `audit_logs_2026-11-26.png` |
| RULE-01 | Unauthenticated read and write | Denied | Denied (rules test 1/12) | Pass | `firebase/rules-tests/firestore.rules.test.js`, `rules_tests_2026-11-26.png` |
| RULE-02 | Mother A reads mother B data or edits own role | Denied | Denied (rules tests); harness also denied Mother B read | Pass | `firestore.rules.test.js`, `rules_tests_2026-11-26.png`, `harness_log_2026-11-26.png` |
| RULE-03 | Mother writes clinician note | Denied | Denied (rules tests) | Pass | `firestore.rules.test.js`, `rules_tests_2026-11-26.png` |
| RULE-04 | Clinician reads unassigned mother or deletes a reading | Denied | Denied (rules tests); harness delete and Mother B read denied | Pass | `firestore.rules.test.js`, `harness_log_2026-11-26.png` |
| RULE-05 | Clinician spoofs note author | Denied | Denied (rules tests) | Pass | `firestore.rules.test.js`, `rules_tests_2026-11-26.png` |
| RULE-06 | Update/delete audit log | Denied | Denied (rules tests) | Pass | `firestore.rules.test.js`, `rules_tests_2026-11-26.png` |
| RULE-07 | Normal mother and assigned clinician flows | Allowed only for permitted operations | Allowed (rules tests 4 positive); harness flows OK | Pass | `firestore.rules.test.js`, `harness_log_2026-11-26.png` |
| E2E-01 | Run on a real phone against a real (non-emulator) Firebase project | Works end to end | Not done (emulator and web only) | Not done | - |
| UI-01 | Test with Member 3's UI | Screens use repositories correctly | Not done (UI not yet integrated) | Not done | - |