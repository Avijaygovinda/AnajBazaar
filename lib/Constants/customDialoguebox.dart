import 'package:anaj_bazar/Constants/colors.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:flutter/material.dart';

Future dialogueBox(
    {required BuildContext context,
    Widget? title,
    List<Widget>? actions,
    double? height,
    bool? barrierDismissible}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: tTransparrentColor,
        child: CustomPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
              width: double.infinity,
              height: height ?? customHeight(context: context, height: .2),
              child: title,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tPrimaryColor)),
        ),
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
      );
    },
  );
}
