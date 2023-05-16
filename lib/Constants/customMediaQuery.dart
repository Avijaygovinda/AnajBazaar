import 'package:flutter/cupertino.dart';

Size size({required BuildContext context}) {
  return MediaQuery.of(context).size;
}

double customHeight({required BuildContext context, required double height}) {
  return size(context: context).height * height;
}

double customWidth({required BuildContext context, required double width}) {
  return size(context: context).width * width;
}
