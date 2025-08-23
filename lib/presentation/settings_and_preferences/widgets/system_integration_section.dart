import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemIntegrationSection extends StatelessWidget {
  final Map<String, bool> permissions;
  final Function(String) onReauthorizePermission;

  const SystemIntegrationSection({
    super.key,
    required this.permissions,
    required this.onReauthorizePermission,
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
            'System Integration',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...permissions.entries.map((entry) => _buildPermissionTile(
                entry.key,
                entry.value,
              )),
        ],
      ),
    );
  }

  Widget _buildPermissionTile(String permission, bool isGranted) {
    final permissionData = _getPermissionData(permission);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: permissionData['icon'] as String,
            color: isGranted ? AppTheme.success : AppTheme.warning,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permissionData['title'] as String,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  permissionData['subtitle'] as String,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: isGranted
                  ? AppTheme.success.withValues(alpha: 0.2)
                  : AppTheme.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isGranted ? 'Granted' : 'Denied',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: isGranted ? AppTheme.success : AppTheme.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!isGranted) ...[
            SizedBox(width: 2.w),
            TextButton(
              onPressed: () => onReauthorizePermission(permission),
              child: Text(
                'Grant',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, String> _getPermissionData(String permission) {
    switch (permission) {
      case 'microphone':
        return {
          'title': 'Microphone',
          'subtitle': 'Voice input and commands',
          'icon': 'mic',
        };
      case 'contacts':
        return {
          'title': 'Contacts',
          'subtitle': 'Call and message contacts',
          'icon': 'contacts',
        };
      case 'phone':
        return {
          'title': 'Phone',
          'subtitle': 'Make phone calls',
          'icon': 'phone',
        };
      case 'system_settings':
        return {
          'title': 'System Settings',
          'subtitle': 'Control WiFi, Bluetooth, etc.',
          'icon': 'settings',
        };
      case 'location':
        return {
          'title': 'Location',
          'subtitle': 'Navigation and location services',
          'icon': 'location_on',
        };
      default:
        return {
          'title': permission,
          'subtitle': 'System permission',
          'icon': 'security',
        };
    }
  }
}