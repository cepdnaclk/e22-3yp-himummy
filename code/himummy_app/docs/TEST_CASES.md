# HiMummy backend test cases

`Actual result` and `Pass/Fail` are intentionally marked **Not run** until the
corresponding command is executed in an environment with the required toolchain.
The checked-in rules tests and Dart tests are the evidence files.

| ID | Steps | Expected result | Actual result | Pass/Fail | Evidence file |
|---|---|---|---|---|---|
| MODEL-01 | Serialize and parse each model | Contract fields round-trip | Not run | Not run | `test/models/models_test.dart` |
| MODEL-02 | Construct HR estimates below/above allowed range | Typed validation error | Not run | Not run | `test/models/models_test.dart` |
| MODEL-03 | Save poor/invalid signal quality | Value remains available, no silent drop | Not run | Not run | `test/models/models_test.dart`, `test/repositories/repositories_test.dart` |
| MODEL-04 | Construct future timestamp, invalid room range, or no-consent check-in | Typed validation error | Not run | Not run | `test/models/models_test.dart` |
| AUTH-01 | Load signed-in profile from Firestore | Stored role is returned | Not run | Not run | `test/services/auth_service_test.dart` |
| AUTH-02 | Load missing profile | Typed not-found error; no default role | Not run | Not run | `test/services/auth_service_test.dart` |
| ROLE-01 | Check clinician/mother roles and assignment | Only assigned clinician can view patient | Not run | Not run | `test/services/role_guard_test.dart` |
| FRESH-01 | Compare timestamps around threshold | Old value is stale, recent value is fresh | Not run | Not run | `test/services/role_guard_test.dart` |
| REPO-01 | Save/watch HR, room, check-in data | Data is returned by repository API | Not run | Not run | `test/repositories/repositories_test.dart` |
| REPO-02 | Query clinician patients, summary, readings, check-ins, notes | Assigned data is returned; other assignment denied | Not run | Not run | `test/repositories/repositories_test.dart` |
| REPO-03 | Create clinician note and change status | Note and audit entries are both written | Not run | Not run | `test/repositories/repositories_test.dart` |
| RULE-01 | Unauthenticated read and write | Denied | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
| RULE-02 | Mother A reads mother B data or edits own role | Denied | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
| RULE-03 | Mother writes clinician note | Denied | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
| RULE-04 | Clinician reads unassigned mother or deletes a reading | Denied | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
| RULE-05 | Clinician spoofs note author | Denied | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
| RULE-06 | Update/delete audit log | Denied | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
| RULE-07 | Normal mother and assigned clinician flows | Allowed only for permitted operations | Not run | Not run | `firebase/rules-tests/firestore.rules.test.js` |
