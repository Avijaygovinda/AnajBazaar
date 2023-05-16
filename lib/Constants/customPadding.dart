// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class CustomPadding extends StatelessWidget {
  const CustomPadding({Key? key, required this.padding, this.child})
      : super(key: key);
  final EdgeInsetsGeometry padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
