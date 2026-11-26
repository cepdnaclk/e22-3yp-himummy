import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LullabySelectionScreen extends StatelessWidget {
  const LullabySelectionScreen({Key? key}) : super(key: key);

  final List<String> _lullabies = const [
    'Twinkle Twinkle Little Star',
    'Brahms Lullaby',
    'Rock-a-bye Baby',
    'Soft Nature Sounds',
    'Gentle Music Box',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                    'Select a lullaby',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              const Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: Text(
                  'Choose a soothing melody for your baby',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Lullabies List
              Expanded(
                child: ListView.builder(
                  itemCount: _lullabies.length,
                  itemBuilder: (context, index) {
                    final lullaby = _lullabies[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          // Return selected lullaby name back to Baby Monitor screen
                          Navigator.pop(context, lullaby);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    color: AppColors.primaryPurple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    lullaby,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.primaryPurple,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}