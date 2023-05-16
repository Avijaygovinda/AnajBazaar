import 'package:flutter/material.dart';

class Routes {
  backroute({required BuildContext context, dynamic value}) {
    Navigator.pop(context, value);
  }

  pushroute({required BuildContext context, required Widget pages}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => pages,
        ));
  }

  pushroutewithremove({required BuildContext context, required Widget pages}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => pages,
        ),
        (route) => false);
  }
}
