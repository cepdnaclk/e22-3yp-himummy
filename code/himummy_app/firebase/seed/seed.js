const admin = require('firebase-admin');

const firestoreHost = process.env.FIRESTORE_EMULATOR_HOST;
const authHost = process.env.FIREBASE_AUTH_EMULATOR_HOST;

if (!firestoreHost || !authHost) {
  throw new Error(
    'Seed stopped: both Firestore and Auth emulator environment variables are required.',
  );
}
if (
  !['localhost', '127.0.0.1'].includes(firestoreHost.split(':')[0]) ||
  !['localhost', '127.0.0.1'].includes(authHost.split(':')[0])
) {
  throw new Error('Seed stopped: emulator hosts must be local.');
}

const projectId = process.env.GCLOUD_PROJECT || 'himummy-demo';
const app = admin.initializeApp({ projectId });
const auth = admin.auth(app);
const db = admin.firestore(app);
const syntheticPassword = 'DemoOnly123!';

const people = [
  {
    uid: 'demo-clinician-a',
    role: 'clinician',
    displayName: 'Demo Clinician A',
    email: 'demo.clinician.a@himummy.test',
  },
  {
    uid: 'demo-clinician-b',
    role: 'clinician',
    displayName: 'Demo Clinician B',
    email: 'demo.clinician.b@himummy.test',
  },
  {
    uid: 'demo-mother-a',
    role: 'mother',
    displayName: 'Demo Mother A',
    email: 'demo.mother.a@himummy.test',
    assignedClinicianUid: 'demo-clinician-a',
  },
  {
    uid: 'demo-mother-b',
    role: 'mother',
    displayName: 'Demo Mother B',
    email: 'demo.mother.b@himummy.test',
    assignedClinicianUid: 'demo-clinician-b',
  },
];

async function ensureAuthUser(person) {
  try {
    await auth.getUser(person.uid);
    await auth.updateUser(person.uid, {
      email: person.email,
      password: syntheticPassword,
      displayName: person.displayName,
    });
  } catch (error) {
    if (error.code !== 'auth/user-not-found') throw error;
    await auth.createUser({
      uid: person.uid,
      email: person.email,
      password: syntheticPassword,
      displayName: person.displayName,
    });
  }
}

async function seedProfile(person) {
  await db.collection('users').doc(person.uid).set({
    display_name: person.displayName,
    email: person.email,
    role: person.role,
    ...(person.assignedClinicianUid
      ? { assigned_clinician_uid: person.assignedClinicianUid }
      : {}),
    created_at: admin.firestore.Timestamp.now(),
  });
}

async function seedMother(mother, clinician) {
  const now = Date.now();
  const batch = db.batch();
  const root = db.collection('users').doc(mother.uid);

  for (let index = 0; index < 50; index += 1) {
    const recordedAt = new Date(now - (49 - index) * 5 * 60 * 1000);
    const qualities = ['good', 'good', 'fair', 'poor', 'invalid'];
    const quality = qualities[index % qualities.length];
    batch.set(root.collection('hr_readings').doc(`synthetic-${index + 1}`), {
      heart_rate_bpm: 68 + ((index * 7) % 35),
      recorded_at: admin.firestore.Timestamp.fromDate(recordedAt),
      signal_quality: quality,
      source: 'synthetic',
    });
  }

  for (let index = 0; index < 4; index += 1) {
    batch.set(root.collection('room_readings').doc(`synthetic-${index + 1}`), {
      room_temp_c: 20.5 + index * 0.4,
      humidity_percent: 42 + index * 3,
      updated_at: admin.firestore.Timestamp.fromDate(
        new Date(now - (3 - index) * 60 * 60 * 1000),
      ),
      source: 'synthetic',
    });
  }

  for (let index = 0; index < 3; index += 1) {
    batch.set(root.collection('checkins').doc(`synthetic-${index + 1}`), {
      answers: {
        mood: ['okay', 'good', 'tired'][index],
        rest_hours: 6 + index,
      },
      submitted_at: admin.firestore.Timestamp.fromDate(
        new Date(now - (2 - index) * 24 * 60 * 60 * 1000),
      ),
      consent_given: true,
    });
  }

  const noteText = `Synthetic follow-up note for ${mother.displayName}.`;
  batch.set(root.collection('clinician_notes').doc('synthetic-note'), {
    note_text: noteText,
    author_uid: clinician.uid,
    author_name: clinician.displayName,
    created_at: admin.firestore.Timestamp.now(),
    review_status: 'pending',
  });
  await batch.commit();
}

async function main() {
  for (const person of people) {
    await ensureAuthUser(person);
    await seedProfile(person);
  }
  await seedMother(people[2], people[0]);
  await seedMother(people[3], people[1]);

  console.log('Created emulator-only synthetic demo accounts:');
  for (const person of people) {
    console.log(
      `${person.role}: ${person.email} / ${syntheticPassword} (UID: ${person.uid})`,
    );
  }
  console.log('Synthetic sample data seeded. No audio or video was stored.');
  await app.delete();
}

main().catch(async (error) => {
  console.error('Seed failed:', error);
  await app.delete();
  process.exitCode = 1;
});
