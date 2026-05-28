import 'package:flutter/material.dart';

class AnimatedQuantityBadge extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isProcessing;

  const AnimatedQuantityBadge({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final borderColor = isDark ? const Color(0xFF2E3B4E) : const Color(0xFFE2E8F0);
    final bgColor = isDark ? const Color(0xFF1E293B).withOpacity(0.5) : const Color(0xFFF8FAFC);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            onPressed: isProcessing ? null : onDecrement,
            icon: Icon(
              Icons.remove,
              color: isProcessing 
                  ? textColor.withOpacity(0.3) 
                  : textColor.withOpacity(0.7),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            splashRadius: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: SizedBox(
                width: 20,
                child: Text(
                  '$quantity',
                  key: ValueKey<int>(quantity),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 16,
            onPressed: isProcessing ? null : onIncrement,
            icon: Icon(
              Icons.add,
              color: isProcessing 
                  ? textColor.withOpacity(0.3) 
                  : textColor,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            splashRadius: 16,
          ),
        ],
      ),
    );
  }
}
