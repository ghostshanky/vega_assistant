import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InitializationStatus extends StatelessWidget {
  final List<Map<String, dynamic>> statusItems;

  const InitializationStatus({
    Key? key,
    required this.statusItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: statusItems.map((item) => _buildStatusItem(item)).toList(),
      ),
    );
  }

  Widget _buildStatusItem(Map<String, dynamic> item) {
    final String title = item['title'] as String;
    final bool isCompleted = item['isCompleted'] as bool;
    final bool isLoading = item['isLoading'] as bool;
    final String? error = item['error'] as String?;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          // Status icon
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: error != null
                ? CustomIconWidget(
                    iconName: 'error',
                    color: AppTheme.error,
                    size: 20,
                  )
                : isCompleted
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.success,
                        size: 20,
                      )
                    : isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.accent,
                              ),
                            ),
                          )
                        : CustomIconWidget(
                            iconName: 'radio_button_unchecked',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
          ),

          SizedBox(width: 3.w),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: error != null
                        ? AppTheme.error
                        : isCompleted
                            ? AppTheme.success
                            : AppTheme.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (error != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    error,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.error.withValues(alpha: 0.8),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
