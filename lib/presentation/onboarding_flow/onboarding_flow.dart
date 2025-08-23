import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/navigation_buttons_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/progress_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  bool _isLoading = false;

  // Permission states
  Map<String, bool> _permissions = {
    'microphone': false,
    'contacts': false,
    'phone': false,
  };

  // Mock onboarding data
  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'title': 'Meet VEGA',
      'description':
          'Your intelligent voice assistant that understands natural conversation and learns from every interaction.',
      'image':
          'https://images.unsplash.com/photo-1677442136019-21780ecad995?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'showAnimation': true,
    },
    {
      'title': 'Smart Memory',
      'description':
          'VEGA remembers your preferences, important information, and context from previous conversations.',
      'image':
          'https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'showAnimation': false,
    },
    {
      'title': 'System Control',
      'description':
          'Control your phone hands-free. Make calls, send messages, set alarms, and manage your device with voice commands.',
      'image':
          'https://cdn.pixabay.com/photo/2020/04/08/08/37/smartphone-5016334_1280.jpg',
      'showAnimation': false,
    },
  ];

  final List<Map<String, dynamic>> _permissionData = [
    {
      'iconName': 'mic',
      'title': 'Microphone Access',
      'description': 'Required for voice input and commands',
      'whyNeeded':
          'VEGA needs microphone access to hear and process your voice commands. This enables natural conversation and hands-free interaction with your device.',
      'key': 'microphone',
    },
    {
      'iconName': 'contacts',
      'title': 'Contacts Access',
      'description': 'For calling and messaging features',
      'whyNeeded':
          'Access to your contacts allows VEGA to make calls and send messages using natural language like "Call Mom" or "Text John about dinner".',
      'key': 'contacts',
    },
    {
      'iconName': 'phone',
      'title': 'Phone Access',
      'description': 'To make calls and manage phone functions',
      'whyNeeded':
          'Phone access enables VEGA to initiate calls, manage call settings, and provide hands-free phone automation for your convenience.',
      'key': 'phone',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _getTotalPages() - 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/main-chat-interface');
  }

  int _getTotalPages() {
    return _onboardingPages.length + 1; // +1 for permissions page
  }

  bool _isPermissionsPage() {
    return _currentPage == _onboardingPages.length;
  }

  void _requestPermission(String permissionKey) async {
    setState(() => _isLoading = true);

    // Simulate permission request delay
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _permissions[permissionKey] = true;
      _isLoading = false;
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permission granted successfully'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _completeOnboarding() async {
    setState(() => _isLoading = true);

    // Check if all critical permissions are granted
    bool allPermissionsGranted =
        _permissions.values.every((granted) => granted);

    if (!allPermissionsGranted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please grant all permissions to continue'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Simulate setup completion
    await Future.delayed(Duration(milliseconds: 2000));

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/main-chat-interface');
  }

  void _tryVoiceInteraction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.textPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Voice interaction will be available after setup!',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (!_isPermissionsPage())
            TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Skip',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            ProgressIndicatorWidget(
              currentStep: _currentPage,
              totalSteps: _getTotalPages(),
            ),
            SizedBox(height: 2.h),
            // Main content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _getTotalPages(),
                itemBuilder: (context, index) {
                  if (index < _onboardingPages.length) {
                    // Onboarding pages
                    final pageData = _onboardingPages[index];
                    return OnboardingPageWidget(
                      title: pageData['title'],
                      description: pageData['description'],
                      imagePath: pageData['image'],
                      showAnimation: pageData['showAnimation'],
                      onTryVoice: pageData['showAnimation']
                          ? _tryVoiceInteraction
                          : null,
                    );
                  } else {
                    // Permissions page
                    return _buildPermissionsPage();
                  }
                },
              ),
            ),
            // Navigation buttons
            NavigationButtonsWidget(
              showBack: _currentPage > 0,
              showSkip: false,
              primaryButtonText:
                  _isPermissionsPage() ? 'Get Started' : 'Continue',
              onBack: _currentPage > 0 ? _previousPage : null,
              onPrimary: _nextPage,
              isPrimaryLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsPage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          // Header
          Text(
            'Permissions Required',
            style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'VEGA needs these permissions to provide the best voice assistant experience.',
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          // Permissions list
          Expanded(
            child: ListView.builder(
              itemCount: _permissionData.length,
              itemBuilder: (context, index) {
                final permission = _permissionData[index];
                return PermissionCardWidget(
                  iconName: permission['iconName'],
                  title: permission['title'],
                  description: permission['description'],
                  whyNeeded: permission['whyNeeded'],
                  isGranted: _permissions[permission['key']] ?? false,
                  onRequest: () => _requestPermission(permission['key']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
