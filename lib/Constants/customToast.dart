// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> toast(
    {required String text, EasyLoadingToastPosition? toastPosition}) {
  return EasyLoading.showToast(
    text,
    toastPosition: toastPosition ?? EasyLoadingToastPosition.bottom,
    maskType: EasyLoadingMaskType.clear,
  );
}

Future<void> errToast(
    {required String text, EasyLoadingToastPosition? toastPosition}) {
  return EasyLoading.showError(
    text,
    dismissOnTap: true,
    maskType: EasyLoadingMaskType.clear,
  );
}

Future<void> easyLoading({String? text, required BuildContext context}) {
  return EasyLoading.show(status: AppLocalizations.of(context)!.loading);
}

Future<void> dismissLoading() {
  return EasyLoading.dismiss();
}
