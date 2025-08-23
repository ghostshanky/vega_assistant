import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsDialog extends StatelessWidget {
  final String controlType;
  final Map<String, dynamic> options;
  final Function(String, dynamic) onOptionSelected;

  const AdvancedOptionsDialog({
    Key? key,
    required this.controlType,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 70.h,
          maxWidth: 90.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _getControlIcon(controlType),
                    color: AppTheme.accent,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      '${_getControlTitle(controlType)} Options',
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: _buildOptionsContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsContent() {
    switch (controlType) {
      case 'wifi':
        return _buildWiFiOptions();
      case 'bluetooth':
        return _buildBluetoothOptions();
      case 'hotspot':
        return _buildHotspotOptions();
      case 'dnd':
        return _buildDNDOptions();
      default:
        return _buildGenericOptions();
    }
  }

  Widget _buildWiFiOptions() {
    final networks =
        options['availableNetworks'] as List<Map<String, dynamic>>? ?? [];
    final currentNetwork = options['currentNetwork'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Networks',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (networks.isEmpty)
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.border.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'wifi_off',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  'No networks found',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...networks
              .map((network) => _buildNetworkTile(network, currentNetwork))
              .toList(),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onOptionSelected('refresh_networks', null),
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.accent,
              size: 16,
            ),
            label: Text('Refresh Networks'),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkTile(
      Map<String, dynamic> network, String currentNetwork) {
    final ssid = network['ssid'] as String;
    final signalStrength = network['signalStrength'] as int;
    final isSecured = network['isSecured'] as bool;
    final isConnected = ssid == currentNetwork;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        tileColor: isConnected
            ? AppTheme.accent.withValues(alpha: 0.1)
            : AppTheme.border.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isConnected ? AppTheme.accent : AppTheme.border,
            width: isConnected ? 2 : 1,
          ),
        ),
        leading: CustomIconWidget(
          iconName: _getWiFiIcon(signalStrength),
          color: isConnected ? AppTheme.accent : AppTheme.textSecondary,
          size: 20,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                ssid,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isConnected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSecured)
              CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.textSecondary,
                size: 16,
              ),
          ],
        ),
        subtitle: Text(
          isConnected ? 'Connected' : 'Available',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: isConnected ? AppTheme.accent : AppTheme.textSecondary,
          ),
        ),
        onTap: isConnected
            ? null
            : () => onOptionSelected('connect_network', ssid),
      ),
    );
  }

  Widget _buildBluetoothOptions() {
    final devices =
        options['pairedDevices'] as List<Map<String, dynamic>>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paired Devices',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (devices.isEmpty)
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.border.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'bluetooth_disabled',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  'No paired devices',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...devices.map((device) => _buildDeviceTile(device)).toList(),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onOptionSelected('scan_devices', null),
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.accent,
              size: 16,
            ),
            label: Text('Scan for Devices'),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceTile(Map<String, dynamic> device) {
    final name = device['name'] as String;
    final isConnected = device['isConnected'] as bool;
    final deviceType = device['type'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        tileColor: isConnected
            ? AppTheme.success.withValues(alpha: 0.1)
            : AppTheme.border.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isConnected ? AppTheme.success : AppTheme.border,
            width: isConnected ? 2 : 1,
          ),
        ),
        leading: CustomIconWidget(
          iconName: _getDeviceIcon(deviceType),
          color: isConnected ? AppTheme.success : AppTheme.textSecondary,
          size: 20,
        ),
        title: Text(
          name,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isConnected ? FontWeight.w600 : FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          isConnected ? 'Connected' : 'Paired',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: isConnected ? AppTheme.success : AppTheme.textSecondary,
          ),
        ),
        trailing: isConnected
            ? TextButton(
                onPressed: () => onOptionSelected('disconnect_device', name),
                child: Text(
                  'Disconnect',
                  style: TextStyle(
                    color: AppTheme.error,
                    fontSize: 12.sp,
                  ),
                ),
              )
            : TextButton(
                onPressed: () => onOptionSelected('connect_device', name),
                child: Text(
                  'Connect',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12.sp,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHotspotOptions() {
    final ssid = options['hotspotName'] as String? ?? 'My Hotspot';
    final connectedDevices = options['connectedDevices'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hotspot Configuration',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildOptionTile(
          'Network Name',
          ssid,
          'edit',
          () => onOptionSelected('edit_ssid', ssid),
        ),
        _buildOptionTile(
          'Connected Devices',
          '$connectedDevices device${connectedDevices != 1 ? 's' : ''}',
          'devices',
          () => onOptionSelected('view_devices', null),
        ),
        _buildOptionTile(
          'Change Password',
          'Tap to modify',
          'lock',
          () => onOptionSelected('change_password', null),
        ),
        _buildOptionTile(
          'Data Usage',
          'View consumption',
          'data_usage',
          () => onOptionSelected('view_usage', null),
        ),
      ],
    );
  }

  Widget _buildDNDOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Do Not Disturb Settings',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildOptionTile(
          'Priority Only',
          'Allow important notifications',
          'priority_high',
          () => onOptionSelected('priority_mode', 'priority'),
        ),
        _buildOptionTile(
          'Alarms Only',
          'Only alarms will sound',
          'alarm',
          () => onOptionSelected('priority_mode', 'alarms'),
        ),
        _buildOptionTile(
          'Total Silence',
          'Block all notifications',
          'volume_off',
          () => onOptionSelected('priority_mode', 'silence'),
        ),
        _buildOptionTile(
          'Schedule',
          'Set automatic DND times',
          'schedule',
          () => onOptionSelected('set_schedule', null),
        ),
      ],
    );
  }

  Widget _buildGenericOptions() {
    return Column(
      children: [
        Text(
          'No advanced options available for this control.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOptionTile(
      String title, String subtitle, String iconName, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        tileColor: AppTheme.border.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppTheme.border),
        ),
        leading: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.accent,
          size: 20,
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.textSecondary,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getControlIcon(String controlType) {
    switch (controlType) {
      case 'wifi':
        return 'wifi';
      case 'bluetooth':
        return 'bluetooth';
      case 'hotspot':
        return 'wifi_tethering';
      case 'dnd':
        return 'do_not_disturb';
      default:
        return 'settings';
    }
  }

  String _getControlTitle(String controlType) {
    switch (controlType) {
      case 'wifi':
        return 'WiFi';
      case 'bluetooth':
        return 'Bluetooth';
      case 'hotspot':
        return 'Mobile Hotspot';
      case 'dnd':
        return 'Do Not Disturb';
      default:
        return 'System Control';
    }
  }

  String _getWiFiIcon(int signalStrength) {
    if (signalStrength >= 75) return 'wifi';
    if (signalStrength >= 50) return 'wifi_2_bar';
    if (signalStrength >= 25) return 'wifi_1_bar';
    return 'wifi_0_bar';
  }

  String _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'headphones':
      case 'headset':
        return 'headphones';
      case 'speaker':
        return 'speaker';
      case 'phone':
        return 'phone_android';
      case 'computer':
      case 'laptop':
        return 'computer';
      case 'watch':
        return 'watch';
      default:
        return 'bluetooth';
    }
  }
}
