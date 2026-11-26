import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../screens/dashboard/home_dashboard_screen.dart';
import '../screens/baby_monitor/baby_monitor_screen.dart';
import '../screens/maternal/maternal_health_screen.dart';
import '../screens/check_in/daily_check_in_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          Widget targetScreen;
          switch (index) {
            case 0:
              targetScreen = const HomeDashboardScreen();
              break;
            case 1:
              targetScreen = const BabyMonitorScreen();
              break;
            case 2:
              targetScreen = const MaternalHealthScreen();
              break;
            case 3:
              targetScreen = const DailyCheckInScreen();
              break;
            case 4:
              targetScreen = const ProfileScreen();
              break;
            default:
              return;
          }

          // Using pushAndRemoveUntil to ensure clean navigation across all tabs
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
            (route) => false,
          );
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent, // Let container handle background
        elevation: 0,
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