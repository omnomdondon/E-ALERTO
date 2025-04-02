import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final double fontSize;
  final double? height;
  final bool fullWidth;
  final Widget? child; // New property for custom child widget

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = COLOR_PRIMARY,
    this.textColor = Colors.white,
    this.borderRadius = 12.0,
    this.padding = 16.0,
    this.fontSize = 16.0,
    this.height,
    this.fullWidth = false,
    this.child, // Added child parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding:
              EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
        ),
        onPressed: onPressed,
        child: child ??
            Text(
              // Use child if provided, otherwise use text
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
      ),
    );
  }
}