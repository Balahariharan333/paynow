import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const SearchTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.fillColor,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? (isDark ? Theme.of(context).cardColor : const Color(0xFFE5EAF5)),
        border: borderColor != null ? Border.all(color: borderColor!, width: Responsive.w(1.5)) : null,
        borderRadius: BorderRadius.circular(Responsive.w(16.0)),
        boxShadow: boxShadow,
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: Responsive.w(15),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.grayFont,
            fontSize: Responsive.w(14),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.grayFont,
            size: Responsive.w(24),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: Responsive.w(16.0),
            vertical: Responsive.h(14.0),
          ),
        ),
      ),
    );
  }
}

