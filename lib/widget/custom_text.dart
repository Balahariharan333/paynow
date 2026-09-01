import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomText._({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  /// Left-aligned main section headers (e.g. "History", "Today", "Yesterday")
  factory CustomText.header(
    String text, {
    Key? key,
    Color color = AppColors.black,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.bold,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText._(
      key: key,
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  /// Title styles (e.g., name/shop title inside list items)
  factory CustomText.title(
    String text, {
    Key? key,
    Color color = AppColors.black,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w600,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText._(
      key: key,
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  /// Subtitle styles (e.g., "10:42 AM • Sent")
  factory CustomText.subtitle(
    String text, {
    Key? key,
    Color color = AppColors.grayFont,
    double fontSize = 12,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText._(
      key: key,
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Body text styles
  factory CustomText.body(
    String text, {
    Key? key,
    Color color = AppColors.black,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText._(
      key: key,
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  /// Amount styles (formatted based on transaction type)
  factory CustomText.amount(
    String text, {
    Key? key,
    required bool isPositive,
    double fontSize = 16,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText._(
      key: key,
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: isPositive ? AppColors.successGreen : AppColors.errorRed,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Status labels (e.g. "Success", "Declined")
  factory CustomText.status(
    String text, {
    Key? key,
    required bool isSuccess,
    double fontSize = 11,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText._(
      key: key,
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: isSuccess ? AppColors.successGreen : AppColors.errorRed,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double? fontSize = style.fontSize;
    
    // Resolve text color dynamically based on theme if the default colors are used
    Color? finalColor = style.color;
    if (style.color == AppColors.black) {
      finalColor = Theme.of(context).colorScheme.onSurface;
    } else if (style.color == AppColors.grayFont) {
      finalColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    final TextStyle finalStyle = style.copyWith(
      fontSize: fontSize != null ? Responsive.w(fontSize) : null,
      color: finalColor,
    );

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
