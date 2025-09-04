import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/floating_whatsapp_button.dart';
import './widgets/hero_carousel_widget.dart';
import './widgets/quick_action_cards_widget.dart';
import './widgets/welcome_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _scrollAnimationController;
  late Animation<double> _headerAnimation;

  bool _isRefreshing = false;
  double _scrollOffset = 0.0;
  int _currentBottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupScrollListener();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _scrollAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _scrollAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });

      // Animate header based on scroll position
      if (_scrollController.offset > 100 &&
          _scrollAnimationController.value == 0) {
        _scrollAnimationController.forward();
      } else if (_scrollController.offset <= 100 &&
          _scrollAnimationController.value == 1) {
        _scrollAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate refresh delay
    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text('Products updated successfully!'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleProductTap(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _handleCategoryTap(String categoryId) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      '/product-catalog',
      arguments: {'category': categoryId},
    );
  }

  void _handleBottomNavTap(int index) {
    if (index != _currentBottomIndex) {
      setState(() {
        _currentBottomIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomHomeAppBar();
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildHeroSection(),
          _buildWelcomeSection(),
          _buildQuickActionsSection(),
          _buildFooterSpacing(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_scrollOffset * 0.3),
            child: Opacity(
              opacity: 1.0 - (_scrollOffset / 300).clamp(0.0, 0.7),
              child: HeroCarouselWidget(
                onProductTap: _handleProductTap,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: Offset(0, -_scrollOffset * 0.1),
        child: WelcomeSectionWidget(),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: Offset(0, -_scrollOffset * 0.05),
        child: QuickActionCardsWidget(
          onCategoryTap: _handleCategoryTap,
        ),
      ),
    );
  }

  Widget _buildFooterSpacing() {
    return SliverToBoxAdapter(
      child: SizedBox(height: 10.h),
    );
  }

  Widget _buildBottomNavigation() {
    return CustomBottomBar(
      currentIndex: _currentBottomIndex,
      onTap: _handleBottomNavTap,
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _scrollAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _scrollOffset > 200 ? 20.0 : 0.0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _scrollOffset > 500 ? 0.8 : 1.0,
            child: FloatingWhatsAppButton(),
          ),
        );
      },
    );
  }
}
