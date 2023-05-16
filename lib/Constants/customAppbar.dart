// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'colors.dart';
import 'customText.dart';

AppBar appBar(
    {double? height,
    double? width,
    required String text,
    void Function()? onTap,
    double? leadingWidth,
    Color? fontcolor,
    double? toolbarHeight,
    List<Widget>? actions,
    Color? backbuttoncolor,
    Color? color,
    PreferredSizeWidget? bottom,
    Widget? leading,
    required BuildContext context}) {
  return AppBar(
    backgroundColor: color ?? tPrimaryColor,
    elevation: 0,
    leadingWidth: leadingWidth,
    toolbarHeight: toolbarHeight,
    centerTitle: true,
    titleSpacing: 0,
    actions: actions,
    leading: leading ??
        GestureDetector(
          onTap: onTap ??
              () {
                Navigator.pop(context);
              },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: backbuttoncolor ?? tTextColor,
          ),
        ),
    bottom: bottom,
    title: CustomText(
        text: text,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: tTextSecondaryColor),
  );
}
