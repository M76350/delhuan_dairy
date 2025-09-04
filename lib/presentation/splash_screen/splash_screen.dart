import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitialized = false;
  double _initializationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    // Background gradient animation
    _backgroundColorAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.primary,
      end: AppTheme.lightTheme.colorScheme.primaryContainer,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Loading indicator animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _backgroundAnimationController.repeat();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate app initialization tasks
      await _performInitializationTasks();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Wait for animations to complete before navigation
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          _navigateToHome();
        }
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        await Future.delayed(const Duration(milliseconds: 1000));

        if (mounted) {
          _navigateToHome();
        }
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    final tasks = [
      _loadCachedProductImages(),
      _checkNetworkConnectivity(),
      _prepareProductCatalog(),
      _initializeAnimationControllers(),
      _preloadAssets(),
    ];

    for (int i = 0; i < tasks.length; i++) {
      await tasks[i];
      if (mounted) {
        setState(() {
          _initializationProgress = (i + 1) / tasks.length;
        });
      }
      // Small delay to show progress
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _loadCachedProductImages() async {
    // Simulate loading cached product images
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _checkNetworkConnectivity() async {
    // Simulate network connectivity check
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _prepareProductCatalog() async {
    // Simulate preparing product catalog
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeAnimationControllers() async {
    // Simulate initializing Flutter animation controllers
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _preloadAssets() async {
    // Simulate preloading assets
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home-screen');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide system status bar for full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoAnimationController,
          _backgroundAnimationController,
        ]),
        builder: (context, child) {
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundColorAnimation.value ??
                      AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.8),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _logoFadeAnimation.value,
                              child: _buildLogo(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Loading section
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLoadingIndicator(),
                        SizedBox(height: 2.h),
                        _buildLoadingText(),
                      ],
                    ),
                  ),

                  // Bottom spacing
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'local_drink',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 12.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'Delhuan',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          Text(
            'Dairy',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 60.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.25.h),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.w * _initializationProgress,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(0.25.h),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingText() {
    return AnimatedOpacity(
      opacity: _loadingAnimation.value,
      duration: const Duration(milliseconds: 300),
      child: Text(
        _isInitialized ? 'Ready!' : 'Loading fresh dairy products...',
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.surface,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
