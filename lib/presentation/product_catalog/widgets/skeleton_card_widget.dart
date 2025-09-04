import 'package:flutter/material.dart';

/// Skeleton loading card widget for product catalog
class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({Key? key}) : super(key: key);

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface
                        .withValues(alpha: _animation.value * 0.1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.0),
                    ),
                  ),
                ),
              ),
              // Content skeleton
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title skeleton
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface
                              .withValues(alpha: _animation.value * 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Description skeleton
                      Container(
                        height: 12,
                        width: double.infinity * 0.8,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface
                              .withValues(alpha: _animation.value * 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: double.infinity * 0.6,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface
                              .withValues(alpha: _animation.value * 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Spacer(),
                      // Price and button skeleton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 16,
                            width: 60,
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface
                                  .withValues(alpha: _animation.value * 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 60,
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface
                                  .withValues(alpha: _animation.value * 0.1),
                              borderRadius: BorderRadius.circular(16),
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
        );
      },
    );
  }
}
