import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
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
    
    final borderColor = isDark ? const Color(0xFF2E3B4E) : const Color(0xFFE2E8F0);
    final textColor = theme.colorScheme.onSurface;
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: subtextColor,
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Clean, minimal price description
                  Text(
                    item.quantity > 1 
                        ? '\$${item.price.toStringAsFixed(2)} each' 
                        : '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: subtextColor,
                    ),
                  ),
                  if (item.quantity > 1) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Total: \$${item.subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
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
            const SizedBox(width: 4),
            // Remove Button
            IconButton(
              onPressed: isProcessing ? null : onRemove,
              icon: const Icon(Icons.close_rounded),
              color: subtextColor.withOpacity(0.8),
              iconSize: 18,
              splashRadius: 18,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
