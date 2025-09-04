import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class ContactInfoWidget extends StatefulWidget {
  const ContactInfoWidget({Key? key}) : super(key: key);

  @override
  State<ContactInfoWidget> createState() => _ContactInfoWidgetState();
}

class _ContactInfoWidgetState extends State<ContactInfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> contactMethods = [
    {
      "title": "Call Us",
      "subtitle": "+91 98765 43210",
      "description": "Speak directly with our team",
      "icon": "phone",
      "color": Color(0xFF4CAF50),
      "action": "call",
      "value": "+919876543210",
    },
    {
      "title": "WhatsApp",
      "subtitle": "+91 98765 43210",
      "description": "Quick messages and orders",
      "icon": "chat",
      "color": Color(0xFF25D366),
      "action": "whatsapp",
      "value": "+919876543210",
    },
    {
      "title": "Email Us",
      "subtitle": "info@delhuandairy.com",
      "description": "For detailed inquiries",
      "icon": "email",
      "color": Color(0xFF2196F3),
      "action": "email",
      "value": "info@delhuandairy.com",
    },
    {
      "title": "Visit Us",
      "subtitle": "123 Dairy Farm Road",
      "description": "Green Valley, Delhi 110001",
      "icon": "location_on",
      "color": Color(0xFFFF9800),
      "action": "address",
      "value": "123 Dairy Farm Road, Green Valley, Delhi 110001",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get In Touch',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'We\'re here to help with all your dairy needs',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 2.h),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: contactMethods.length,
                itemBuilder: (context, index) {
                  final contact = contactMethods[index];
                  return _buildContactCard(contact, index);
                },
              ),
              SizedBox(height: 3.h),
              // Social Media Section
              _buildSocialMediaSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact, int index) {
    return GestureDetector(
      onTap: () => _handleContactAction(contact),
      onLongPress: () => _copyToClipboard(contact),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: (contact["color"] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: contact["icon"],
                  color: contact["color"],
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              contact["title"],
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              contact["subtitle"],
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: contact["color"],
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              contact["description"],
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontSize: 10.sp,
                height: 1.3,
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: (contact["color"] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  contact["action"] == "call"
                      ? "Tap to Call"
                      : contact["action"] == "whatsapp"
                          ? "Tap to Message"
                          : contact["action"] == "email"
                              ? "Tap to Email"
                              : "Long press to copy",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: contact["color"],
                    fontWeight: FontWeight.w500,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    final socialMedia = [
      {
        "name": "Facebook",
        "icon": "facebook",
        "color": Color(0xFF1877F2),
        "url": "https://facebook.com/delhuandairy",
      },
      {
        "name": "Instagram",
        "icon": "camera_alt",
        "color": Color(0xFFE4405F),
        "url": "https://instagram.com/delhuandairy",
      },
      {
        "name": "Twitter",
        "icon": "alternate_email",
        "color": Color(0xFF1DA1F2),
        "url": "https://twitter.com/delhuandairy",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Us',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Stay updated with our latest products and offers',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: socialMedia.map((social) {
              return GestureDetector(
                onTap: () => _launchSocialMedia(social["url"] as String),
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: (social["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: social["icon"] as String,
                      color: social["color"] as Color,
                      size: 7.w,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _handleContactAction(Map<String, dynamic> contact) async {
    final action = contact["action"] as String;
    final value = contact["value"] as String;

    try {
      switch (action) {
        case "call":
          final Uri phoneUri = Uri.parse('tel:$value');
          if (await canLaunchUrl(phoneUri)) {
            await launchUrl(phoneUri);
          } else {
            _showErrorSnackBar('Could not make phone call');
          }
          break;
        case "whatsapp":
          final Uri whatsappUri = Uri.parse('https://wa.me/$value');
          if (await canLaunchUrl(whatsappUri)) {
            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
          } else {
            _showErrorSnackBar('Could not open WhatsApp');
          }
          break;
        case "email":
          final Uri emailUri =
              Uri.parse('mailto:$value?subject=Inquiry about Delhuan Dairy');
          if (await canLaunchUrl(emailUri)) {
            await launchUrl(emailUri);
          } else {
            _showErrorSnackBar('Could not open email client');
          }
          break;
        case "address":
          _copyToClipboard(contact);
          break;
      }
    } catch (e) {
      _showErrorSnackBar('Error performing action');
    }
  }

  void _copyToClipboard(Map<String, dynamic> contact) {
    final value = contact["value"] as String;
    Clipboard.setData(ClipboardData(text: value));

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${contact["title"]} copied to clipboard'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _launchSocialMedia(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open social media link');
      }
    } catch (e) {
      _showErrorSnackBar('Error opening social media');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
