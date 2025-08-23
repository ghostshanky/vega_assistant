import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              final isActive = index == currentStep;
              final isCompleted = index < currentStep;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isActive ? 8.w : 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted
                        ? AppTheme.accent
                        : AppTheme.border,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          // Step counter text
          Text(
            '${currentStep + 1} of $totalSteps',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
