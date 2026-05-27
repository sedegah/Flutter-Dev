import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/models/cart_event.dart';
import 'animated_quantity_badge.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final bool isProcessing;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF243046) : const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF),
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: -0.3,
                      color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? const Color(0xFF64748B) : Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: '\$${item.subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Quantity Controls
            AnimatedQuantityBadge(
              quantity: item.quantity,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
              isProcessing: isProcessing,
            ),
            const SizedBox(width: 8),
            // Remove Button
            IconButton(
              onPressed: isProcessing ? null : onRemove,
              icon: const Icon(Icons.close),
              color: isDark ? const Color(0xFF94A3B8) : Colors.grey[400],
              iconSize: 20,
              splashRadius: 24,
            ),
          ],
        ),
      ),
    );
  }
}
