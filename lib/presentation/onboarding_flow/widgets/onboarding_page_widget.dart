import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool showAnimation;
  final VoidCallback? onTryVoice;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.showAnimation = false,
    this.onTryVoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          // Main illustration area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background gradient circle
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.accent.withValues(alpha: 0.2),
                          AppTheme.accent.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Main image
                  CustomImageWidget(
                    imageUrl: imagePath,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.contain,
                  ),
                  // Animated VEGA orb overlay
                  if (showAnimation)
                    Positioned(
                      bottom: 5.h,
                      child: _buildAnimatedOrb(),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          // Content area
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                // Description
                Text(
                  description,
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                // Try voice interaction button (only for first screen)
                if (onTryVoice != null) _buildTryVoiceButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOrb() {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: 2),
      tween: Tween(begin: 0.8, end: 1.2),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accent,
                  AppTheme.accent.withValues(alpha: 0.6),
                  AppTheme.accent.withValues(alpha: 0.2),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.textPrimary,
                size: 6.w,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTryVoiceButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: OutlinedButton.icon(
        onPressed: onTryVoice,
        icon: CustomIconWidget(
          iconName: 'record_voice_over',
          color: AppTheme.accent,
          size: 5.w,
        ),
        label: Text(
          'Try saying "Hello VEGA"',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.accent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 6.w),
          side: BorderSide(
              color: AppTheme.accent.withValues(alpha: 0.5), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
