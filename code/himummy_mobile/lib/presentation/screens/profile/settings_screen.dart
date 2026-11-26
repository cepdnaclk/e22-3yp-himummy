import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Toggle states for notifications
  bool _dailyCheckInReminder = true;
  bool _deviceAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Button and Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Subtitle matching Figma design
              const Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: Text(
                  'Make HiMummy feel right for you.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Notifications Section Header
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 14),

              // Daily check-in reminder toggle card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Daily check-in reminder',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'A gentle nudge at 8:00 PM',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _dailyCheckInReminder,
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.primaryPurple,
                      onChanged: (value) {
                        setState(() {
                          _dailyCheckInReminder = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Device alerts toggle card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Device alerts',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Connection and battery updates',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _deviceAlerts,
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.primaryPurple,
                      onChanged: (value) {
                        setState(() {
                          _deviceAlerts = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Privacy & access Section Header
              const Text(
                'Privacy & access',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 14),

              // Healthcare-provider sharing menu item
              _buildSettingsMenuItem(
                title: 'Healthcare-provider sharing',
                subtitle: 'Manage consent and access',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              // App security menu item
              _buildSettingsMenuItem(
                title: 'App security',
                subtitle: 'Password and screen lock',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              // You're in control banner card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'You\'re in control',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Only authorised providers can access information you choose to share.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Footer version note
              const Center(
                child: Text(
                  'HiMummy · Version 1.0 · Concept',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar (Index 4 for Profile)
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  // Helper widget for menu items with arrow
  Widget _buildSettingsMenuItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}