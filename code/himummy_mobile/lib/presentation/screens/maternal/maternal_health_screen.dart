import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../dashboard/home_dashboard_screen.dart';
import '../baby_monitor/baby_monitor_screen.dart';

class MaternalHealthScreen extends StatefulWidget {
  const MaternalHealthScreen({Key? key}) : super(key: key);

  @override
  State<MaternalHealthScreen> createState() => _MaternalHealthScreenState();
}

class _MaternalHealthScreenState extends State<MaternalHealthScreen> {
  // Set index to 2 because 'Health' is the active tab here
  int _currentIndex = 2;

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
                    'Maternal health',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Subtitle
              const Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: Text(
                  'A gentle view of your wellbeing.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Heart-rate Estimate Top Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Heart-rate estimate',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Icon(
                          Icons.favorite_border,
                          color: AppColors.primaryPurple,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '78',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'BPM',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sample reading · not diagnostic\nLast measurement: today, 9:38 AM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Heart-rate History Graph Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heart-rate history',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Today · sample data',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Line Chart Widget matching Figma
                    SizedBox(
                      height: 140,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 15,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: AppColors.borderGrey,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 15,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 2,
                                getTitlesWidget: (value, meta) {
                                  String text = '';
                                  if (value == 2) text = '6 AM';
                                  if (value == 6) text = '8 AM';
                                  if (value == 10) text = '10 AM';
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 12,
                          minY: 60,
                          maxY: 90,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 65),
                                FlSpot(2, 72),
                                FlSpot(4, 68),
                                FlSpot(6, 80),
                                FlSpot(8, 75),
                                FlSpot(10, 83),
                                FlSpot(12, 78),
                              ],
                              isCurved: true,
                              color: AppColors.primaryPurple,
                              barWidth: 2.5,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Wearable Connected Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.watch,
                      color: AppColors.primaryPurple,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Wearable connected',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Demo device · synced 2 min ago',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Care Team Notes Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF7EE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Your care team',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'No follow-up notes yet. Contact your provider if you have any concerns.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar with Health tab selected
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BabyMonitorScreen()),
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