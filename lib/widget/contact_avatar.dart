import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/utils/responsive_helper.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const ContactAvatar({
    super.key,
    required this.name,
    this.radius = 24.0,
    this.backgroundColor = const Color(0xFFEEF2F6),
    this.textColor = AppColors.primary,
  });

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final responsiveRadius = Responsive.w(radius);
    final size = responsiveRadius * 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomText.title(
          initials,
          color: textColor,
          fontSize: responsiveRadius * 0.75,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

