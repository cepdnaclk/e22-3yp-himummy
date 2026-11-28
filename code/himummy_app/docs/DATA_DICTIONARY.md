# HiMummy Firestore data dictionary

All persisted field names are snake_case. Timestamps are Firestore `Timestamp`
values; Dart APIs expose them as `DateTime`. The prototype stores synthetic
sample data only. There are no raw audio or video fields.

## `users/{uid}`

| Field | Type | Meaning / unit | Source |
|---|---|---|---|
| `display_name` | string | Fictional or user display name | Trusted profile provisioning; user may update own display name |
| `email` | string | Firebase account email | Trusted profile provisioning; user may update own email |
| `role` | string | `mother` or `clinician` | Trusted provisioning only; immutable to clients |
| `assigned_clinician_uid` | string, mothers only | UID of assigned clinician | Trusted provisioning only; immutable to clients |
| `created_at` | timestamp | Profile creation time | Trusted provisioning |

## `users/{motherUid}/hr_readings/{id}`

| Field | Type | Meaning / unit | Source |
|---|---|---|---|
| `heart_rate_bpm` | integer | Heart-rate estimate, beats per minute (30–220) | `wearable_ble` or `synthetic` |
| `recorded_at` | timestamp | Capture time; cannot be future | Wearable-reading save request |
| `signal_quality` | string | `good`, `fair`, `poor`, or `invalid`; poor/invalid records are retained | Sensor signal metadata |
| `source` | string | Non-empty origin descriptor | E.g. `wearable_ble`, `synthetic` |

## `users/{motherUid}/room_readings/{id}`

| Field | Type | Meaning / unit | Source |
|---|---|---|---|
| `room_temp_c` | number | Room temperature in degrees Celsius (-10–60) | Baby monitor telemetry |
| `humidity_percent` | number | Relative humidity in percent (0–100) | Baby monitor telemetry |
| `updated_at` | timestamp | Reading update time; cannot be future | Baby monitor telemetry |
| `source` | string | Non-empty origin descriptor | E.g. `synthetic` |

Camera, microphone, raw video, and raw audio payloads are not stored.

## `users/{motherUid}/checkins/{id}`

| Field | Type | Meaning / unit | Source |
|---|---|---|---|
| `answers` | map | Non-empty questionnaire answers keyed by question ID | User check-in |
| `submitted_at` | timestamp | Submission time; cannot be future | User check-in |
| `consent_given` | boolean | Must be `true` to save | User consent |

## `users/{motherUid}/clinician_notes/{id}`

| Field | Type | Meaning / unit | Source |
|---|---|---|---|
| `note_text` | string | Non-empty clinician follow-up note, maximum 2,000 characters | Assigned clinician |
| `author_uid` | string | Firebase UID of the clinician author | Signed-in clinician profile |
| `author_name` | string | Author's profile display name | Signed-in clinician profile |
| `created_at` | timestamp | Creation time; cannot be future | Data layer |
| `review_status` | string | `pending`, `reviewed`, or `follow_up` | Initial value set to `pending`; author may update |

## `audit_logs/{id}`

| Field | Type | Meaning / unit | Source |
|---|---|---|---|
| `actor_uid` | string | UID of the user performing the action | Firebase Authentication |
| `actor_role` | string | `mother` or `clinician`, matching the stored profile | Firestore user profile |
| `action` | string | Non-empty action identifier | Data layer |
| `target_path` | string | Firestore document path affected | Data layer |
| `timestamp` | timestamp | Action time; cannot be future | Data layer |
