import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../dashboard/home_dashboard_screen.dart';
import '../maternal/maternal_health_screen.dart'; // We will create this next
import '../check_in/daily_check_in_screen.dart'; // We will create this next

class BabyMonitorScreen extends StatefulWidget {
  const BabyMonitorScreen({Key? key}) : super(key: key);

  @override
  State<BabyMonitorScreen> createState() => _BabyMonitorScreenState();
}

class _BabyMonitorScreenState extends State<BabyMonitorScreen> {
  // Set index to 1 because 'Baby' is the active tab here
  int _currentIndex = 1;

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
              // Top Navigation Bar with Back Button and Title
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
                    'Baby monitor',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Connected camera status subtitle
              const Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: Text(
                  'Connected - demo nursery camera',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Private Video Window Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 32,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A private little window',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Preview hidden for privacy',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap to view securely',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Temperature and Humidity Sensor Cards Side by Side
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.thermostat, size: 18, color: AppColors.textMuted),
                              SizedBox(width: 6),
                              Text(
                                'Temperature',
                                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '23°C',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined, size: 18, color: AppColors.textMuted),
                              SizedBox(width: 6),
                              Text(
                                'Humidity',
                                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '48%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Listen Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Listen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),

              // Play Lullaby Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurpleBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Play lullaby',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Disclaimer Footer Note
              const Center(
                child: Text(
                  'Sample room readings · no baby vital signs.\nKeep normal in-person checks on your baby.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar added matching the design
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle tab switching
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardWhite,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            activeIcon: Icon(Icons.videocam),
            label: 'Baby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Check-in',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}