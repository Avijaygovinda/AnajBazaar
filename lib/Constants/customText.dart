// ignore_for_file: file_names, must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {Key? key,
      required this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.decorationColor,
      this.shadows,
      this.decoration,
      this.extrafontStyle,
      this.textAlign,
      this.overflow,
      this.maxLines})
      : super(key: key);
  final String text;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  TextDecoration? decoration;
  final TextAlign? textAlign;
  List<Shadow>? shadows;
  final TextOverflow? overflow;
  Color? decorationColor;
  TextStyle? extrafontStyle;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: GoogleFonts.montserrat(
            decoration: decoration,
            shadows: shadows,
            decorationThickness: 1,
            color: color ?? tTextColor,
            decorationColor: decorationColor,
            textStyle: extrafontStyle,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.w500));
  }
}

TextStyle customTextstyle(
    {Color? color,
    TextDecoration? decoration,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily}) {
  return GoogleFonts.montserrat(
    color: color ?? tTextSecondaryColor,
    fontSize: fontSize ?? 15,
    fontWeight: fontWeight,
  );
}
