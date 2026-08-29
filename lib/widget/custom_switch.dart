import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeTrackColor;
  final Color activeThumbColor;
  final Color inactiveTrackColor;
  final Color inactiveThumbColor;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor = AppColors.lightBlue, // Our branding light blue track
    this.activeThumbColor = AppColors.primary, // Our branding blue thumb
    this.inactiveTrackColor = const Color(0xFFC2C2C2), // Gray track
    this.inactiveThumbColor = const Color(0xFFFFFFFF), // White thumb
  });

  @override
  Widget build(BuildContext context) {
    final double totalWidth = Responsive.w(40.0);
    final double totalHeight = Responsive.h(24.0);
    final double trackWidth = Responsive.w(34.0);
    final double trackHeight = Responsive.h(14.0);
    final double thumbDiameter = Responsive.w(20.0);

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Track background
            Center(
              child: Container(
                width: trackWidth,
                height: trackHeight,
                decoration: BoxDecoration(
                  color: onChanged == null
                      ? const Color(0xFFE5E5E5) // Disabled track
                      : (value ? activeTrackColor : inactiveTrackColor),
                  borderRadius: BorderRadius.circular(trackHeight / 2),
                ),
              ),
            ),
            // Thumb button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              left: value ? (totalWidth - thumbDiameter) : 0,
              top: (totalHeight - thumbDiameter) / 2,
              child: Container(
                width: thumbDiameter,
                height: thumbDiameter,
                decoration: BoxDecoration(
                  color: onChanged == null
                      ? const Color(0xFFB3B3B3) // Disabled thumb
                      : (value ? activeThumbColor : inactiveThumbColor),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
