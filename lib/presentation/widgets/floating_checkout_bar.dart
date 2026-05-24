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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Total',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: totalPrice),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$itemCount item${itemCount != 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                onPressed: itemCount > 0 ? onCheckout : null,
                icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                label: const Text(
                  'Checkout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6366F1),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
