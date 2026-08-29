import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class WalletSummaryCard extends StatefulWidget {
  final String balance;
  final VoidCallback onAddMoney;
  final VoidCallback onWithdraw;

  const WalletSummaryCard({
    super.key,
    required this.balance,
    required this.onAddMoney,
    required this.onWithdraw,
  });

  @override
  State<WalletSummaryCard> createState() => _WalletSummaryCardState();
}

class _WalletSummaryCardState extends State<WalletSummaryCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    final displayedBalance = _isHidden ? '••••••••' : widget.balance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradientEnd.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.body(
                'Available Wallet Balance',
                color: AppColors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText.header(
            displayedBalance,
            color: AppColors.white,
            fontSize: 32,
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onAddMoney,
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.white, size: 20),
                  label: CustomText.title('Add Money', color: AppColors.white, fontSize: 14),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.white.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onWithdraw,
                  icon: const Icon(Icons.outbox_outlined, color: AppColors.white, size: 20),
                  label: CustomText.title('Withdraw', color: AppColors.white, fontSize: 14),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.white.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
