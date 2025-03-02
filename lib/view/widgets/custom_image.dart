import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final String placeholder;
  final double width;
  final double height;
  final BoxFit fit;

  const CustomImage({
    Key? key,
    required this.imageUrl,
    this.placeholder = "assets/placeholder.png", // Local placeholder image
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          placeholder,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
