import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Filter bottom sheet widget for advanced product filtering
class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = RangeValues(0, 100);

  final List<String> _productTypes = [
    'Milk',
    'Curd',
    'Paneer',
    'Butter',
    'Ghee',
    'Cheese',
    'Yogurt',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 0,
      (_filters['maxPrice'] as double?) ?? 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Products',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text('Clear All'),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildSectionTitle('Price Range'),
                  SizedBox(height: 16),
                  _buildPriceRangeSlider(theme),
                  SizedBox(height: 24),

                  // Product Types
                  _buildSectionTitle('Product Types'),
                  SizedBox(height: 16),
                  _buildProductTypeFilters(theme),
                  SizedBox(height: 24),

                  // Availability
                  _buildSectionTitle('Availability'),
                  SizedBox(height: 16),
                  _buildAvailabilityFilter(theme),
                  SizedBox(height: 24),

                  // Sort By
                  _buildSectionTitle('Sort By'),
                  SizedBox(height: 16),
                  _buildSortOptions(theme),
                ],
              ),
            ),
          ),
          // Action Buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outline),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildPriceRangeSlider(ThemeData theme) {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductTypeFilters(ThemeData theme) {
    final selectedTypes = (_filters['productTypes'] as List<String>?) ?? [];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _productTypes.map((type) {
        final isSelected = selectedTypes.contains(type);
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              if (isSelected) {
                selectedTypes.remove(type);
              } else {
                selectedTypes.add(type);
              }
              _filters['productTypes'] = selectedTypes;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ),
            child: Text(
              type,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvailabilityFilter(ThemeData theme) {
    final showInStockOnly = (_filters['inStockOnly'] as bool?) ?? false;

    return SwitchListTile(
      title: Text('Show in-stock products only'),
      subtitle: Text('Hide out of stock items'),
      value: showInStockOnly,
      onChanged: (bool value) {
        HapticFeedback.lightImpact();
        setState(() {
          _filters['inStockOnly'] = value;
        });
      },
    );
  }

  Widget _buildSortOptions(ThemeData theme) {
    final sortBy = (_filters['sortBy'] as String?) ?? 'name';
    final sortOptions = [
      {'value': 'name', 'label': 'Name (A-Z)'},
      {'value': 'price_low', 'label': 'Price (Low to High)'},
      {'value': 'price_high', 'label': 'Price (High to Low)'},
      {'value': 'newest', 'label': 'Newest First'},
    ];

    return Column(
      children: sortOptions.map((option) {
        final isSelected = sortBy == option['value'];
        return RadioListTile<String>(
          title: Text(option['label'] as String),
          value: option['value'] as String,
          groupValue: sortBy,
          onChanged: (String? value) {
            HapticFeedback.lightImpact();
            setState(() {
              _filters['sortBy'] = value;
            });
          },
        );
      }).toList(),
    );
  }

  void _clearAllFilters() {
    HapticFeedback.lightImpact();
    setState(() {
      _filters.clear();
      _priceRange = RangeValues(0, 100);
    });
  }

  void _applyFilters() {
    HapticFeedback.lightImpact();
    _filters['minPrice'] = _priceRange.start;
    _filters['maxPrice'] = _priceRange.end;
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
