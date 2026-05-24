import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showRollbackErrorBottomSheet(
  BuildContext context, {
  required String errorMessage,
  required VoidCallback onDismiss,
}) {
  // Haptic feedback for error
  HapticFeedback.vibrate();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        top: 32,
        left: 24,
        right: 24,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Color(0xFFDC2626),
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Oops!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your cart has been restored to its previous state.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDismiss();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
            ),
            child: const Text(
              'Dismiss',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
