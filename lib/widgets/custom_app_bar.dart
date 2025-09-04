import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Contemporary Dairy Minimalism design
/// Features contextual actions, search functionality, and adaptive behavior
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearchButton;
  final bool showCartButton;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onCartPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.showSearchButton = false,
    this.showCartButton = false,
    this.onSearchPressed,
    this.onCartPressed,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 1.0,
    this.centerTitle = true,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build actions list with contextual buttons
    List<Widget> appBarActions = [];

    if (showSearchButton) {
      appBarActions.add(
        IconButton(
          icon: Icon(Icons.search_rounded),
          onPressed: () {
            HapticFeedback.lightImpact(); // Haptic micro-feedback
            if (onSearchPressed != null) {
              onSearchPressed!();
            } else {
              _showSearchBottomSheet(context);
            }
          },
          tooltip: 'Search products',
        ),
      );
    }

    if (showCartButton) {
      appBarActions.add(
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart_outlined),
              // Cart badge could be added here
            ],
          ),
          onPressed: () {
            HapticFeedback.lightImpact(); // Haptic micro-feedback
            if (onCartPressed != null) {
              onCartPressed!();
            } else {
              Navigator.pushNamed(context, '/shopping-cart');
            }
          },
          tooltip: 'Shopping cart',
        ),
      );
    }

    if (actions != null) {
      appBarActions.addAll(actions!);
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  tooltip: 'Back',
                )
              : null),
      actions: appBarActions.isNotEmpty ? appBarActions : null,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  /// Shows contextual bottom sheet for search functionality
  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
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
            // Search header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search dairy products...',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (value) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/product-catalog');
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            // Search suggestions or recent searches could go here
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    'Popular Products',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  _buildSearchSuggestion(
                      context, 'Fresh Milk', Icons.local_drink),
                  _buildSearchSuggestion(context, 'Organic Cheese', Icons.cake),
                  _buildSearchSuggestion(
                      context, 'Greek Yogurt', Icons.icecream),
                  _buildSearchSuggestion(
                      context, 'Butter', Icons.breakfast_dining),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestion(
      BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
        Navigator.pushNamed(context, '/product-catalog');
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Specialized AppBar variants for different screens
class CustomHomeAppBar extends CustomAppBar {
  const CustomHomeAppBar({Key? key})
      : super(
          key: key,
          title: 'Fresh Dairy',
          showBackButton: false,
          showSearchButton: true,
          showCartButton: true,
        );
}

class CustomProductAppBar extends CustomAppBar {
  const CustomProductAppBar({Key? key})
      : super(
          key: key,
          title: 'Products',
          showSearchButton: true,
          showCartButton: true,
        );
}

class CustomCartAppBar extends CustomAppBar {
  const CustomCartAppBar({Key? key})
      : super(
          key: key,
          title: 'Shopping Cart',
          showCartButton: false,
        );
}
