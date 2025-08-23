import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesSection extends StatelessWidget {
  final bool responseConfirmations;
  final bool errorAlerts;
  final bool backgroundService;
  final Function(bool) onResponseConfirmationsChanged;
  final Function(bool) onErrorAlertsChanged;
  final Function(bool) onBackgroundServiceChanged;

  const NotificationPreferencesSection({
    super.key,
    required this.responseConfirmations,
    required this.errorAlerts,
    required this.backgroundService,
    required this.onResponseConfirmationsChanged,
    required this.onErrorAlertsChanged,
    required this.onBackgroundServiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.subtleElevation,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSwitchTile(
            title: 'Response Confirmations',
            subtitle: 'Notify when tasks are completed',
            value: responseConfirmations,
            onChanged: onResponseConfirmationsChanged,
            icon: 'check_circle',
          ),
          SizedBox(height: 1.h),
          _buildSwitchTile(
            title: 'Error Alerts',
            subtitle: 'Show notifications for failed operations',
            value: errorAlerts,
            onChanged: onErrorAlertsChanged,
            icon: 'error',
          ),
          SizedBox(height: 1.h),
          _buildSwitchTile(
            title: 'Background Service',
            subtitle: 'Keep VEGA running in background',
            value: backgroundService,
            onChanged: onBackgroundServiceChanged,
            icon: 'cloud',
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.accent,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accent,
            activeTrackColor: AppTheme.accent.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.border,
          ),
        ],
      ),
    );
  }
}
