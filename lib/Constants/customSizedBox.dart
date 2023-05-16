import 'package:flutter/cupertino.dart';

class CustomSizedBox extends StatelessWidget {
  const CustomSizedBox({Key? key, this.height, this.width, this.child})
      : super(key: key);
  final double? height;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}
