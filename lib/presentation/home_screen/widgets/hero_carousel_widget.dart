import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/app_export.dart';

class HeroCarouselWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductTap;

  const HeroCarouselWidget({
    Key? key,
    required this.onProductTap,
  }) : super(key: key);

  @override
  State<HeroCarouselWidget> createState() => _HeroCarouselWidgetState();
}

class _HeroCarouselWidgetState extends State<HeroCarouselWidget>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;
  bool _isAutoPlaying = true;

  final List<Map<String, dynamic>> _featuredProducts = [
    {
      "id": 1,
      "name": "Premium Fresh Milk",
      "description":
          "Farm-fresh whole milk delivered daily from our local dairy farms. Rich in nutrients and perfect for your family's health.",
      "price": "\$4.99",
      "originalPrice": "\$5.99",
      "discount": "17% OFF",
      "image":
          "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Fresh Milk",
      "isOrganic": true,
      "rating": 4.8,
      "reviews": 245,
    },
    {
      "id": 2,
      "name": "Artisan Greek Yogurt",
      "description":
          "Creamy, protein-rich Greek yogurt made with traditional methods. Available in multiple flavors for your taste preference.",
      "price": "\$6.49",
      "originalPrice": "\$7.99",
      "discount": "19% OFF",
      "image":
          "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Yogurt",
      "isOrganic": true,
      "rating": 4.9,
      "reviews": 189,
    },
    {
      "id": 3,
      "name": "Fresh Paneer Blocks",
      "description":
          "Soft, fresh paneer made daily from pure milk. Perfect for traditional Indian dishes and healthy cooking.",
      "price": "\$8.99",
      "originalPrice": "\$10.49",
      "discount": "14% OFF",
      "image":
          "https://images.pexels.com/photos/4198019/pexels-photo-4198019.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Paneer",
      "isOrganic": false,
      "rating": 4.7,
      "reviews": 156,
    },
    {
      "id": 4,
      "name": "Premium Butter",
      "description":
          "Creamy, rich butter churned from fresh cream. Perfect for cooking, baking, and spreading on your favorite bread.",
      "price": "\$5.99",
      "originalPrice": "\$6.99",
      "discount": "14% OFF",
      "image":
          "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800",
      "category": "Butter",
      "isOrganic": true,
      "rating": 4.6,
      "reviews": 203,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (_isAutoPlaying) {
      Future.delayed(Duration(seconds: 4), () {
        if (mounted && _isAutoPlaying) {
          _nextPage();
          _startAutoPlay();
        }
      });
    }
  }

  void _nextPage() {
    if (_currentIndex < _featuredProducts.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pauseAutoPlay() {
    setState(() {
      _isAutoPlaying = false;
    });
  }

  void _resumeAutoPlay() {
    setState(() {
      _isAutoPlaying = true;
    });
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 45.h,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) => _pauseAutoPlay(),
                onTapUp: (_) => _resumeAutoPlay(),
                onTapCancel: () => _resumeAutoPlay(),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _featuredProducts[index];
                    return _buildCarouselItem(product);
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => widget.onProductTap(product),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'product_${product["id"]}',
                child: CustomImageWidget(
                  imageUrl: product["image"] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 3.h,
                right: 4.w,
                child: product["isOrganic"] == true
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ORGANIC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              Positioned(
                top: 3.h,
                left: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product["discount"] as String,
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSecondary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4.h,
                left: 4.w,
                right: 4.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["name"] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      product["description"] as String,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          product["price"] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          product["originalPrice"] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${product["rating"]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _featuredProducts.length,
      effect: ExpandingDotsEffect(
        activeDotColor: AppTheme.lightTheme.colorScheme.primary,
        dotColor: AppTheme.lightTheme.colorScheme.outline,
        dotHeight: 1.h,
        dotWidth: 2.w,
        expansionFactor: 3,
        spacing: 1.w,
      ),
    );
  }
}
