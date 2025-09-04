import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CheckoutButtons extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final VoidCallback? onWhatsAppPressed;
  final VoidCallback? onCallPressed;

  const CheckoutButtons({
    Key? key,
    required this.cartItems,
    required this.total,
    this.onWhatsAppPressed,
    this.onCallPressed,
  }) : super(key: key);

  String _formatOrderMessage() {
    String message =
        "Hello! I'd like to place an order from Delhuan Dairy:\n\n";

    for (var item in cartItems) {
      final name = item['name'] as String? ?? 'Unknown Product';
      final quantity = item['quantity'] as int? ?? 1;
      final price =
          double.tryParse(item['price'].toString().replaceAll('\$', '')) ?? 0.0;
      final itemTotal = price * quantity;

      message += "• $name x$quantity - \$${itemTotal.toStringAsFixed(2)}\n";
    }

    message += "\nTotal: \$${total.toStringAsFixed(2)}\n\n";
    message += "Please confirm availability and delivery details. Thank you!";

    return message;
  }

  Future<void> _launchWhatsApp() async {
    try {
      final message = _formatOrderMessage();
      final encodedMessage = Uri.encodeComponent(message);
      final whatsappUrl = "https://wa.me/1234567890?text=$encodedMessage";

      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  Future<void> _launchPhone() async {
    try {
      final phoneUrl = "tel:+1234567890";
      final uri = Uri.parse(phoneUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary WhatsApp Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (onWhatsAppPressed != null) {
                    onWhatsAppPressed!();
                  } else {
                    _launchWhatsApp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp green
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'chat',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      children: [
                        Text(
                          'Checkout via WhatsApp',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Send order details instantly',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Secondary Call Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (onCallPressed != null) {
                    onCallPressed!();
                  } else {
                    _launchPhone();
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'phone',
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      children: [
                        Text(
                          'Call to Order',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Speak directly with our team',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),

            // Order Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Orders are processed during business hours (9 AM - 6 PM)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
