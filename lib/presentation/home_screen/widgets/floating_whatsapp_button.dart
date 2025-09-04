import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class FloatingWhatsAppButton extends StatefulWidget {
  const FloatingWhatsAppButton({Key? key}) : super(key: key);

  @override
  State<FloatingWhatsAppButton> createState() => _FloatingWhatsAppButtonState();
}

class _FloatingWhatsAppButtonState extends State<FloatingWhatsAppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  final String _whatsappNumber = "+1234567890"; // Mock WhatsApp number
  final String _defaultMessage =
      "Hi! I'm interested in your dairy products. Can you help me with more information?";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animation with delay
    Future.delayed(Duration(milliseconds: 2000), () {
      if (mounted) {
        _animationController.forward();
        _startPulseAnimation();
      }
    });
  }

  void _startPulseAnimation() {
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp() async {
    try {
      HapticFeedback.mediumImpact();

      final encodedMessage = Uri.encodeComponent(_defaultMessage);
      final whatsappUrl = "https://wa.me/$_whatsappNumber?text=$encodedMessage";
      final whatsappUri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(
          whatsappUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to web WhatsApp
        final webWhatsappUrl =
            "https://web.whatsapp.com/send?phone=$_whatsappNumber&text=$encodedMessage";
        final webWhatsappUri = Uri.parse(webWhatsappUrl);

        if (await canLaunchUrl(webWhatsappUri)) {
          await launchUrl(
            webWhatsappUri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          _showErrorSnackBar();
        }
      }
    } catch (e) {
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unable to open WhatsApp. Please try again later.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF25D366),
                  Color(0xFF128C7E),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF25D366).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Color(0xFF25D366).withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: _launchWhatsApp,
                onLongPress: () {
                  HapticFeedback.heavyImpact();
                  _showContactOptions();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'chat',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 35.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Delhuan Dairy',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Choose your preferred way to get in touch with us',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildContactOption(
                    'WhatsApp Chat',
                    'Send us a message instantly',
                    'chat',
                    Color(0xFF25D366),
                    () {
                      Navigator.pop(context);
                      _launchWhatsApp();
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildContactOption(
                    'Phone Call',
                    'Speak directly with our team',
                    'phone',
                    AppTheme.lightTheme.colorScheme.primary,
                    () {
                      Navigator.pop(context);
                      _launchPhone();
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildContactOption(
                    'Visit Store',
                    'Find our location on the map',
                    'location_on',
                    AppTheme.lightTheme.colorScheme.secondary,
                    () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about-us');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    String subtitle,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhone() async {
    try {
      HapticFeedback.mediumImpact();
      final phoneUri = Uri.parse("tel:$_whatsappNumber");

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackBar();
      }
    } catch (e) {
      _showErrorSnackBar();
    }
  }
}
