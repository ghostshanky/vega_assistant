import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_settings_section.dart';
import './widgets/notification_preferences_section.dart';
import './widgets/privacy_settings_section.dart';
import './widgets/settings_search_bar.dart';
import './widgets/system_integration_section.dart';
import './widgets/voice_settings_section.dart';

class SettingsAndPreferences extends StatefulWidget {
  const SettingsAndPreferences({super.key});

  @override
  State<SettingsAndPreferences> createState() => _SettingsAndPreferencesState();
}

class _SettingsAndPreferencesState extends State<SettingsAndPreferences> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Voice Settings
  double _speechRate = 1.0;
  String _selectedVoice = 'Female Voice';
  double _wakeSensitivity = 0.7;

  // Privacy Settings
  bool _conversationHistory = true;
  bool _memoryAutoSave = true;

  // System Integration
  final Map<String, bool> _permissions = {
    'microphone': true,
    'contacts': false,
    'phone': true,
    'system_settings': false,
    'location': true,
  };

  // Notification Preferences
  bool _responseConfirmations = true;
  bool _errorAlerts = true;
  bool _backgroundService = false;

  // Advanced Settings
  bool _developerOptions = false;
  bool _debugLogging = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SettingsSearchBar(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            onClear: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_shouldShowSection('voice')) ...[
                    VoiceSettingsSection(
                      speechRate: _speechRate,
                      selectedVoice: _selectedVoice,
                      wakeSensitivity: _wakeSensitivity,
                      onSpeechRateChanged: (value) {
                        setState(() {
                          _speechRate = value;
                        });
                      },
                      onVoiceChanged: (value) {
                        setState(() {
                          _selectedVoice = value;
                        });
                      },
                      onWakeSensitivityChanged: (value) {
                        setState(() {
                          _wakeSensitivity = value;
                        });
                      },
                      onTestVoice: _testVoice,
                    ),
                  ],
                  if (_shouldShowSection('privacy')) ...[
                    PrivacySettingsSection(
                      conversationHistory: _conversationHistory,
                      memoryAutoSave: _memoryAutoSave,
                      onConversationHistoryChanged: (value) {
                        setState(() {
                          _conversationHistory = value;
                        });
                      },
                      onMemoryAutoSaveChanged: (value) {
                        setState(() {
                          _memoryAutoSave = value;
                        });
                      },
                      onExportData: _exportData,
                    ),
                  ],
                  if (_shouldShowSection('system')) ...[
                    SystemIntegrationSection(
                      permissions: _permissions,
                      onReauthorizePermission: _reauthorizePermission,
                    ),
                  ],
                  if (_shouldShowSection('notification')) ...[
                    NotificationPreferencesSection(
                      responseConfirmations: _responseConfirmations,
                      errorAlerts: _errorAlerts,
                      backgroundService: _backgroundService,
                      onResponseConfirmationsChanged: (value) {
                        setState(() {
                          _responseConfirmations = value;
                        });
                      },
                      onErrorAlertsChanged: (value) {
                        setState(() {
                          _errorAlerts = value;
                        });
                      },
                      onBackgroundServiceChanged: (value) {
                        setState(() {
                          _backgroundService = value;
                        });
                      },
                    ),
                  ],
                  if (_shouldShowSection('advanced')) ...[
                    AdvancedSettingsSection(
                      developerOptions: _developerOptions,
                      debugLogging: _debugLogging,
                      onDeveloperOptionsChanged: (value) {
                        setState(() {
                          _developerOptions = value;
                          if (!value) {
                            _debugLogging = false;
                          }
                        });
                      },
                      onDebugLoggingChanged: (value) {
                        setState(() {
                          _debugLogging = value;
                        });
                      },
                      onResetSettings: _resetAllSettings,
                    ),
                  ],
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Text(
        'Settings & Preferences',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/main-chat-interface'),
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
      ],
    );
  }

  bool _shouldShowSection(String section) {
    if (_searchQuery.isEmpty) return true;

    switch (section) {
      case 'voice':
        return 'voice settings speech rate wake word sensitivity test'
            .contains(_searchQuery);
      case 'privacy':
        return 'privacy data conversation history memory auto save export'
            .contains(_searchQuery);
      case 'system':
        return 'system integration permissions microphone contacts phone location'
            .contains(_searchQuery);
      case 'notification':
        return 'notifications response confirmations error alerts background service'
            .contains(_searchQuery);
      case 'advanced':
        return 'advanced developer options debug logging reset'
            .contains(_searchQuery);
      default:
        return false;
    }
  }

  void _testVoice() {
    final testPhrases = [
      "Hello! I'm VEGA, your AI assistant. How can I help you today?",
      "This is how I sound with the current voice settings.",
      "Voice test complete. How do I sound?",
    ];

    final randomPhrase =
        testPhrases[DateTime.now().millisecond % testPhrases.length];

    Fluttertoast.showToast(
      msg: "Playing: \"$randomPhrase\"",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.darkTheme.cardColor,
      textColor: AppTheme.textPrimary,
    );
  }

  void _exportData() {
    final mockConversationData = {
      "export_date": DateTime.now().toIso8601String(),
      "conversations": [
        {
          "id": 1,
          "timestamp": "2025-08-22T20:15:30.000Z",
          "messages": [
            {"role": "user", "content": "Hey VEGA, what's the weather like?"},
            {
              "role": "assistant",
              "content":
                  "I'd be happy to help you check the weather! However, I need location access to provide accurate weather information."
            }
          ]
        },
        {
          "id": 2,
          "timestamp": "2025-08-22T19:45:12.000Z",
          "messages": [
            {"role": "user", "content": "Call mom"},
            {
              "role": "assistant",
              "content":
                  "I'll call your mom for you. Initiating call to Mom's contact."
            }
          ]
        }
      ],
      "memories": [
        {
          "id": 1,
          "type": "preference",
          "content": "User prefers morning reminders at 8 AM",
          "created": "2025-08-20T08:00:00.000Z"
        },
        {
          "id": 2,
          "type": "contact",
          "content": "Mom's phone number: +1-555-0123",
          "created": "2025-08-19T14:30:00.000Z"
        }
      ],
      "settings": {
        "speech_rate": _speechRate,
        "selected_voice": _selectedVoice,
        "wake_sensitivity": _wakeSensitivity,
        "conversation_history": _conversationHistory,
        "memory_auto_save": _memoryAutoSave
      }
    };

    Fluttertoast.showToast(
      msg: "Data exported successfully! Check your downloads folder.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success.withValues(alpha: 0.8),
      textColor: AppTheme.textPrimary,
    );
  }

  void _reauthorizePermission(String permission) {
    setState(() {
      _permissions[permission] = true;
    });

    Fluttertoast.showToast(
      msg:
          "${permission.replaceAll('_', ' ').toUpperCase()} permission granted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success.withValues(alpha: 0.8),
      textColor: AppTheme.textPrimary,
    );
  }

  void _resetAllSettings() {
    setState(() {
      // Reset voice settings
      _speechRate = 1.0;
      _selectedVoice = 'Female Voice';
      _wakeSensitivity = 0.7;

      // Reset privacy settings
      _conversationHistory = true;
      _memoryAutoSave = true;

      // Reset permissions (keep current state as they're system-level)

      // Reset notification preferences
      _responseConfirmations = true;
      _errorAlerts = true;
      _backgroundService = false;

      // Reset advanced settings
      _developerOptions = false;
      _debugLogging = false;
    });

    Fluttertoast.showToast(
      msg: "All settings have been reset to defaults",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.darkTheme.cardColor,
      textColor: AppTheme.textPrimary,
    );
  }
}
