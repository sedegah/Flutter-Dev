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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 18,
            onPressed: isProcessing ? null : onDecrement,
            icon: Icon(
              Icons.remove,
              color: isProcessing ? Colors.grey[300] : Colors.grey[600],
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            splashRadius: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: SizedBox(
                width: 24,
                child: Text(
                  '$quantity',
                  key: ValueKey<int>(quantity),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 18,
            onPressed: isProcessing ? null : onIncrement,
            icon: Icon(
              Icons.add,
              color: isProcessing ? Colors.grey[300] : const Color(0xFF6366F1),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
