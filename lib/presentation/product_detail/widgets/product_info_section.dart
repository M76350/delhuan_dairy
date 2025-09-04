import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoSection extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isAvailable = (product['availability'] as bool? ?? true);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product['name'] as String? ?? 'Product Name',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          // Price and Availability
          Row(
            children: [
              Text(
                product['price'] as String? ?? '\$0.00',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.primaryColor,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isAvailable ? 'check_circle' : 'cancel',
                      color: isAvailable
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      isAvailable ? 'In Stock' : 'Out of Stock',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isAvailable
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Product Details Chips
          _buildProductDetailsChips(),
          SizedBox(height: 3.h),

          // Description Section
          _buildDescriptionSection(),
        ],
      ),
    );
  }

  Widget _buildProductDetailsChips() {
    final product = widget.product;
    final details = [
      {
        'icon': 'opacity',
        'label': 'Fat Content',
        'value': product['fatContent'] as String? ?? '3.5%',
      },
      {
        'icon': 'schedule',
        'label': 'Expires',
        'value': product['expiration'] as String? ?? '7 days',
      },
      {
        'icon': 'scale',
        'label': 'Quantity',
        'value': product['quantity'] as String? ?? '1L',
      },
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: details.map((detail) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: detail['icon'] as String,
                color: AppTheme.lightTheme.primaryColor,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail['label'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    detail['value'] as String,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionSection() {
    final description = widget.product['description'] as String? ??
        'Fresh, high-quality dairy product made with care and attention to detail. Perfect for your daily nutritional needs.';

    final shouldShowReadMore = description.length > 150;
    final displayText = _isDescriptionExpanded || !shouldShowReadMore
        ? description
        : '${description.substring(0, 150)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        AnimatedCrossFade(
          duration: Duration(milliseconds: 300),
          crossFadeState: _isDescriptionExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            displayText,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          secondChild: Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
        if (shouldShowReadMore) ...[
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Text(
              _isDescriptionExpanded ? 'Read Less' : 'Read More',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
