import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

/// Product card widget displaying dairy product information with interactive elements
class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistToggle;
  final VoidCallback? onShare;
  final bool isInWishlist;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onWishlistToggle,
    this.onShare,
    this.isInWishlist = false,
  }) : super(key: key);

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onTap,
            onLongPress: () => _showQuickActions(context),
            child: Card(
              elevation: _elevationAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Hero Animation
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.0),
                          ),
                          child: Hero(
                            tag: 'product_${widget.product["id"]}',
                            child: CustomImageWidget(
                              imageUrl: widget.product["image"] as String,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Wishlist Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              widget.onWishlistToggle?.call();
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.surface.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.shadow
                                        .withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CustomIconWidget(
                                iconName: widget.isInWishlist
                                    ? 'favorite'
                                    : 'favorite_border',
                                color: widget.isInWishlist
                                    ? Colors.red
                                    : colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        // Availability Badge
                        if (widget.product["availability"] == "Out of Stock")
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Out of Stock',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onError,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Product Information
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            widget.product["name"] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          // Product Description
                          Expanded(
                            child: Text(
                              widget.product["description"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Price and Add to Cart
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product["price"] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.product["availability"] !=
                                        "Out of Stock"
                                    ? () {
                                        HapticFeedback.lightImpact();
                                        widget.onAddToCart?.call();
                                      }
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: widget.product["availability"] !=
                                            "Out of Stock"
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : colorScheme.onSurface
                                            .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'add_shopping_cart',
                                        color: widget.product["availability"] !=
                                                "Out of Stock"
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Add',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color:
                                              widget.product["availability"] !=
                                                      "Out of Stock"
                                                  ? AppTheme.lightTheme
                                                      .colorScheme.onPrimary
                                                  : colorScheme.onSurface
                                                      .withValues(alpha: 0.5),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }

  void _showQuickActions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Quick Actions
            ListTile(
              leading: CustomIconWidget(
                iconName: widget.isInWishlist ? 'favorite' : 'favorite_border',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(widget.isInWishlist
                  ? 'Remove from Wishlist'
                  : 'Add to Wishlist'),
              onTap: () {
                Navigator.pop(context);
                widget.onWishlistToggle?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Share via WhatsApp'),
              onTap: () {
                Navigator.pop(context);
                widget.onShare?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('View Similar Products'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to similar products
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
