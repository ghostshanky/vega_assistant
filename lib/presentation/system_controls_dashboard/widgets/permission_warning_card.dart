import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionWarningCard extends StatelessWidget {
  final List<String> missingPermissions;
  final VoidCallback onGrantPermissions;

  const PermissionWarningCard({
    Key? key,
    required this.missingPermissions,
    required this.onGrantPermissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (missingPermissions.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        color: AppTheme.warning.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.warning,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.warning,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Permissions Required',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'Some system controls require additional permissions to function properly:',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              ...missingPermissions
                  .map((permission) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'circle',
                              color: AppTheme.warning,
                              size: 8,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                _getPermissionDescription(permission),
                                style: AppTheme.darkTheme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGrantPermissions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warning,
                    foregroundColor: AppTheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Grant Permissions',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPermissionDescription(String permission) {
    switch (permission) {
      case 'WRITE_SETTINGS':
        return 'System settings modification for WiFi, Bluetooth controls';
      case 'ACCESS_WIFI_STATE':
        return 'WiFi network information and control';
      case 'BLUETOOTH_ADMIN':
        return 'Bluetooth device management and control';
      case 'MODIFY_AUDIO_SETTINGS':
        return 'Do Not Disturb and audio profile management';
      case 'WRITE_SECURE_SETTINGS':
        return 'Advanced system settings modification';
      default:
        return permission;
    }
  }
}
