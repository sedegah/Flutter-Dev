import 'package:flutter/material.dart';

class FloatingCheckoutBar extends StatelessWidget {
  final double totalPrice;
  final int itemCount;
  final VoidCallback onCheckout;

  const FloatingCheckoutBar({
    Key? key,
    required this.totalPrice,
    required this.itemCount,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Monochrome theme colors
    // Light mode -> Dark bar (Black background, White text)
    // Dark mode -> Light bar (White background, Black text)
    final bgColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final subtextColor = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
    final buttonBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final buttonTextColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Order Total Section
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDER TOTAL (${itemCount} item${itemCount != 1 ? 's' : ''})',
                style: TextStyle(
                  color: subtextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: totalPrice),
                duration: const Duration(milliseconds: 250),
                builder: (context, value, child) {
                  return Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  );
                },
              ),
            ],
          ),
          // Checkout Button Section
          OutlinedButton(
            onPressed: itemCount > 0 ? onCheckout : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: buttonBgColor,
              foregroundColor: buttonTextColor,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledBackgroundColor: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CHECKOUT',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: itemCount > 0 
                        ? buttonTextColor 
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: itemCount > 0 
                      ? buttonTextColor 
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
