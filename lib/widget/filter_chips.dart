import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';

class FilterChips extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;

  const FilterChips({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.h(40),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => SizedBox(width: Responsive.w(12)),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;

          return GestureDetector(
            onTap: () => onSelected(option),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(24),
                vertical: Responsive.h(8),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Responsive.w(20)),
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                  width: Responsive.w(1.5),
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.grayFont,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: Responsive.w(14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

