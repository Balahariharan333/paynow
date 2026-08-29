import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class SecureTransactionBanner extends StatelessWidget {
  const SecureTransactionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E3B9E), // Deep security blue
            Color(0xFF6B21A8), // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.title(
                  'Secure Transaction',
                  color: AppColors.white,
                  fontSize: 14,
                ),
                const SizedBox(height: 4),
                CustomText.body(
                  'Your payment is encrypted with bank-level security. Fund transfers usually take 2-5 seconds.',
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
