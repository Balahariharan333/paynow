import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class HistoryTransactionItem extends StatelessWidget {
  final String title;
  final String time;
  final String type;
  final String amount;
  final String status;
  final bool isPositive;
  final bool isSuccess;
  final IconData? icon;
  final Color iconBackground;
  final Color iconColor;
  final String? avatarUrl;
  final String? initialText;

  const HistoryTransactionItem({
    super.key,
    required this.title,
    required this.time,
    required this.type,
    required this.amount,
    required this.status,
    required this.isPositive,
    required this.isSuccess,
    this.icon,
    this.iconBackground = AppColors.lightGray,
    this.iconColor = AppColors.black,
    this.avatarUrl,
    this.initialText,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor == AppColors.black
        ? Theme.of(context).colorScheme.onSurface
        : iconColor;
    final resolvedIconBg = iconBackground == AppColors.lightGray
        ? Theme.of(context).scaffoldBackgroundColor
        : iconBackground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Icon or Avatar Circle
          _buildAvatar(context, resolvedIconColor, resolvedIconBg),
          const SizedBox(width: 12),
          
          // Title and Subtitle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.title(title),
                const SizedBox(height: 4),
                CustomText.subtitle('$time • $type'),
              ],
            ),
          ),
          
          // Amount and Status Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.amount(amount, isPositive: isPositive),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isSuccess) ...[
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.errorRed,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                  ],
                  CustomText.status(status, isSuccess: isSuccess),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, Color resolvedIconColor, Color resolvedIconBg) {
    if (avatarUrl != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    if (initialText != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: resolvedIconBg,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomText.title(
            initialText!,
            color: resolvedIconColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: resolvedIconBg,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.payment,
        color: resolvedIconColor,
        size: 22,
      ),
    );
  }
}
