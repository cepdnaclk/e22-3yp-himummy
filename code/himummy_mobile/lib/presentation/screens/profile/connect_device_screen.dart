import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';

class ConnectDeviceScreen extends StatefulWidget {
  const ConnectDeviceScreen({Key? key}) : super(key: key);

  @override
  State<ConnectDeviceScreen> createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  // Selected device state for pairing simulation
  String _selectedDevice = 'camera';

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
                    'Connect a device',
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
                  'A closer connection starts here.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Before you begin instruction box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Before you begin',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Turn on Bluetooth and Wi-Fi.\n2. Keep your device nearby.\n3. Put it into pairing mode.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // Nursery Camera Card
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDevice = 'camera';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedDevice == 'camera' 
                          ? AppColors.primaryPurple 
                          : AppColors.borderGrey,
                      width: _selectedDevice == 'camera' ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurpleBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primaryPurple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Nursery camera',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Nearby · ready to pair',
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
              ),
              
              const SizedBox(height: 12),

              // Wellbeing Wearable Card
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDevice = 'wearable';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedDevice == 'wearable' 
                          ? AppColors.primaryPurple 
                          : AppColors.borderGrey,
                      width: _selectedDevice == 'wearable' ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurpleBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.watch_outlined,
                          color: AppColors.primaryPurple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Wellbeing wearable',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Nearby · ready to pair',
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
              ),
              
              const SizedBox(height: 24),

              // Pair Nursery Camera Button (Primary Style)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle camera pairing action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Pair nursery camera',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),

              // Pair Wearable Button (Updated to match primary button color)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle wearable pairing action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Pair wearable',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Footer Note
              const Center(
                child: Text(
                  'Can\'t find a device? Check power and try again.',
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
}