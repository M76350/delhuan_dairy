import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MissionValuesWidget extends StatefulWidget {
  const MissionValuesWidget({Key? key}) : super(key: key);

  @override
  State<MissionValuesWidget> createState() => _MissionValuesWidgetState();
}

class _MissionValuesWidgetState extends State<MissionValuesWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _cardAnimationControllers;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _cardSlideAnimations;

  final List<Map<String, dynamic>> missionValues = [
    {
      "title": "Our Mission",
      "description":
          "To provide the freshest, highest quality dairy products while supporting sustainable farming practices and nurturing healthy communities.",
      "icon": "flag",
      "color": Color(0xFF4CAF50),
      "illustration":
          "https://images.pexels.com/photos/1300550/pexels-photo-1300550.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "title": "Quality First",
      "description":
          "We never compromise on quality. Every product undergoes rigorous testing to ensure it meets our exceptional standards.",
      "icon": "star",
      "color": Color(0xFFFF9800),
      "illustration":
          "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "title": "Sustainability",
      "description":
          "We are committed to environmentally responsible farming practices that protect our planet for future generations.",
      "icon": "eco",
      "color": Color(0xFF4CAF50),
      "illustration":
          "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "title": "Community Care",
      "description":
          "Supporting local farmers and contributing to the well-being of our community is at the heart of everything we do.",
      "icon": "favorite",
      "color": Color(0xFFE91E63),
      "illustration":
          "https://images.pexels.com/photos/1300550/pexels-photo-1300550.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationControllers = List.generate(
      missionValues.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _cardAnimations = _cardAnimationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _cardSlideAnimations = _cardAnimationControllers.map((controller) {
      return Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 800));
    if (mounted) {
      for (int i = 0; i < _cardAnimationControllers.length; i++) {
        await Future.delayed(Duration(milliseconds: 150));
        if (mounted) {
          _cardAnimationControllers[i].forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mission & Values',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'The principles that guide everything we do',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: missionValues.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final item = missionValues[index];
              return FadeTransition(
                opacity: _cardAnimations[index],
                child: SlideTransition(
                  position: _cardSlideAnimations[index],
                  child: _buildMissionValueCard(item, index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMissionValueCard(Map<String, dynamic> item, int index) {
    final isEven = index % 2 == 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEven) ...[
                _buildContentSection(item),
                SizedBox(width: 3.w),
                _buildImageSection(item),
              ] else ...[
                _buildImageSection(item),
                SizedBox(width: 3.w),
                _buildContentSection(item),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(Map<String, dynamic> item) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: (item["color"] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: item["icon"],
                    color: item["color"],
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  item["title"],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            item["description"],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              fontSize: 11.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(Map<String, dynamic> item) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomImageWidget(
            imageUrl: item["illustration"],
            width: double.infinity,
            height: 12.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
