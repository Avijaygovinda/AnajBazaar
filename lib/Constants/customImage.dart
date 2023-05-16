// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
      {Key? key,
      this.borderRadius,
      required this.image,
      this.height,
      this.width,
      this.fit,
      this.alignment,
      this.color})
      : super(key: key);
  final BorderRadius? borderRadius;
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        image,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment ?? Alignment.center,
        color: color,
      ),
    );
  }
}
