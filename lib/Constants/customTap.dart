import 'package:flutter/cupertino.dart';

CustomTap(
    {required Widget child,
    required void Function() onTap,
    HitTestBehavior? behavior}) {
  return GestureDetector(
    behavior: behavior ?? HitTestBehavior.opaque,
    child: child,
    onTap: onTap,
  );
}
