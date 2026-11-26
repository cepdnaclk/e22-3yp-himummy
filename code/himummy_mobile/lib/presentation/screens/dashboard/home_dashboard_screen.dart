import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import '../baby_monitor/baby_monitor_screen.dart';
import '../maternal/maternal_health_screen.dart';
import '../check_in/daily_check_in_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header row with greeting and notification icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.favorite_border,
                        color: AppColors.primaryPurple,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'HiMummy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Welcome title matching Figma design
              const Text(
                'Welcome, Mum!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              
              const SizedBox(height: 6),
              
              const Text(
                'A little care for you and your baby.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Wellbeing banner card
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
                      'Your wellbeing matters',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'One gentle moment at a time.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Navigation card items matching Figma features
              _buildFeatureCard(
                title: 'Baby Monitor',
                subtitle: 'Stay close, wherever you are.',
                icon: Icons.videocam_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BabyMonitorScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureCard(
                title: 'Maternal Health',
                subtitle: 'A little insight into your wellbeing.',
                icon: Icons.favorite_border,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaternalHealthScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureCard(
                title: 'Daily Check-in',
                subtitle: 'How are you feeling today?',
                icon: Icons.assignment_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DailyCheckInScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Footer branding note
              const Center(
                child: Text(
                  'Made for your everyday moments of care.',
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
      
      // Bottom Navigation Bar using the reusable AppBottomNav widget for Home (Index 0)
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // Helper widget to build reusable feature cards
  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightPurpleBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}