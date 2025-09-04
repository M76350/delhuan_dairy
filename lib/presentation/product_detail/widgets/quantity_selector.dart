import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onQuantityChanged;
  final int maxQuantity;
  final bool isEnabled;

  const QuantitySelector({
    Key? key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
    this.maxQuantity = 10,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector>
    with SingleTickerProviderStateMixin {
  late int _quantity;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1 &&
        newQuantity <= widget.maxQuantity &&
        widget.isEnabled) {
      setState(() {
        _quantity = newQuantity;
      });
      widget.onQuantityChanged(_quantity);
      HapticFeedback.lightImpact();
      _animateButton();
    }
  }

  void _animateButton() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildQuantityButton(
                icon: 'remove',
                onTap: () => _updateQuantity(_quantity - 1),
                isEnabled: widget.isEnabled && _quantity > 1,
              ),
              SizedBox(width: 4.w),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 20.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _quantity.toString(),
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 4.w),
              _buildQuantityButton(
                icon: 'add',
                onTap: () => _updateQuantity(_quantity + 1),
                isEnabled: widget.isEnabled && _quantity < widget.maxQuantity,
              ),
              Spacer(),
              if (widget.maxQuantity > 1) ...[
                Text(
                  'Max: ${widget.maxQuantity}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required String icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: isEnabled
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.5),
            size: 20,
          ),
        ),
      ),
    );
  }
}
