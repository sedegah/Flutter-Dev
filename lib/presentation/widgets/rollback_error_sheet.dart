import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showRollbackErrorBottomSheet(
  BuildContext context, {
  required String errorMessage,
  required VoidCallback onDismiss,
}) {
  HapticFeedback.vibrate();

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  
  final bgColor = isDark ? const Color(0xFF161E2E) : Colors.white;
  final textColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
  final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
  final redColor = const Color(0xFFEF4444);

  showModalBottomSheet(
    context: context,
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: redColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SYSTEM ALERT',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.0,
                  color: redColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your cart state has been restored to ensure consistency.',
            style: TextStyle(
              fontSize: 12,
              color: subtextColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              onDismiss();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
              foregroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              side: BorderSide.none,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'DISMISS',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
