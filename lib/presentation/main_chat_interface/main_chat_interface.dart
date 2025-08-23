import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_thinking_orb.dart';
import './widgets/chat_input_field.dart';
import './widgets/message_bubble.dart';
import './widgets/vega_status_indicator.dart';
import './widgets/voice_input_button.dart';

class MainChatInterface extends StatefulWidget {
  const MainChatInterface({Key? key}) : super(key: key);

  @override
  State<MainChatInterface> createState() => _MainChatInterfaceState();
}

class _MainChatInterfaceState extends State<MainChatInterface>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  VoiceButtonState _voiceButtonState = VoiceButtonState.ready;
  VegaStatus _vegaStatus = VegaStatus.online;
  bool _isThinking = false;
  bool _showWaveform = false;
  bool _isTyping = false;

  // Mock conversation data
  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "message":
          "Hello! I'm VEGA, your AI assistant. I can help you with voice commands, system controls, and remember important information. How can I assist you today?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
    },
    {
      "id": 2,
      "message":
          "Hi VEGA! Can you help me set up a reminder for my meeting tomorrow?",
      "isUser": true,
      "timestamp": DateTime.now().subtract(Duration(minutes: 4)),
    },
    {
      "id": 3,
      "message":
          "Absolutely! I can help you set up reminders. What time is your meeting tomorrow, and what would you like me to remind you about?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 3)),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "message": text,
        "isUser": true,
        "timestamp": DateTime.now(),
      });
      _textController.clear();
      _isThinking = true;
      _vegaStatus = VegaStatus.processing;
    });

    _scrollToBottom();
    _simulateVegaResponse(text);
  }

  void _simulateVegaResponse(String userMessage) {
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isThinking = false;
        _isTyping = true;
      });

      // Add typing indicator
      _messages.add({
        "id": _messages.length + 1,
        "message": "",
        "isUser": false,
        "timestamp": DateTime.now(),
        "isTyping": true,
      });
      _scrollToBottom();

      Future.delayed(Duration(seconds: 1), () {
        if (!mounted) return;

        // Remove typing indicator and add actual response
        _messages.removeLast();

        String response = _generateVegaResponse(userMessage);

        setState(() {
          _messages.add({
            "id": _messages.length + 1,
            "message": response,
            "isUser": false,
            "timestamp": DateTime.now(),
          });
          _isTyping = false;
          _vegaStatus = VegaStatus.online;
        });
        _scrollToBottom();
      });
    });
  }

  String _generateVegaResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('reminder') || lowerMessage.contains('alarm')) {
      return "I'll help you set up that reminder. I can create alarms and reminders through your system. Would you like me to set it up now?";
    } else if (lowerMessage.contains('call') ||
        lowerMessage.contains('phone')) {
      return "I can help you make phone calls. Just tell me who you'd like to call, and I'll initiate the call for you.";
    } else if (lowerMessage.contains('message') ||
        lowerMessage.contains('text')) {
      return "I can send messages for you! Whether it's SMS or WhatsApp, just let me know the contact and message content.";
    } else if (lowerMessage.contains('wifi') ||
        lowerMessage.contains('bluetooth')) {
      return "I have access to your system controls. I can toggle WiFi, Bluetooth, and mobile hotspot settings for you.";
    } else if (lowerMessage.contains('music') ||
        lowerMessage.contains('play')) {
      return "I can control your music playback - play, pause, skip tracks, and more. What would you like me to do with your music?";
    } else if (lowerMessage.contains('navigation') ||
        lowerMessage.contains('maps')) {
      return "I can open Google Maps and start navigation to any destination. Where would you like to go?";
    } else if (lowerMessage.contains('remember') ||
        lowerMessage.contains('memory')) {
      return "I have a persistent memory system where I can store and recall important information for you. What would you like me to remember?";
    } else {
      return "I understand! I'm here to help with voice commands, system controls, and managing your information. Is there anything specific you'd like me to assist you with?";
    }
  }

  void _handleVoiceTap() {
    HapticFeedback.lightImpact();

    switch (_voiceButtonState) {
      case VoiceButtonState.ready:
        _startVoiceRecording();
        break;
      case VoiceButtonState.recording:
        _stopVoiceRecording();
        break;
      case VoiceButtonState.processing:
        // Do nothing while processing
        break;
    }
  }

  void _handleVoiceLongPressStart() {
    if (_voiceButtonState == VoiceButtonState.ready) {
      _startContinuousListening();
    }
  }

  void _handleVoiceLongPressEnd() {
    if (_voiceButtonState == VoiceButtonState.recording) {
      _stopVoiceRecording();
    }
  }

  void _startVoiceRecording() {
    setState(() {
      _voiceButtonState = VoiceButtonState.recording;
      _vegaStatus = VegaStatus.listening;
      _showWaveform = true;
    });
  }

  void _startContinuousListening() {
    setState(() {
      _voiceButtonState = VoiceButtonState.recording;
      _vegaStatus = VegaStatus.listening;
      _showWaveform = true;
    });
  }

  void _stopVoiceRecording() {
    setState(() {
      _voiceButtonState = VoiceButtonState.processing;
      _vegaStatus = VegaStatus.processing;
      _showWaveform = false;
    });

    // Simulate voice processing
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;

      final mockVoiceInput = "Hey VEGA, can you help me turn on WiFi?";

      setState(() {
        _messages.add({
          "id": _messages.length + 1,
          "message": mockVoiceInput,
          "isUser": true,
          "timestamp": DateTime.now(),
        });
        _voiceButtonState = VoiceButtonState.ready;
        _vegaStatus = VegaStatus.online;
      });

      _scrollToBottom();
      _simulateVegaResponse(mockVoiceInput);
    });
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();

    // Simulate loading conversation history
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Add a system message about refresh
        _messages.insert(0, {
          "id": 0,
          "message": "Conversation history loaded from memory.",
          "isUser": false,
          "timestamp": DateTime.now().subtract(Duration(minutes: 10)),
        });
      });
    }
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings-and-preferences');
  }

  void _openMemoryManagement() {
    Navigator.pushNamed(context, '/memory-management');
  }

  void _openSystemControls() {
    Navigator.pushNamed(context, '/system-controls-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: CustomIconWidget(
              iconName: 'menu',
              color: AppTheme.textPrimary,
              size: 6.w,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: VegaStatusIndicator(
          status: _vegaStatus,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'memory',
              color: AppTheme.textPrimary,
              size: 6.w,
            ),
            onPressed: _openMemoryManagement,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Thinking orb
            if (_isThinking)
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: AnimatedThinkingOrb(
                  isThinking: _isThinking,
                  size: 15.w,
                ),
              ),

            // Chat messages
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.accent,
                backgroundColor: AppTheme.surface,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return MessageBubble(
                      message: message["message"] as String,
                      isUser: message["isUser"] as bool,
                      timestamp: message["timestamp"] as DateTime,
                      isTyping: message["isTyping"] ?? false,
                    );
                  },
                ),
              ),
            ),

            // Input area
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Voice input button
                  VoiceInputButton(
                    state: _voiceButtonState,
                    showWaveform: _showWaveform,
                    onTap: _handleVoiceTap,
                    onLongPressStart: _handleVoiceLongPressStart,
                    onLongPressEnd: _handleVoiceLongPressEnd,
                  ),

                  SizedBox(height: 2.h),

                  // Text input field
                  ChatInputField(
                    controller: _textController,
                    onSend: _handleSendMessage,
                    enabled: _voiceButtonState != VoiceButtonState.processing,
                    hintText: "Type a message or use voice...",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppTheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accent,
                    AppTheme.accent.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.textPrimary.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'smart_toy',
                        color: AppTheme.textPrimary,
                        size: 8.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "VEGA Assistant",
                          style:
                              AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "AI-Powered Voice Assistant",
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildDrawerItem(
                    icon: 'chat',
                    title: 'Chat Interface',
                    subtitle: 'Voice & text conversations',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: 'memory',
                    title: 'Memory Management',
                    subtitle: 'Manage stored information',
                    onTap: () {
                      Navigator.pop(context);
                      _openMemoryManagement();
                    },
                  ),
                  _buildDrawerItem(
                    icon: 'settings_applications',
                    title: 'System Controls',
                    subtitle: 'Device & app controls',
                    onTap: () {
                      Navigator.pop(context);
                      _openSystemControls();
                    },
                  ),
                  _buildDrawerItem(
                    icon: 'settings',
                    title: 'Settings',
                    subtitle: 'App preferences & config',
                    onTap: () {
                      Navigator.pop(context);
                      _openSettings();
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(4.w),
              child: Text(
                "VEGA v1.0.0",
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.accent.withValues(alpha: 0.1),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.accent,
            size: 5.w,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
    );
  }
}
