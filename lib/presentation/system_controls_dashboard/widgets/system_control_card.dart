import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final bool isActive;
  final VoidCallback onToggle;
  final VoidCallback? onVoiceCommand;
  final VoidCallback? onLongPress;
  final Color? activeColor;
  final Color? inactiveColor;

  const SystemControlCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.isActive,
    required this.onToggle,
    this.onVoiceCommand,
    this.onLongPress,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = isActive
        ? (activeColor ?? AppTheme.success).withValues(alpha: 0.1)
        : AppTheme.surface;

    final borderColor =
        isActive ? (activeColor ?? AppTheme.success) : AppTheme.border;

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress?.call();
      },
      child: Card(
        elevation: 2,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: borderColor,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: isActive
                                ? (activeColor ?? AppTheme.success)
                                : AppTheme.textSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: iconName,
                            color: AppTheme.textPrimary,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppTheme.darkTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                subtitle,
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onVoiceCommand != null)
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onVoiceCommand!();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.accent,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isActive ? 'ON' : 'OFF',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: isActive
                          ? (activeColor ?? AppTheme.success)
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: isActive,
                    onChanged: (_) {
                      HapticFeedback.selectionClick();
                      onToggle();
                    },
                    activeColor: activeColor ?? AppTheme.success,
                    inactiveThumbColor: AppTheme.textSecondary,
                    inactiveTrackColor: AppTheme.border,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
