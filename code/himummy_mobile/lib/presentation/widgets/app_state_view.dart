import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Enum representing different asynchronous UI states
enum ViewState { loading, connected, disconnected, error }

class AppStateView extends StatelessWidget {
  final ViewState state;
  final Widget child;
  final VoidCallback? onRetry;
  final String? errorMessage;

  const AppStateView({
    Key? key,
    required this.state,
    required this.child,
    this.onRetry,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Switch based on the current view state to render appropriate UI
    switch (state) {
      // Display loading indicator and text when data is fetching
      case ViewState.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: AppColors.primaryPurple,
              ),
              SizedBox(height: 16),
              Text(
                'Connecting to baby monitor...',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        );

      // Display disconnected state with reconnect button when offline/disconnected
      case ViewState.disconnected:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightPurpleBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam_off_outlined,
                    size: 40,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Device Disconnected',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please check if the nursery camera is powered on and connected to Wi-Fi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                if (onRetry != null)
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reconnect',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

      // Display generic error state when something goes wrong
      case ViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage ?? 'Unable to load stream data. Please try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
                if (onRetry != null)
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, color: AppColors.primaryPurple),
                    label: const Text(
                      'Try Again',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

      // Render the normal child widget when connected successfully
      case ViewState.connected:
      default:
        return child;
    }
  }
}