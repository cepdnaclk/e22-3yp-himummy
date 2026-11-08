import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../dashboard/home_dashboard_screen.dart';
import '../baby_monitor/baby_monitor_screen.dart';
import '../maternal/maternal_health_screen.dart';
import 'check_in_confirmation_screen.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({Key? key}) : super(key: key);

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  // State variables to hold selected questionnaire values
  int _selectedMoodIndex = -1;
  final Set<String> _selectedEmotions = {};
  String _selectedSleep = '';
  String _selectedEnergy = '';
  final TextEditingController _journalController = TextEditingController();
  
  // Set index to 3 because 'Check-in' is the active tab here
  int _currentIndex = 3;

  // 5-Stage mood faces data using type inference to avoid bracket issues
  final _moods = [
    {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Very low'},
    {'icon': Icons.sentiment_dissatisfied, 'label': 'Low'},
    {'icon': Icons.sentiment_neutral, 'label': 'Okay'},
    {'icon': Icons.sentiment_satisfied, 'label': 'Good'},
    {'icon': Icons.sentiment_very_satisfied, 'label': 'Great'},
  ];

  // Emotional well-being tags for maternal mental health
  final _emotionTags = [
    'Overwhelmed',
    'Anxious',
    'Tearful',
    'Isolated',
    'Calm & Present'
  ];

  // Sleep quality options
  final _sleepOptions = ['Broken & Exhausted', 'Moderate', 'Restful'];

  // Energy level options
  final _energyOptions = ['Depleted', 'Low', 'Stable', 'Replenished'];

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
                    'Daily check-in',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Subtitle with date
              const Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: Text(
                  'Today, 4 November · just a minute for you',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              
              const SizedBox(height: 28),

              // Question 1: 5-Stage Mood Evaluation
              _buildSectionTitle('How are you feeling?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_moods.length, (index) {
                  final isSelected = _selectedMoodIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMoodIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.lightPurpleBg : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryPurple : AppColors.borderGrey,
                            ),
                          ),
                          child: Icon(
                            _moods[index]['icon'] as IconData,
                            size: 28,
                            color: isSelected ? AppColors.primaryPurple : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _moods[index]['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? AppColors.primaryPurple : AppColors.textMuted,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 28),

              // Question 2: Emotional Well-being Tags
              _buildSectionTitle('How are you doing emotionally?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _emotionTags.map((tag) {
                  final isSelected = _selectedEmotions.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedEmotions.add(tag);
                        } else {
                          _selectedEmotions.remove(tag);
                        }
                      });
                    },
                    selectedColor: AppColors.lightPurpleBg,
                    backgroundColor: AppColors.cardWhite,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.primaryPurple : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryPurple : AppColors.borderGrey,
                      ),
                    ),
                    elevation: 0,
                    pressElevation: 0,
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Question 3: Sleep Quality
              _buildSectionTitle('How was your sleep?'),
              const SizedBox(height: 12),
              _buildChoiceChips(
                options: _sleepOptions,
                selectedValue: _selectedSleep,
                onSelected: (value) {
                  setState(() {
                    _selectedSleep = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              // Question 4: Energy Level
              _buildSectionTitle('How is your energy?'),
              const SizedBox(height: 12),
              _buildChoiceChips(
                options: _energyOptions,
                selectedValue: _selectedEnergy,
                onSelected: (value) {
                  setState(() {
                    _selectedEnergy = value;
                  });
                },
              ),
              
              const SizedBox(height: 28),

              // Question 5: Optional Journal Note
              _buildSectionTitle('Anything else? (optional)'),
              const SizedBox(height: 12),
              TextField(
                controller: _journalController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'A thought, a worry, or a tiny win you\'d like to share...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryPurple),
                  ),
                ),
              ),
              
              const SizedBox(height: 36),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckInConfirmationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Footer Note
              const Center(
                child: Text(
                  'A small step towards understanding yourself.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar with Check-in tab selected
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
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MaternalHealthScreen()),
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

  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  // Helper widget for selectable choice chips
  Widget _buildChoiceChips({
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onSelected(option);
            }
          },
          selectedColor: AppColors.lightPurpleBg,
          backgroundColor: AppColors.cardWhite,
          labelStyle: TextStyle(
            fontSize: 13,
            color: isSelected ? AppColors.primaryPurple : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primaryPurple : AppColors.borderGrey,
            ),
          ),
          elevation: 0,
          pressElevation: 0,
        );
      }).toList(),
    );
  }
}