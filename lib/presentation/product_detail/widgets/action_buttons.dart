import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class ActionButtons extends StatefulWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final bool isAvailable;

  const ActionButtons({
    Key? key,
    required this.product,
    required this.quantity,
    required this.isAvailable,
  }) : super(key: key);

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons>
    with TickerProviderStateMixin {
  bool _isAddingToCart = false;
  late AnimationController _successAnimationController;
  late Animation<double> _successScaleAnimation;

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _successScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _successAnimationController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    if (!widget.isAvailable) return;

    setState(() {
      _isAddingToCart = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate adding to cart
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isAddingToCart = false;
    });

    _successAnimationController.forward().then((_) {
      _successAnimationController.reverse();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product['name']} added to cart!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _buyNowViaWhatsApp() async {
    final product = widget.product;
    final productName = product['name'] as String? ?? 'Product';
    final productPrice = product['price'] as String? ?? '\$0.00';

    final message = '''
Hello! I'm interested in purchasing:

Product: $productName
Price: $productPrice
Quantity: ${widget.quantity}
Total: ${_calculateTotal()}

Please let me know about availability and delivery options.
''';

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/1234567890?text=$encodedMessage';

    try {
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        HapticFeedback.lightImpact();
      } else {
        _showErrorSnackBar('WhatsApp is not installed on this device');
      }
    } catch (e) {
      _showErrorSnackBar('Unable to open WhatsApp');
    }
  }

  String _calculateTotal() {
    final priceString = widget.product['price'] as String? ?? '\$0.00';
    final price = double.tryParse(priceString.replaceAll('\$', '')) ?? 0.0;
    final total = price * widget.quantity;
    return '\$${total.toStringAsFixed(2)}';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _notifyWhenAvailable() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notify When Available'),
        content: Text(
            'We\'ll notify you when ${widget.product['name']} is back in stock.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'You\'ll be notified when this product is available!'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              );
            },
            child: Text('Notify Me'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Primary Action Button (Add to Cart)
          AnimatedBuilder(
            animation: _successScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _successScaleAnimation.value,
                child: SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed:
                        widget.isAvailable ? _addToCart : _notifyWhenAvailable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isAvailable
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline,
                      foregroundColor: widget.isAvailable
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      elevation: widget.isAvailable ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isAddingToCart
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Adding to Cart...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: widget.isAvailable
                                    ? 'shopping_cart'
                                    : 'notifications',
                                color: widget.isAvailable
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                widget.isAvailable
                                    ? 'Add to Cart'
                                    : 'Notify When Available',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: widget.isAvailable
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),

          if (widget.isAvailable) ...[
            SizedBox(height: 2.h),

            // Secondary Action Button (Buy Now via WhatsApp)
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: OutlinedButton(
                onPressed: _buyNowViaWhatsApp,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.primaryColor,
                  side: BorderSide(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'chat',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Buy Now via WhatsApp',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
