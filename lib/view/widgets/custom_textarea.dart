import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final Color borderColor;
  final Color fillColor;
  final double borderRadius;

  const CustomTextArea({
    super.key,
    required this.controller,
    this.hintText = "Enter your text...",
    this.maxLines = 5,
    this.borderColor = COLOR_PRIMARY,
    this.fillColor = Colors.white,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
      ),
    );
  }
}
