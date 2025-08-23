import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_dialog.dart';
import './widgets/permission_warning_card.dart';
import './widgets/recent_actions_section.dart';
import './widgets/system_control_card.dart';

class SystemControlsDashboard extends StatefulWidget {
  const SystemControlsDashboard({Key? key}) : super(key: key);

  @override
  State<SystemControlsDashboard> createState() =>
      _SystemControlsDashboardState();
}

class _SystemControlsDashboardState extends State<SystemControlsDashboard> {
  // System control states
  bool _isWiFiEnabled = true;
  bool _isBluetoothEnabled = false;
  bool _isHotspotEnabled = false;
  bool _isDNDEnabled = false;
  bool _isAirplaneModeEnabled = false;

  // Additional state information
  String _currentWiFiNetwork = "Home_Network_5G";
  List<String> _connectedBluetoothDevices = ["AirPods Pro"];
  int _hotspotConnectedDevices = 0;

  // Recent actions tracking
  List<Map<String, dynamic>> _recentActions = [];

  // Permission status
  List<String> _missingPermissions = [];

  // Loading states
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeSystemStates();
    _checkPermissions();
  }

  void _initializeSystemStates() {
    // Initialize with mock system states
    _recentActions = [
      {
        'id': 'action_1',
        'type': 'wifi',
        'enabled': true,
        'details': _currentWiFiNetwork,
        'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
        'canUndo': true,
      },
      {
        'id': 'action_2',
        'type': 'bluetooth',
        'enabled': false,
        'details': '',
        'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
        'canUndo': true,
      },
      {
        'id': 'action_3',
        'type': 'dnd',
        'enabled': false,
        'details': '',
        'timestamp': DateTime.now().subtract(Duration(hours: 1)),
        'canUndo': false,
      },
    ];
  }

  void _checkPermissions() {
    // Mock permission checking - in real implementation, use permission_handler
    setState(() {
      _missingPermissions = [
        'WRITE_SETTINGS',
        'ACCESS_WIFI_STATE',
        'BLUETOOTH_ADMIN',
      ];
    });
  }

  Future<void> _refreshSystemStates() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate system state refresh
    await Future.delayed(Duration(seconds: 1));

    // Mock updated states
    setState(() {
      _isRefreshing = false;
      // Update states as if reading from actual system
    });

    _showToast('System states refreshed');
  }

  void _toggleWiFi() {
    if (_missingPermissions.contains('ACCESS_WIFI_STATE')) {
      _showPermissionDialog('WiFi control requires system settings permission');
      return;
    }

    setState(() {
      _isWiFiEnabled = !_isWiFiEnabled;
    });

    _addRecentAction(
      'wifi',
      _isWiFiEnabled,
      _isWiFiEnabled ? _currentWiFiNetwork : '',
    );

    _showToast(_isWiFiEnabled ? 'WiFi enabled' : 'WiFi disabled');
    HapticFeedback.mediumImpact();
  }

  void _toggleBluetooth() {
    if (_missingPermissions.contains('BLUETOOTH_ADMIN')) {
      _showPermissionDialog('Bluetooth control requires system permission');
      return;
    }

    setState(() {
      _isBluetoothEnabled = !_isBluetoothEnabled;
      if (!_isBluetoothEnabled) {
        _connectedBluetoothDevices.clear();
      } else {
        _connectedBluetoothDevices = ["AirPods Pro"];
      }
    });

    _addRecentAction(
      'bluetooth',
      _isBluetoothEnabled,
      _connectedBluetoothDevices.isNotEmpty
          ? _connectedBluetoothDevices.first
          : '',
    );

    _showToast(
        _isBluetoothEnabled ? 'Bluetooth enabled' : 'Bluetooth disabled');
    HapticFeedback.mediumImpact();
  }

  void _toggleHotspot() {
    if (_missingPermissions.contains('WRITE_SETTINGS')) {
      _showPermissionDialog(
          'Mobile Hotspot requires system settings permission');
      return;
    }

    if (_isWiFiEnabled && !_isHotspotEnabled) {
      _showConfirmationDialog(
        'Enable Mobile Hotspot',
        'This will disable WiFi connection. Continue?',
        () {
          setState(() {
            _isWiFiEnabled = false;
            _isHotspotEnabled = true;
            _hotspotConnectedDevices = 0;
          });
          _addRecentAction('hotspot', true, '');
          _showToast('Mobile Hotspot enabled');
        },
      );
    } else {
      setState(() {
        _isHotspotEnabled = !_isHotspotEnabled;
        if (!_isHotspotEnabled) {
          _hotspotConnectedDevices = 0;
        }
      });

      _addRecentAction('hotspot', _isHotspotEnabled, '');
      _showToast(_isHotspotEnabled
          ? 'Mobile Hotspot enabled'
          : 'Mobile Hotspot disabled');
    }

    HapticFeedback.mediumImpact();
  }

  void _toggleDND() {
    setState(() {
      _isDNDEnabled = !_isDNDEnabled;
    });

    _addRecentAction('dnd', _isDNDEnabled, '');
    _showToast(
        _isDNDEnabled ? 'Do Not Disturb enabled' : 'Do Not Disturb disabled');
    HapticFeedback.mediumImpact();
  }

  void _toggleAirplaneMode() {
    _showConfirmationDialog(
      'Airplane Mode',
      'This will disable all wireless connections. Continue?',
      () {
        setState(() {
          _isAirplaneModeEnabled = !_isAirplaneModeEnabled;
          if (_isAirplaneModeEnabled) {
            _isWiFiEnabled = false;
            _isBluetoothEnabled = false;
            _isHotspotEnabled = false;
            _connectedBluetoothDevices.clear();
            _hotspotConnectedDevices = 0;
          }
        });

        _addRecentAction('airplane', _isAirplaneModeEnabled, '');
        _showToast(_isAirplaneModeEnabled
            ? 'Airplane Mode enabled'
            : 'Airplane Mode disabled');
      },
    );

    HapticFeedback.mediumImpact();
  }

  void _addRecentAction(String type, bool enabled, String details) {
    final action = {
      'id': 'action_${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'enabled': enabled,
      'details': details,
      'timestamp': DateTime.now(),
      'canUndo': type != 'airplane', // Airplane mode changes can't be undone
    };

    setState(() {
      _recentActions.insert(0, action);
      if (_recentActions.length > 10) {
        _recentActions = _recentActions.take(10).toList();
      }
    });
  }

  void _undoAction(String actionId) {
    final action = _recentActions.firstWhere(
      (a) => a['id'] == actionId,
      orElse: () => {},
    );

    if (action.isEmpty) return;

    final type = action['type'] as String;
    final wasEnabled = action['enabled'] as bool;

    // Reverse the action
    switch (type) {
      case 'wifi':
        setState(() {
          _isWiFiEnabled = !wasEnabled;
        });
        break;
      case 'bluetooth':
        setState(() {
          _isBluetoothEnabled = !wasEnabled;
          if (_isBluetoothEnabled) {
            _connectedBluetoothDevices = ["AirPods Pro"];
          } else {
            _connectedBluetoothDevices.clear();
          }
        });
        break;
      case 'hotspot':
        setState(() {
          _isHotspotEnabled = !wasEnabled;
          if (!_isHotspotEnabled) {
            _hotspotConnectedDevices = 0;
          }
        });
        break;
      case 'dnd':
        setState(() {
          _isDNDEnabled = !wasEnabled;
        });
        break;
    }

    // Remove the action from recent actions
    setState(() {
      _recentActions.removeWhere((a) => a['id'] == actionId);
    });

    _showToast('Action undone');
    HapticFeedback.lightImpact();
  }

  void _handleVoiceCommand(String controlType) {
    _showToast('Voice command: Toggle $controlType');

    // Simulate voice command processing
    switch (controlType) {
      case 'wifi':
        _toggleWiFi();
        break;
      case 'bluetooth':
        _toggleBluetooth();
        break;
      case 'hotspot':
        _toggleHotspot();
        break;
      case 'dnd':
        _toggleDND();
        break;
      case 'airplane':
        _toggleAirplaneMode();
        break;
    }
  }

  void _showAdvancedOptions(String controlType) {
    Map<String, dynamic> options = {};

    switch (controlType) {
      case 'wifi':
        options = {
          'availableNetworks': [
            {
              'ssid': 'Home_Network_5G',
              'signalStrength': 85,
              'isSecured': true,
            },
            {
              'ssid': 'Office_WiFi',
              'signalStrength': 60,
              'isSecured': true,
            },
            {
              'ssid': 'Public_WiFi',
              'signalStrength': 40,
              'isSecured': false,
            },
          ],
          'currentNetwork': _currentWiFiNetwork,
        };
        break;
      case 'bluetooth':
        options = {
          'pairedDevices': [
            {
              'name': 'AirPods Pro',
              'isConnected': _connectedBluetoothDevices.contains('AirPods Pro'),
              'type': 'headphones',
            },
            {
              'name': 'Samsung Galaxy Watch',
              'isConnected': false,
              'type': 'watch',
            },
            {
              'name': 'JBL Speaker',
              'isConnected': false,
              'type': 'speaker',
            },
          ],
        };
        break;
      case 'hotspot':
        options = {
          'hotspotName': 'VEGA_Hotspot',
          'connectedDevices': _hotspotConnectedDevices,
        };
        break;
      case 'dnd':
        options = {};
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AdvancedOptionsDialog(
        controlType: controlType,
        options: options,
        onOptionSelected: _handleAdvancedOption,
      ),
    );
  }

  void _handleAdvancedOption(String option, dynamic value) {
    Navigator.of(context).pop(); // Close dialog

    switch (option) {
      case 'connect_network':
        setState(() {
          _currentWiFiNetwork = value as String;
          _isWiFiEnabled = true;
        });
        _showToast('Connected to $value');
        break;
      case 'connect_device':
        setState(() {
          if (!_connectedBluetoothDevices.contains(value)) {
            _connectedBluetoothDevices.add(value as String);
          }
        });
        _showToast('Connected to $value');
        break;
      case 'disconnect_device':
        setState(() {
          _connectedBluetoothDevices.remove(value);
        });
        _showToast('Disconnected from $value');
        break;
      case 'refresh_networks':
        _showToast('Scanning for networks...');
        break;
      case 'scan_devices':
        _showToast('Scanning for devices...');
        break;
      default:
        _showToast('Option: $option');
    }
  }

  void _grantPermissions() {
    // In real implementation, this would open system settings
    _showToast('Opening system settings...');

    // Simulate permission grant
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _missingPermissions.clear();
      });
      _showToast('Permissions granted');
    });
  }

  void _showConfirmationDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.warning,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Permission Required',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _grantPermissions();
            },
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.surface,
      textColor: AppTheme.textPrimary,
      fontSize: 14.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        title: Text(
          'System Controls',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/main-chat-interface'),
            icon: CustomIconWidget(
              iconName: 'chat',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-preferences'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSystemStates,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Permission warning
              PermissionWarningCard(
                missingPermissions: _missingPermissions,
                onGrantPermissions: _grantPermissions,
              ),

              // Recent actions
              RecentActionsSection(
                recentActions: _recentActions,
                onUndoAction: _undoAction,
              ),

              // System controls grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Controls',
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount =
                            constraints.maxWidth > 600 ? 3 : 2;
                        final childAspectRatio =
                            constraints.maxWidth > 600 ? 1.2 : 1.0;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: childAspectRatio,
                          children: [
                            SystemControlCard(
                              title: 'WiFi',
                              subtitle: _isWiFiEnabled
                                  ? 'Connected to $_currentWiFiNetwork'
                                  : 'Disconnected',
                              iconName: 'wifi',
                              isActive: _isWiFiEnabled,
                              onToggle: _toggleWiFi,
                              onVoiceCommand: () => _handleVoiceCommand('wifi'),
                              onLongPress: () => _showAdvancedOptions('wifi'),
                              activeColor: AppTheme.accent,
                            ),
                            SystemControlCard(
                              title: 'Bluetooth',
                              subtitle: _isBluetoothEnabled
                                  ? _connectedBluetoothDevices.isNotEmpty
                                      ? 'Connected to ${_connectedBluetoothDevices.length} device${_connectedBluetoothDevices.length != 1 ? 's' : ''}'
                                      : 'On, no devices'
                                  : 'Disconnected',
                              iconName: 'bluetooth',
                              isActive: _isBluetoothEnabled,
                              onToggle: _toggleBluetooth,
                              onVoiceCommand: () =>
                                  _handleVoiceCommand('bluetooth'),
                              onLongPress: () =>
                                  _showAdvancedOptions('bluetooth'),
                              activeColor: Colors.blue,
                            ),
                            SystemControlCard(
                              title: 'Mobile Hotspot',
                              subtitle: _isHotspotEnabled
                                  ? '$_hotspotConnectedDevices device${_hotspotConnectedDevices != 1 ? 's' : ''} connected'
                                  : 'Disabled',
                              iconName: 'wifi_tethering',
                              isActive: _isHotspotEnabled,
                              onToggle: _toggleHotspot,
                              onVoiceCommand: () =>
                                  _handleVoiceCommand('hotspot'),
                              onLongPress: () =>
                                  _showAdvancedOptions('hotspot'),
                              activeColor: Colors.orange,
                            ),
                            SystemControlCard(
                              title: 'Do Not Disturb',
                              subtitle: _isDNDEnabled
                                  ? 'Notifications silenced'
                                  : 'All notifications allowed',
                              iconName: 'do_not_disturb',
                              isActive: _isDNDEnabled,
                              onToggle: _toggleDND,
                              onVoiceCommand: () => _handleVoiceCommand('dnd'),
                              onLongPress: () => _showAdvancedOptions('dnd'),
                              activeColor: Colors.purple,
                            ),
                            SystemControlCard(
                              title: 'Airplane Mode',
                              subtitle: _isAirplaneModeEnabled
                                  ? 'All wireless disabled'
                                  : 'Wireless connections enabled',
                              iconName: 'airplanemode_active',
                              isActive: _isAirplaneModeEnabled,
                              onToggle: _toggleAirplaneMode,
                              onVoiceCommand: () =>
                                  _handleVoiceCommand('airplane'),
                              activeColor: Colors.red,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Voice assistant integration hint
              Container(
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Voice Control Available',
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Say "Hey VEGA, turn on WiFi" or tap the mic icons',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/main-chat-interface'),
        backgroundColor: AppTheme.accent,
        child: CustomIconWidget(
          iconName: 'chat',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
    );
  }
}
