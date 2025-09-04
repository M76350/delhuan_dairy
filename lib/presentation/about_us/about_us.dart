import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/company_story_widget.dart';
import './widgets/contact_info_widget.dart';
import './widgets/hero_section_widget.dart';
import './widgets/location_map_widget.dart';
import './widgets/mission_values_widget.dart';
import './widgets/photo_gallery_widget.dart';
import './widgets/quality_assurance_widget.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShowFab = _scrollController.offset > 200;
    if (shouldShowFab != _showFab) {
      setState(() {
        _showFab = shouldShowFab;
      });
      if (_showFab) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'About Us',
        showBackButton: true,
        showSearchButton: false,
        showCartButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section with Parallax Effect
                  HeroSectionWidget(),

                  // Company Story Section
                  CompanyStoryWidget(),

                  // Quality Assurance Section
                  QualityAssuranceWidget(),

                  // Mission & Values Section
                  MissionValuesWidget(),

                  // Photo Gallery Section
                  PhotoGalleryWidget(),

                  // Location Map Section
                  LocationMapWidget(),

                  // Contact Information Section
                  ContactInfoWidget(),

                  // Bottom Spacing
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          child: CustomIconWidget(
            iconName: 'keyboard_arrow_up',
            color: Colors.white,
            size: 6.w,
          ),
          tooltip: 'Scroll to top',
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 3, // About Us tab index
        onTap: _onBottomNavTap,
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(Duration(milliseconds: 1000));

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Show refresh completion message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Content refreshed'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _scrollToTop() {
    HapticFeedback.lightImpact();
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _onBottomNavTap(int index) {
    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/product-catalog');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/shopping-cart');
        break;
      case 3:
        // Already on About Us screen
        break;
    }
  }
}
