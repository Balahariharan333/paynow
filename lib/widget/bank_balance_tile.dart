import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

import 'package:paynow/widget/upi_pin_sheet.dart';

class BankBalanceTile extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final IconData icon;
  final String mockBalance;

  const BankBalanceTile({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.icon,
    required this.mockBalance,
  });

  @override
  State<BankBalanceTile> createState() => _BankBalanceTileState();
}

class _BankBalanceTileState extends State<BankBalanceTile> {
  bool _isBalanceRevealed = false;

  void _checkBalance() async {
    final success = await showUpiPinSheet(
      context: context,
      bankName: widget.bankName,
      accountNumber: widget.accountNumber,
      balance: widget.mockBalance,
      icon: widget.icon,
    );

    if (success == true && mounted) {
      setState(() {
        _isBalanceRevealed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          // Bank avatar circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          
          // Bank Name & Acc Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.title(widget.bankName, fontSize: 14),
                const SizedBox(height: 2),
                CustomText.subtitle(widget.accountNumber, fontSize: 12),
              ],
            ),
          ),
          
          // Interactive Action Button / Balance display
          _buildBalanceAction(),
        ],
      ),
    );
  }

  Widget _buildBalanceAction() {
    if (_isBalanceRevealed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.title(
            widget.mockBalance,
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              setState(() {
                _isBalanceRevealed = false;
              });
            },
            child: const Icon(
              Icons.visibility_off_outlined,
              size: 16,
              color: AppColors.grayFont,
            ),
          ),
        ],
      );
    }

    return TextButton(
      onPressed: _checkBalance,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: CustomText.title(
        'Check Balance',
        color: AppColors.primary,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
