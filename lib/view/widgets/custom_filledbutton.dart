import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_filledbutton.dart';

import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final double fontSize;
  final double? height; // Allow custom height
  final bool fullWidth; // New property to make the button full width

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
    this.fullWidth = false, // Default is false (normal size)
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null, // Fills horizontally if true
      height: height, // Uses custom height if provided
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
        ),
        onPressed: onPressed,
        child: Text(
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
