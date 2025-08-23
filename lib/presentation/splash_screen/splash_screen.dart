import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_vega_orb.dart';
import './widgets/initialization_status.dart';
import './widgets/loading_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  double _progress = 0.0;
  String _currentTask = 'Initializing VEGA Assistant...';
  bool _showDetailedStatus = false;
  bool _hasError = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _initializationStatus = [
    {
      'title': 'Checking microphone permissions',
      'isCompleted': false,
      'isLoading': false,
      'error': null,
    },
    {
      'title': 'Loading SQLite memory database',
      'isCompleted': false,
      'isLoading': false,
      'error': null,
    },
    {
      'title': 'Initializing speech-to-text services',
      'isCompleted': false,
      'isLoading': false,
      'error': null,
    },
    {
      'title': 'Preparing AI model cache',
      'isCompleted': false,
      'isLoading': false,
      'error': null,
    },
    {
      'title': 'Verifying system permissions',
      'isCompleted': false,
      'isLoading': false,
      'error': null,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Hide system status bar for full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();

    // Start initialization process
    _initializeApp();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Check microphone permissions
      await _updateInitializationStep(0, 'Checking microphone permissions...');
      await _simulatePermissionCheck();
      await _completeInitializationStep(0);

      // Step 2: Load SQLite database
      await _updateInitializationStep(1, 'Loading memory database...');
      await _simulateDatabaseLoad();
      await _completeInitializationStep(1);

      // Step 3: Initialize speech services
      await _updateInitializationStep(2, 'Initializing speech services...');
      await _simulateSpeechInit();
      await _completeInitializationStep(2);

      // Step 4: Prepare AI model
      await _updateInitializationStep(3, 'Preparing AI model...');
      await _simulateAIModelLoad();
      await _completeInitializationStep(3);

      // Step 5: Verify system permissions
      await _updateInitializationStep(4, 'Verifying permissions...');
      await _simulatePermissionVerification();
      await _completeInitializationStep(4);

      // Complete initialization
      setState(() {
        _progress = 100.0;
        _currentTask = 'VEGA Assistant ready!';
      });

      // Wait a moment before navigation
      await Future.delayed(const Duration(milliseconds: 800));

      // Navigate based on app state
      _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e.toString());
    }
  }

  Future<void> _updateInitializationStep(int index, String task) async {
    setState(() {
      _initializationStatus[index]['isLoading'] = true;
      _currentTask = task;
      _progress = (index * 20.0);
    });
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _completeInitializationStep(int index) async {
    setState(() {
      _initializationStatus[index]['isLoading'] = false;
      _initializationStatus[index]['isCompleted'] = true;
      _progress = ((index + 1) * 20.0);
    });
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _simulatePermissionCheck() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate permission check logic
  }

  Future<void> _simulateDatabaseLoad() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulate database initialization
  }

  Future<void> _simulateSpeechInit() async {
    await Future.delayed(const Duration(milliseconds: 900));
    // Simulate speech-to-text initialization
  }

  Future<void> _simulateAIModelLoad() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Simulate AI model cache preparation
  }

  Future<void> _simulatePermissionVerification() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate final permission verification
  }

  void _handleInitializationError(String error) {
    setState(() {
      _hasError = true;
      _errorMessage = error;
      _currentTask = 'Initialization failed';
      _showDetailedStatus = true;
    });

    // Update the current step with error
    for (int i = 0; i < _initializationStatus.length; i++) {
      if (_initializationStatus[i]['isLoading'] as bool) {
        setState(() {
          _initializationStatus[i]['isLoading'] = false;
          _initializationStatus[i]['error'] = 'Failed to complete';
        });
        break;
      }
    }
  }

  void _navigateToNextScreen() {
    // Simulate navigation logic based on app state
    final bool hasPermissions = _checkPermissions();
    final bool isFirstLaunch = _checkFirstLaunch();

    if (hasPermissions && !isFirstLaunch) {
      Navigator.pushReplacementNamed(context, '/main-chat-interface');
    } else if (isFirstLaunch) {
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    }
  }

  bool _checkPermissions() {
    // Simulate permission check
    return true; // Mock: permissions granted
  }

  bool _checkFirstLaunch() {
    // Simulate first launch check
    return false; // Mock: not first launch
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _progress = 0.0;
      _showDetailedStatus = false;
      _currentTask = 'Retrying initialization...';

      // Reset all status items
      for (var item in _initializationStatus) {
        item['isCompleted'] = false;
        item['isLoading'] = false;
        item['error'] = null;
      }
    });

    _initializeApp();
  }

  void _toggleDetailedStatus() {
    setState(() {
      _showDetailedStatus = !_showDetailedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              AppTheme.primary,
              AppTheme.backgroundDark,
              AppTheme.primary.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Top spacer
                SizedBox(height: 15.h),

                // VEGA logo and title
                Column(
                  children: [
                    // Animated VEGA orb
                    AnimatedVegaOrb(
                      isAnimating: !_hasError,
                    ),

                    SizedBox(height: 4.h),

                    // App title
                    Text(
                      'VEGA Assistant',
                      style:
                          AppTheme.darkTheme.textTheme.headlineLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Subtitle
                    Text(
                      'AI-Powered Voice Assistant',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                // Spacer
                SizedBox(height: 8.h),

                // Loading progress or error state
                if (!_hasError) ...[
                  LoadingProgressIndicator(
                    progress: _progress,
                    currentTask: _currentTask,
                  ),
                ] else ...[
                  // Error state
                  Container(
                    width: 80.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.error.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'error_outline',
                          color: AppTheme.error,
                          size: 32,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Initialization Failed',
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.error,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 11.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                          onPressed: _retryInitialization,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ],

                // Spacer
                const Spacer(),

                // Detailed status toggle
                if (!_hasError)
                  GestureDetector(
                    onTap: _toggleDetailedStatus,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showDetailedStatus
                                ? 'Hide Details'
                                : 'Show Details',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.accent,
                              fontSize: 10.sp,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: _showDetailedStatus
                                ? 'keyboard_arrow_up'
                                : 'keyboard_arrow_down',
                            color: AppTheme.accent,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Detailed initialization status
                if (_showDetailedStatus) ...[
                  SizedBox(height: 2.h),
                  InitializationStatus(
                    statusItems: _initializationStatus,
                  ),
                ],

                // Bottom spacer
                SizedBox(height: 4.h),

                // Version info
                Text(
                  'Version 1.0.0 • Build 2025.08.22',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary.withValues(alpha: 0.6),
                    fontSize: 9.sp,
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
