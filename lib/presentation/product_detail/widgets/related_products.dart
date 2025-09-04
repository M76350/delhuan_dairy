import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedProducts extends StatefulWidget {
  final String currentProductId;

  const RelatedProducts({
    Key? key,
    required this.currentProductId,
  }) : super(key: key);

  @override
  State<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  final List<Map<String, dynamic>> _relatedProducts = [
    {
      "id": "2",
      "name": "Organic Greek Yogurt",
      "price": "\$4.99",
      "image":
          "https://images.unsplash.com/photo-1571212515416-fdc2d2d3e9b0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.8,
      "availability": true,
    },
    {
      "id": "3",
      "name": "Fresh Butter",
      "price": "\$3.49",
      "image":
          "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.6,
      "availability": true,
    },
    {
      "id": "4",
      "name": "Artisan Cheese",
      "price": "\$8.99",
      "image":
          "https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.9,
      "availability": false,
    },
    {
      "id": "5",
      "name": "Pure Ghee",
      "price": "\$12.99",
      "image":
          "https://images.unsplash.com/photo-1628088062854-d1870b4553da?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.7,
      "availability": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(
      _relatedProducts.length,
      (index) => Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          (index * 0.2) + 0.6,
          curve: Curves.easeOutCubic,
        ),
      )),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _relatedProducts
        .where((product) => product['id'] != widget.currentProductId)
        .toList();

    if (filteredProducts.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Related Products',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/product-catalog');
                  },
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: _slideAnimations[index],
                  child: _buildProductCard(filteredProducts[index], index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final isAvailable = product['availability'] as bool? ?? true;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(
          context,
          '/product-detail',
          arguments: product,
        );
      },
      child: Container(
        width: 45.w,
        margin: EdgeInsets.only(right: 4.w),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: product['image'] as String,
                      width: double.infinity,
                      height: 18.h,
                      fit: BoxFit.cover,
                    ),
                    if (!isAvailable)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Out of Stock',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onError,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product Info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),

                      // Rating
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: Colors.amber,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            product['rating'].toString(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      // Price
                      Text(
                        product['price'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
