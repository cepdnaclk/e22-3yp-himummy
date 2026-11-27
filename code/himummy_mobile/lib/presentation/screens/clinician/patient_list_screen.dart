import 'package:flutter/material.dart';
import 'package:himummy_mobile/core/constants/app_colors.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';
import 'package:himummy_mobile/data/repositories/clinician_repository.dart';
import 'package:himummy_mobile/data/services/auth_service.dart';
import 'package:himummy_mobile/presentation/screens/auth/login_screen.dart';
import 'package:himummy_mobile/presentation/screens/clinician/patient_detail_screen.dart';

/// Clinician home: list of mothers assigned to the signed-in clinician.
class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final ClinicianRepository _repository = ClinicianRepository();
  final AuthService _authService = AuthService();
  late final Stream<List<UserProfile>> _patients =
      _repository.watchAssignedPatients();

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Assigned patients',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _signOut,
            child: const Text('Sign out',
                style: TextStyle(color: AppColors.primaryPurple)),
          ),
        ],
      ),
      body: StreamBuilder<List<UserProfile>>(
        stream: _patients,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load patients.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final patients = snapshot.data!;
          if (patients.isEmpty) {
            return const Center(child: Text('No patients assigned.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: patients.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = patients[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientDetailScreen(patient: p),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline,
                          color: AppColors.primaryPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          p.displayName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: AppColors.textMuted),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}