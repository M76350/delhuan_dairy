import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons.dart';
import './widgets/product_image_carousel.dart';
import './widgets/product_info_section.dart';
import './widgets/quantity_selector.dart';
import './widgets/related_products.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;

  int _selectedQuantity = 1;
  bool _isLoading = true;
  Map<String, dynamic>? _productData;

  // Mock product data
  final Map<String, dynamic> _mockProduct = {
    "id": "1",
    "name": "Fresh Organic Milk",
    "price": "\$5.99",
    "images": [
      "https://images.unsplash.com/photo-1550583724-b2692b85b150?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1563636619-e9143da7973b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1559181567-c3190ca9959b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    ],
    "description":
        "Premium quality organic milk sourced from grass-fed cows. Rich in essential nutrients, vitamins, and minerals. Our milk undergoes rigorous quality testing to ensure freshness and purity. Perfect for drinking, cooking, and baking. Delivered fresh daily from our local dairy farm to your doorstep.",
    "availability": true,
    "fatContent": "3.5%",
    "expiration": "7 days",
    "quantity": "1L",
    "rating": 4.8,
    "reviews": 124,
    "category": "Dairy",
    "brand": "Delhuan Dairy",
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _scrollController = ScrollController();
    _loadProductData();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadProductData() async {
    // Simulate loading product data
    await Future.delayed(Duration(milliseconds: 1200));

    setState(() {
      _productData = _mockProduct;
      _isLoading = false;
    });

    _fadeAnimationController.forward();
  }

  Future<void> _refreshProductData() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    await _loadProductData();
  }

  void _onQuantityChanged(int quantity) {
    setState(() {
      _selectedQuantity = quantity;
    });
  }

  Future<void> _shareProduct() async {
    final product = _productData!;
    final shareText = '''
Check out this amazing product from Delhuan Dairy!

${product['name']}
Price: ${product['price']}
Rating: ${product['rating']}/5

Get fresh dairy products delivered to your door!
''';

    try {
      // For mobile platforms, this would use the system share sheet
      // For web, we'll copy to clipboard
      await Clipboard.setData(ClipboardData(text: shareText));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product details copied to clipboard!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to share product'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _isLoading ? _buildLoadingState() : _buildProductContent(),
    );
  }

  Widget _buildLoadingState() {
    return SafeArea(
      child: Column(
        children: [
          // Loading AppBar
          Container(
            height: kToolbarHeight,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Loading Image
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),

                  // Loading Content
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Loading title
                        Container(
                          width: 70.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Loading price
                        Container(
                          width: 30.w,
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Loading description
                        ...List.generate(
                            3,
                            (index) => Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Container(
                                    width: index == 2 ? 60.w : double.infinity,
                                    height: 2.h,
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContent() {
    final product = _productData!;
    final isAvailable = product['availability'] as bool? ?? true;
    final images = (product['images'] as List<dynamic>?)?.cast<String>() ?? [];

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshProductData,
        color: AppTheme.lightTheme.primaryColor,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: true,
              backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor
                  .withValues(alpha: 0.95),
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _shareProduct();
                  },
                  child: Container(
                    margin: EdgeInsets.all(2.w),
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow
                              .withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            // Product Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Carousel
                    ProductImageCarousel(
                      images: images,
                      heroTag: 'product_${product['id']}',
                    ),

                    // Product Information
                    ProductInfoSection(product: product),

                    // Quantity Selector
                    QuantitySelector(
                      initialQuantity: _selectedQuantity,
                      onQuantityChanged: _onQuantityChanged,
                      maxQuantity: 10,
                      isEnabled: isAvailable,
                    ),

                    // Action Buttons
                    ActionButtons(
                      product: product,
                      quantity: _selectedQuantity,
                      isAvailable: isAvailable,
                    ),

                    // Related Products
                    RelatedProducts(
                      currentProductId: product['id'] as String,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
