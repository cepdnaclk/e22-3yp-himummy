import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import 'lullaby_selection_screen.dart';

class BabyMonitorScreen extends StatefulWidget {
  const BabyMonitorScreen({Key? key}) : super(key: key);

  @override
  State<BabyMonitorScreen> createState() => _BabyMonitorScreenState();
}

class _BabyMonitorScreenState extends State<BabyMonitorScreen> {
  // Monitor states: 'connected', 'connecting', 'disconnected'
  String _monitorState = 'connected';
  bool _isListening = false;
  bool _isLullabyPlaying = false;
  String _activeLullabyName = '';

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
              
              // Dynamic status subtitle based on current monitor state
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  _getSubTitleText(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Main Video Window / Status Preview Card
              GestureDetector(
                onTap: () {
                  // When connected, tapping "Tap to view securely" transitions to connecting state
                  if (_monitorState == 'connected') {
                    setState(() {
                      _monitorState = 'connecting';
                      _isListening = false;
                      _isLullabyPlaying = false;
                    });
                  }
                },
                child: Container(
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
                        child: Icon(
                          _getCardIcon(),
                          size: 32,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getCardTitle(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getCardSubtitle(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getCardActionText(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
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
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.thermostat, size: 18, color: AppColors.textMuted),
                              SizedBox(width: 6),
                              Text(
                                'Temperature',
                                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _monitorState == 'connected' ? '23°C' : '—',
                            style: const TextStyle(
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
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.water_drop_outlined, size: 18, color: AppColors.textMuted),
                              SizedBox(width: 6),
                              Text(
                                'Humidity',
                                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _monitorState == 'connected' ? '48%' : '—',
                            style: const TextStyle(
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

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_monitorState == 'connected') {
                        _isListening = !_isListening;
                      } else if (_monitorState == 'connecting') {
                        // Action when tapping Connecting...
                      } else {
                        _monitorState = 'connecting';
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _getPrimaryButtonText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),

              // Secondary Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_monitorState == 'connecting') {
                      setState(() {
                        _monitorState = 'disconnected';
                      });
                    } else if (_monitorState == 'disconnected') {
                      setState(() {
                        _monitorState = 'connecting';
                      });
                    } else {
                      if (_isLullabyPlaying) {
                        setState(() {
                          _isLullabyPlaying = false;
                          _activeLullabyName = '';
                        });
                      } else {
                        final selectedLullaby = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LullabySelectionScreen(),
                          ),
                        );

                        if (selectedLullaby != null) {
                          setState(() {
                            _isLullabyPlaying = true;
                            _activeLullabyName = selectedLullaby;
                          });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurpleBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _getSecondaryButtonText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Footer Note
              Center(
                child: Text(
                  _getFooterNoteText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
      
      // Bottom Navigation Bar (Index 1 for Baby)
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  // Helper methods to manage UI text based on state
  String _getSubTitleText() {
    switch (_monitorState) {
      case 'connected':
        if (_isListening && _isLullabyPlaying) {
          return 'Connected · listening & playing $_activeLullabyName';
        } else if (_isListening) {
          return 'Connected · demo audio playing (listening)';
        } else if (_isLullabyPlaying) {
          return 'Connected · playing lullaby ($_activeLullabyName)';
        }
        return 'Connected - demo nursery camera';
      case 'connecting':
        return 'Connecting · establishing a secure link';
      case 'disconnected':
        return 'Camera offline · check power or Wi-Fi';
      default:
        return '';
    }
  }

  IconData _getCardIcon() {
    switch (_monitorState) {
      case 'connected':
        return Icons.camera_alt_outlined;
      case 'connecting':
        return Icons.refresh;
      case 'disconnected':
        return Icons.camera_alt_outlined;
      default:
        return Icons.camera_alt_outlined;
    }
  }

  String _getCardTitle() {
    switch (_monitorState) {
      case 'connected':
        return 'A private little window';
      case 'connecting':
        return 'Connecting your camera...';
      case 'disconnected':
        return 'Camera disconnected';
      default:
        return '';
    }
  }

  String _getCardSubtitle() {
    switch (_monitorState) {
      case 'connected':
        return _isLullabyPlaying ? 'Playing: $_activeLullabyName' : 'Preview hidden for privacy';
      case 'connecting':
        return 'This may take a few moments.';
      case 'disconnected':
        return 'No live preview is available.';
      default:
        return '';
    }
  }

  String _getCardActionText() {
    switch (_monitorState) {
      case 'connected':
        return 'Tap to view securely';
      case 'connecting':
        return 'Waiting for a secure connection';
      case 'disconnected':
        return 'Check your device and try again';
      default:
        return '';
    }
  }

  String _getPrimaryButtonText() {
    switch (_monitorState) {
      case 'connected':
        return _isListening ? 'Stop listening' : 'Listen';
      case 'connecting':
        return 'Connecting...';
      case 'disconnected':
        return 'Reconnect camera';
      default:
        return '';
    }
  }

  String _getSecondaryButtonText() {
    switch (_monitorState) {
      case 'connected':
        return _isLullabyPlaying ? 'Stop lullaby' : 'Play lullaby';
      case 'connecting':
        return 'Cancel connection';
      case 'disconnected':
        return 'Troubleshooting';
      default:
        return '';
    }
  }

  String _getFooterNoteText() {
    switch (_monitorState) {
      case 'connected':
        return 'Sample room readings · no baby vital signs.\nKeep normal in-person checks on your baby.';
      case 'connecting':
        return 'Room readings appear once connected.\nAudio is unavailable while connecting.';
      case 'disconnected':
        return 'No live room readings. Audio is unavailable.\nKeep normal in-person checks on your baby.';
      default:
        return '';
    }
  }
}