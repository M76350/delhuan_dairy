import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/cart_item_card.dart';
import './widgets/checkout_buttons.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_card.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/checkout_buttons.dart';
import 'widgets/empty_cart_widget.dart';
import 'widgets/order_summary_card.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = false;
  int _currentBottomNavIndex = 2; // Cart tab

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCartData();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeIn),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
          parent: _headerAnimationController, curve: Curves.easeOut),
    );
    _headerAnimationController.forward();
  }

  void _loadCartData() {
    // Mock cart data - in real app, this would come from state management or API
    _cartItems = [
      {
        "id": 1,
        "name": "Fresh Whole Milk",
        "description": "Premium quality whole milk from grass-fed cows",
        "price": "\$4.99",
        "image":
            "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=800",
        "quantity": 2,
        "category": "Milk",
        "inStock": true,
      },
      {
        "id": 2,
        "name": "Greek Yogurt",
        "description": "Creamy Greek-style yogurt with live cultures",
        "price": "\$6.49",
        "image":
            "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800",
        "quantity": 1,
        "category": "Yogurt",
        "inStock": true,
      },
      {
        "id": 3,
        "name": "Organic Cheddar Cheese",
        "description": "Aged organic cheddar cheese, sharp and flavorful",
        "price": "\$8.99",
        "image":
            "https://images.pexels.com/photos/773253/pexels-photo-773253.jpeg?auto=compress&cs=tinysrgb&w=800",
        "quantity": 1,
        "category": "Cheese",
        "inStock": true,
      },
    ];
  }

  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) {
      final price =
          double.tryParse((item['price'] as String).replaceAll('\$', '')) ??
              0.0;
      final quantity = item['quantity'] as int? ?? 1;
      return sum + (price * quantity);
    });
  }

  double get _deliveryCharges {
    return _subtotal >= 50 ? 0.0 : 5.99;
  }

  double get _total {
    return _subtotal + _deliveryCharges;
  }

  int get _totalItems {
    return _cartItems.fold(
        0, (sum, item) => sum + (item['quantity'] as int? ?? 1));
  }

  void _updateItemQuantity(int itemId, int newQuantity) {
    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex]['quantity'] = newQuantity;
      }
    });
  }

  void _removeItem(int itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed from cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // In real app, implement undo functionality
          },
        ),
      ),
    );
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
  }

  void _navigateToProducts() {
    Navigator.pushNamed(context, '/product-catalog');
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomCartAppBar(),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_cartItems.isNotEmpty)
            CheckoutButtons(
              cartItems: _cartItems,
              total: _total,
            ),
          CustomBottomBar(
            currentIndex: _currentBottomNavIndex,
            onTap: _onBottomNavTap,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return EmptyCartWidget(
      onBrowseProducts: _navigateToProducts,
    );
  }

  Widget _buildCartContent() {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Header with order summary
        AnimatedBuilder(
          animation: _headerAnimationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerSlideAnimation,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Order',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '$_totalItems items',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${_total.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (_deliveryCharges == 0)
                            Text(
                              'Free Delivery',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Cart Items List
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshCart,
            color: theme.colorScheme.primary,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 2.h),
                    itemCount: _cartItems.length + 1, // +1 for order summary
                    itemBuilder: (context, index) {
                      if (index == _cartItems.length) {
                        // Order Summary Card at the end
                        return OrderSummaryCard(
                          subtotal: _subtotal,
                          deliveryCharges: _deliveryCharges,
                          total: _total,
                          itemCount: _totalItems,
                        );
                      }

                      final item = _cartItems[index];
                      return CartItemCard(
                        item: item,
                        onRemove: () => _removeItem(item['id'] as int),
                        onQuantityChanged: (newQuantity) =>
                            _updateItemQuantity(item['id'] as int, newQuantity),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}