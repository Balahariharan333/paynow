import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class OfferCardTile extends StatelessWidget {
  final String brandName;
  final String description;
  final String validityText;
  final String badgeText;

  const OfferCardTile({
    super.key,
    required this.brandName,
    required this.description,
    required this.validityText,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isLimited = badgeText == 'LIMITED';
    final badgeBgColor = isLimited ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5);
    final badgeTextColor = isLimited ? AppColors.primary : const Color(0xFF047857);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Grey Icon/Thumbnail Placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_offer,
              color: AppColors.grayFont,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // Brand details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText.title(brandName, fontSize: 14),
                    
                    // Top-right Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeTextColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText.body(
                  description,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 4),
                CustomText.subtitle(
                  validityText,
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
