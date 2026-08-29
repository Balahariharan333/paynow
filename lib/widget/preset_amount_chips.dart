import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';

class PresetAmountChips extends StatelessWidget {
  final List<String> amounts;
  final String selectedAmount;
  final ValueChanged<String> onSelected;

  const PresetAmountChips({
    super.key,
    required this.amounts,
    required this.selectedAmount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Responsive.w(12.0),
      runSpacing: Responsive.h(12.0),
      children: amounts.map((amount) {
        final isSelected = amount == selectedAmount;

        return GestureDetector(
          onTap: () => onSelected(amount),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(24),
              vertical: Responsive.h(12),
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : const Color(0xFFEEF2F6),
              borderRadius: BorderRadius.circular(Responsive.w(16)),
            ),
            child: Text(
              amount,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.w(15),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

