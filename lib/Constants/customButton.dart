// ignore_for_file: file_names

import 'package:anaj_bazar/Constants/colors.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:flutter/material.dart';

import 'customText.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      this.onTap,
      required this.text,
      this.alignment,
      this.width,
      this.height,
      this.textColor,
      this.border,
      this.buttonColor,
      this.child,
      this.fontSize,
      this.fontWeight,
      this.borderRadius})
      : super(key: key);
  final void Function()? onTap;
  final String text;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final Color? textColor;
  final BoxBorder? border;
  final Color? buttonColor;
  final Widget? child;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: alignment ?? Alignment.center,
          width: width ?? double.maxFinite,
          height: height ?? customHeight(context: context, height: .057),
          decoration: BoxDecoration(
              border: border,
              color: buttonColor ?? tButtonColor,
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(10))),
          child: child ??
              CustomText(
                  text: text,
                  color: textColor ?? tPrimaryColor,
                  fontSize: fontSize ?? 20,
                  fontWeight: fontWeight ?? FontWeight.w600)),
    );
  }
}
