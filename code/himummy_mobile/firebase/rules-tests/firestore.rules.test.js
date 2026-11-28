const fs = require('node:fs');
const path = require('node:path');
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
  Timestamp,
} = require('firebase/firestore');

const projectId = 'himummy-rules-test';
let testEnv;
const oldTime = Timestamp.fromDate(new Date(Date.now() - 1000));
jest.setTimeout(15000);

const motherA = {
  display_name: 'Demo Mother A',
  email: 'demo.mother.a@himummy.test',
  role: 'mother',
  assigned_clinician_uid: 'clinician-a',
  created_at: oldTime,
};
const motherB = {
  display_name: 'Demo Mother B',
  email: 'demo.mother.b@himummy.test',
  role: 'mother',
  assigned_clinician_uid: 'clinician-b',
  created_at: oldTime,
};
const clinicianA = {
  display_name: 'Demo Clinician A',
  email: 'demo.clinician.a@himummy.test',
  role: 'clinician',
  created_at: oldTime,
};
const clinicianB = {
  display_name: 'Demo Clinician B',
  email: 'demo.clinician.b@himummy.test',
  role: 'clinician',
  created_at: oldTime,
};

function hrReading() {
  return {
    heart_rate_bpm: 82,
    recorded_at: oldTime,
    signal_quality: 'poor',
    source: 'synthetic',
  };
}

function auditLog(actorUid, actorRole) {
  return {
    actor_uid: actorUid,
    actor_role: actorRole,
    action: 'test_action',
    target_path: 'users/mother-a/hr_readings/test',
    timestamp: oldTime,
  };
}

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      host: '127.0.0.1',
      port: 8080,
      rules: fs.readFileSync(
        path.resolve(__dirname, '../firestore.rules'),
        'utf8',
      ),
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await Promise.all([
      setDoc(doc(db, 'users/mother-a'), motherA),
      setDoc(doc(db, 'users/mother-b'), motherB),
      setDoc(doc(db, 'users/clinician-a'), clinicianA),
      setDoc(doc(db, 'users/clinician-b'), clinicianB),
      setDoc(doc(db, 'users/mother-a/hr_readings/reading-a'), hrReading()),
      setDoc(doc(db, 'users/mother-b/hr_readings/reading-b'), hrReading()),
      setDoc(doc(db, 'users/mother-a/clinician_notes/note-a'), {
        note_text: 'Synthetic note',
        author_uid: 'clinician-a',
        author_name: 'Demo Clinician A',
        created_at: oldTime,
        review_status: 'pending',
      }),
    ]);
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

describe('HiMummy Firestore access rules', () => {
  test('denies unauthenticated reads and writes', async () => {
    const db = testEnv.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, 'users/mother-a')));
    await assertFails(
      setDoc(doc(db, 'users/mother-a/hr_readings/unauth'), hrReading()),
    );
  });

  test('denies mother A access to mother B data', async () => {
    const db = testEnv.authenticatedContext('mother-a').firestore();
    await assertFails(getDoc(doc(db, 'users/mother-b/hr_readings/reading-b')));
  });

  test('denies mother role changes', async () => {
    const db = testEnv.authenticatedContext('mother-a').firestore();
    await assertFails(updateDoc(doc(db, 'users/mother-a'), { role: 'clinician' }));
  });

  test('denies mothers from creating clinician notes', async () => {
    const db = testEnv.authenticatedContext('mother-a').firestore();
    await assertFails(
      setDoc(doc(db, 'users/mother-a/clinician_notes/not-allowed'), {
        note_text: 'Unauthorized',
        author_uid: 'mother-a',
        author_name: 'Demo Mother A',
        created_at: oldTime,
        review_status: 'pending',
      }),
    );
  });

  test('denies clinicians from reading unassigned mothers', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    await assertFails(getDoc(doc(db, 'users/mother-b/hr_readings/reading-b')));
  });

  test('denies clinician deletion of readings', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    await assertFails(
      deleteDoc(doc(db, 'users/mother-a/hr_readings/reading-a')),
    );
  });

  test('denies a clinician note with spoofed author UID', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    await assertFails(
      setDoc(doc(db, 'users/mother-a/clinician_notes/spoofed'), {
        note_text: 'Synthetic follow-up',
        author_uid: 'clinician-b',
        author_name: 'Demo Clinician A',
        created_at: oldTime,
        review_status: 'pending',
      }),
    );
  });

  test('denies audit log update and deletion', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    const log = doc(db, 'audit_logs/immutable-log');
    await setDoc(log, auditLog('clinician-a', 'clinician'));
    await assertFails(updateDoc(log, { action: 'changed' }));
    await assertFails(deleteDoc(log));
  });

  test('allows mothers to read and save their own valid readings and check-ins', async () => {
    const db = testEnv.authenticatedContext('mother-a').firestore();
    await assertSucceeds(getDoc(doc(db, 'users/mother-a/hr_readings/reading-a')));
    await assertSucceeds(
      setDoc(doc(db, 'users/mother-a/hr_readings/new-reading'), hrReading()),
    );
    await assertSucceeds(
      setDoc(doc(db, 'users/mother-a/room_readings/new-room'), {
        room_temp_c: 22.4,
        humidity_percent: 48.5,
        updated_at: oldTime,
        source: 'synthetic',
      }),
    );
    await assertSucceeds(
      setDoc(doc(db, 'users/mother-a/checkins/new-checkin'), {
        answers: { mood: 'okay' },
        submitted_at: oldTime,
        consent_given: true,
      }),
    );
  });

  test('allows an assigned clinician to list assigned patients and read data', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    const patients = query(
      collection(db, 'users'),
      where('role', '==', 'mother'),
      where('assigned_clinician_uid', '==', 'clinician-a'),
    );
    const result = await assertSucceeds(getDocs(patients));
    expect(result.docs.map((snapshot) => snapshot.id)).toEqual(['mother-a']);
    await assertSucceeds(getDoc(doc(db, 'users/mother-a/hr_readings/reading-a')));
  });

  test('allows assigned clinician note creation and own review-status update', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    await assertSucceeds(
      setDoc(doc(db, 'users/mother-a/clinician_notes/new-note'), {
        note_text: 'Synthetic follow-up',
        author_uid: 'clinician-a',
        author_name: 'Demo Clinician A',
        created_at: serverTimestamp(),
        review_status: 'pending',
      }),
    );
    await assertSucceeds(
      updateDoc(doc(db, 'users/mother-a/clinician_notes/note-a'), {
        review_status: 'reviewed',
      }),
    );
  });

  test('allows a signed-in actor to create an attributable audit entry', async () => {
    const db = testEnv.authenticatedContext('clinician-a').firestore();
    await assertSucceeds(
      setDoc(
        doc(db, 'audit_logs/clinician-created'),
        auditLog('clinician-a', 'clinician'),
      ),
    );
  });
});
