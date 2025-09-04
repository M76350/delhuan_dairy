import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

/// Search bar widget with real-time filtering and suggestions
class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  final VoidCallback? onFilterTap;
  final int filterCount;
  final List<String> suggestions;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Search dairy products...',
    required this.onSearchChanged,
    this.onFilterTap,
    this.filterCount = 0,
    this.suggestions = const [],
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _searchController.text.isEmpty;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _showSuggestions = _focusNode.hasFocus;
        _filteredSuggestions = widget.suggestions;
      } else {
        _showSuggestions = false;
        _filteredSuggestions = widget.suggestions
            .where((suggestion) =>
                suggestion.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    // Debounced search
    Future.delayed(Duration(milliseconds: 300), () {
      if (_searchController.text == query) {
        widget.onSearchChanged(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppTheme.lightTheme.colorScheme.primary
                  : colorScheme.outline,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Search Icon
              Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: _focusNode.hasFocus
                      ? AppTheme.lightTheme.colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
              // Search Input
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              // Clear Button
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                ),
              // Filter Button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onFilterTap?.call();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.filterCount > 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'tune',
                        color: widget.filterCount > 0
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      if (widget.filterCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              widget.filterCount.toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onError,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Search Suggestions
        if (_showSuggestions && widget.suggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Popular Searches',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...widget.suggestions.take(5).map(
                      (suggestion) => ListTile(
                        dense: true,
                        leading: CustomIconWidget(
                          iconName: 'search',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 16,
                        ),
                        title: Text(
                          suggestion,
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _searchController.text = suggestion;
                          _onSearchChanged(suggestion);
                          _focusNode.unfocus();
                        },
                      ),
                    ),
              ],
            ),
          ),
      ],
    );
  }
}
