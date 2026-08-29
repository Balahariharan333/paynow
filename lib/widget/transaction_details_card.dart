import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class TransactionDetailsCard extends StatelessWidget {
  final String transferFee;
  final String estimatedArrival;
  final String totalDeduction;

  const TransactionDetailsCard({
    super.key,
    required this.transferFee,
    required this.estimatedArrival,
    required this.totalDeduction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.body(
            'TRANSACTION DETAILS',
            color: AppColors.grayFont,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.body('Transfer Fee', color: AppColors.grayFont, fontSize: 13),
              CustomText.body(
                transferFee,
                color: AppColors.successGreen,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.body('Estimated Arrival', color: AppColors.grayFont, fontSize: 13),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bolt,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  CustomText.body(
                    estimatedArrival,
                    color: AppColors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.title('Total Deduction', fontSize: 14),
              CustomText.title(
                totalDeduction,
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
