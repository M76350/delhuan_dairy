import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing Contemporary Dairy Minimalism
/// Features contextual navigation with haptic feedback and smooth transitions
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showLabels;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = [
      _NavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
        route: '/home-screen',
      ),
      _NavigationItem(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: 'Products',
        route: '/product-catalog',
      ),
      _NavigationItem(
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart_rounded,
        label: 'Cart',
        route: '/shopping-cart',
      ),
      _NavigationItem(
        icon: Icons.info_outline,
        activeIcon: Icons.info_rounded,
        label: 'About',
        route: '/about-us',
      ),
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = currentIndex == index;

      return Expanded(
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact(); // Haptic micro-feedback
            if (!isSelected) {
              onTap(index);
              Navigator.pushReplacementNamed(context, item.route);
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withAlpha(26)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withAlpha(153),
                    size: 24,
                  ),
                ),
                if (showLabels) ...[
                  SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(153),
                    ),
                    child: Text(item.label),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

/// Navigation item data class
class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Floating Bottom Navigation Bar variant with elevated design
class CustomFloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showLabels;

  const CustomFloatingBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.all(16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        color: colorScheme.surface,
        child: Container(
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildFloatingNavigationItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingNavigationItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = [
      _NavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
        route: '/home-screen',
      ),
      _NavigationItem(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: 'Products',
        route: '/product-catalog',
      ),
      _NavigationItem(
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart_rounded,
        label: 'Cart',
        route: '/shopping-cart',
      ),
      _NavigationItem(
        icon: Icons.info_outline,
        activeIcon: Icons.info_rounded,
        label: 'About',
        route: '/about-us',
      ),
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = currentIndex == index;

      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (!isSelected) {
            onTap(index);
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isSelected ? item.activeIcon : item.icon,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withAlpha(153),
            size: 24,
          ),
        ),
      );
    }).toList();
  }
}
