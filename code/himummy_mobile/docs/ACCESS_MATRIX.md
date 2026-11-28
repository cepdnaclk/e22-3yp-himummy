# HiMummy access matrix

The Firestore rules require authentication and deny unspecified access. "Own"
means the authenticated mother's own user path. "Assigned" means the mother
document's `assigned_clinician_uid` equals the authenticated clinician UID.

| Role | Collection / document | Read | Create | Update | Delete |
|---|---|---:|---:|---:|---:|
| Unauthenticated | All data | No | No | No | No |
| Mother | Own `users/{uid}` profile | Yes | No | Yes, display name/email only | No |
| Mother | Other users' profiles and subcollections | No | No | No | No |
| Mother | Own `hr_readings` | Yes | Yes, validated | Yes, validated | Yes |
| Mother | Own `room_readings` | Yes | Yes, validated | Yes, validated | Yes |
| Mother | Own `checkins` | Yes | Yes, validated with consent | Yes, validated with consent | Yes |
| Mother | Any `clinician_notes` | No | No | No | No |
| Mother | `audit_logs` | No | Yes, own actor identity | No | No |
| Clinician | Own `users/{uid}` profile | Yes | No | Yes, display name/email only | No |
| Clinician | Assigned mother's profile | Yes | No | No | No |
| Clinician | Unassigned mother's profile/data | No | No | No | No |
| Clinician | Assigned mother's HR/room/check-ins | Yes | No | No | No |
| Clinician | Assigned mother's clinician notes | Yes | Yes, own author identity | Own note review status only | No |
| Clinician | `audit_logs` | Own clinician entries only | Yes, own actor identity | No | No |
| Any other signed-in role | Other paths/collections | No | No | No | No |

All writes are field- and range-validated in rules where practical. Roles,
profile creation, and clinician assignment require trusted provisioning; the
mobile client cannot assign roles or patients.
