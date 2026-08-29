import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class PaymentBubble extends StatelessWidget {
  final String amount;
  final String date;
  final bool isSent;
  final bool isSuccess;
  final String transactionId;

  const PaymentBubble({
    super.key,
    required this.amount,
    required this.date,
    required this.isSent,
    required this.isSuccess,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isSent ? AppColors.primary : Theme.of(context).cardColor;
    final textColor = isSent ? AppColors.white : Theme.of(context).colorScheme.onSurface;
    final subtitleColor = isSent ? AppColors.white.withValues(alpha: 0.8) : AppColors.grayFont;
    final alignment = isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isSent ? const EdgeInsets.only(left: 64, right: 16, top: 8, bottom: 8) : const EdgeInsets.only(left: 16, right: 64, top: 8, bottom: 8);

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isSent ? const Radius.circular(20) : Radius.zero,
          bottomRight: isSent ? Radius.zero : const Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Amount text
          CustomText.header(
            amount,
            color: textColor,
            fontSize: 20,
          ),
          const SizedBox(height: 4),
          
          // Transaction Type/Status
          CustomText.subtitle(
            isSent ? (isSuccess ? 'Payment Sent' : 'Payment Failed') : 'Payment Received',
            color: subtitleColor,
          ),
          const SizedBox(height: 12),
          
          // Divider
          Divider(color: isSent ? Colors.white24 : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 8),
          
          // TxID & Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomText.body(
                  'ID: $transactionId',
                  color: subtitleColor,
                  fontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              CustomText.body(
                date,
                color: subtitleColor,
                fontSize: 10,
              ),
            ],
          ),
          
          // Status Badge if Failed
          if (!isSuccess) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.errorRed,
                  size: 12,
                ),
                const SizedBox(width: 4),
                CustomText.body(
                  'Declined',
                  color: AppColors.errorRed,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
