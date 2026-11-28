import 'package:material_ui/material_ui.dart';
import 'package:himummy_mobile/core/constants/app_colors.dart';
import 'package:himummy_mobile/core/errors/app_exception.dart';
import 'package:himummy_mobile/data/models/checkin.dart';
import 'package:himummy_mobile/data/models/clinician_note.dart';
import 'package:himummy_mobile/data/models/hr_reading.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';
import 'package:himummy_mobile/data/repositories/clinician_repository.dart';

/// Read-only patient data plus follow-up notes for an assigned mother.
class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({super.key, required this.patient});

  final UserProfile patient;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  final ClinicianRepository _repository = ClinicianRepository();
  final TextEditingController _noteController = TextEditingController();
  late final Stream<List<HrReading>> _hr =
      _repository.watchPatientHrReadings(widget.patient.uid, limit: 10);
  late final Stream<List<ClinicianNote>> _notes =
      _repository.watchPatientNotes(widget.patient.uid);
  late final Future<List<Checkin>> _checkins =
      _repository.getPatientCheckins(widget.patient.uid);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  }

  Future<void> _addNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Please write a note first.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _repository.addFollowUpNote(widget.patient.uid, text);
      _noteController.clear();
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not save the note.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _card(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: Text(
          widget.patient.displayName,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _card(
            'Heart-rate estimates (not diagnostic)',
            StreamBuilder<List<HrReading>>(
              stream: _hr,
              builder: (context, s) {
                if (s.hasError) return const Text('Could not load readings.');
                if (!s.hasData) return const LinearProgressIndicator();
                if (s.data!.isEmpty) return const Text('No readings yet.');
                return Column(
                  children: [
                    for (final r in s.data!)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${r.heartRateBpm} bpm · ${r.signalQuality}'),
                            Text(_time(r.recordedAt),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          _card(
            'Check-ins',
            FutureBuilder<List<Checkin>>(
              future: _checkins,
              builder: (context, s) {
                if (s.hasError) return const Text('Could not load check-ins.');
                if (!s.hasData) return const LinearProgressIndicator();
                if (s.data!.isEmpty) return const Text('No check-ins yet.');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final c in s.data!.take(5))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${_time(c.submittedAt)}\n'
                          'Mood: ${c.answers['mood'] ?? '-'} · '
                          'Sleep: ${c.answers['sleep'] ?? '-'} · '
                          'Energy: ${c.answers['energy'] ?? '-'}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          _card(
            'Follow-up notes',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<List<ClinicianNote>>(
                  stream: _notes,
                  builder: (context, s) {
                    if (s.hasError) return const Text('Could not load notes.');
                    if (!s.hasData) return const LinearProgressIndicator();
                    if (s.data!.isEmpty) return const Text('No notes yet.');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final n in s.data!)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${n.noteText}\n'
                              '${n.authorName} · ${_time(n.createdAt)} · ${n.reviewStatus}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Add a follow-up note...',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _saving ? null : _addNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save note'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}