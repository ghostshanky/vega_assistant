import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationButtonsWidget extends StatelessWidget {
  final bool showBack;
  final bool showSkip;
  final String primaryButtonText;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final VoidCallback onPrimary;
  final bool isPrimaryLoading;

  const NavigationButtonsWidget({
    Key? key,
    this.showBack = true,
    this.showSkip = true,
    required this.primaryButtonText,
    this.onBack,
    this.onSkip,
    required this.onPrimary,
    this.isPrimaryLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isPrimaryLoading ? null : onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.textPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: isPrimaryLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                      ),
                    )
                  : Text(
                      primaryButtonText,
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 2.h),
          // Secondary navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              if (showBack && onBack != null)
                TextButton.icon(
                  onPressed: onBack,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: AppTheme.textSecondary,
                    size: 4.w,
                  ),
                  label: Text(
                    'Back',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                )
              else
                SizedBox(width: 20.w),
              // Skip button
              if (showSkip && onSkip != null)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                )
              else
                SizedBox(width: 20.w),
            ],
          ),
        ],
      ),
    );
  }
}
