// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';
import 'colors.dart';
import 'customText.dart';

_fieldFocusChange(
  BuildContext context,
  FocusNode? nextFocus,
  FocusNode? currentFocus,
) {
  currentFocus!.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

Widget textFieldWidget(
    {required BuildContext context,
    Widget? prefixIcon,
    TextStyle? hintStyle,
    Widget? suffixIcon,
    bool showCursor = true,
    bool readOnly = false,
    bool onlyHint = false,
    required String hint,
    String? hinttext,
    Color? fillColor,
    List<String?>? holder,
    TextEditingController? controller,
    FocusNode? currentFocus,
    FocusNode? nextFocus,
    Color? borderColor,
    bool isEmail = false,
    bool isadress = false,
    bool enabled = true,
    bool validation = true,
    TextAlign? textAlign,
    double? fontsize,
    List<TextInputFormatter>? inputFormatters,
    Color? textColor,
    FontWeight? fontWeight,
    int? maxLines = 1,
    int minLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? fontFamily,
    EdgeInsetsGeometry? padding,
    int? maxLength,
    String? labelText,
    double? width,
    TextInputAction? textInputAction,
    void Function()? onTap,
    TextInputType? keyboardType,
    Widget? suffix,
    bool isMobile = false,
    void Function(String)? onChanged,
    InputBorder? enabledBorder,
    String? Function(String?)? validator
    // Function? onTap,
    }) {
  return TextFormField(
    // onTap: onTap!(),
    maxLines: maxLines ?? null,
    // maxLines: null,
    keyboardType: keyboardType,

    // minLines: minLines,
    textAlign: textAlign ?? TextAlign.start,
    readOnly: readOnly,
    showCursor: showCursor,
    controller: controller,
    enabled: enabled,
    textCapitalization: textCapitalization,
    // ignore: prefer_if_null_operators
    textInputAction: textInputAction != null
        ? textInputAction
        : nextFocus == null
            ? TextInputAction.done
            : TextInputAction.next,
    style: customTextstyle(
        color: textColor ?? tTextSecondaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w700),

    textAlignVertical: TextAlignVertical.center,
    validator: validator ??
        (String? value) {
          if (validation == true) {
            if (value!.isEmpty) {
              return '${AppLocalizations.of(context)!.enter} $hint';
            } else if (isEmail && !Constants().regex.hasMatch(value)) {
              return '${AppLocalizations.of(context)!.entervalid} $hint';
            } else {
              return null;
            }
          } else {
            return null;
          }
        },

    onChanged: onChanged,
    onSaved: (value) {},

    focusNode: currentFocus,
    onFieldSubmitted: (v) {
      _fieldFocusChange(context, nextFocus, currentFocus);
    },
    onTap: onTap,
    // keyboardType: keyboardType,
    maxLength: maxLength,

    decoration: InputDecoration(
      labelText: labelText,
      counterText: '',

      fillColor: fillColor ?? tPrimaryColor,
      filled: true,
      alignLabelWithHint: true,
      prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 15, left: 0, top: 15),
          child: prefixIcon),
      contentPadding: EdgeInsets.only(left: 10, right: 0, top: 8, bottom: 8),
      enabled: true,
      // prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
      labelStyle:
          customTextstyle(color: tLabelColor, fontWeight: FontWeight.w400),
      hintText: hinttext,
      hintStyle: hintStyle ??
          customTextstyle(
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontsize ?? 15,
            color: textColor ?? tTextSecondaryColor,
          ),
      suffix: suffix,
      suffixIcon: suffixIcon,
      enabledBorder: enabledBorder ??
          const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: tTextColor, width: 2)),
      border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      disabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      errorBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
    ),
  );
}

Widget NumbertextFieldWidget(
    {required BuildContext context,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required String hint,
    int? maxLength,
    TextStyle? hintStyle,
    String? hinttext,
    List<String?>? holder,
    TextEditingController? controller,
    InputBorder? enabledBorder,
    FocusNode? currentFocus,
    FocusNode? nextFocus,
    bool isPhoneNumber = false,
    int validationLength = 10,
    bool readOnly = false,
    bool enabled = true,
    Iterable<String>? autofillHints,
    TextAlignVertical? textAlignVertical,
    Color? borderColor,
    TextAlign? textAlign,
    Widget? child,
    void Function(String)? onChanged,
    bool validation = true,
    String? fontFamily,
    String? labelText,
    Color? textColor}) {
  return TextFormField(
    enabled: enabled,
    textAlign: textAlign ?? TextAlign.start,
    controller: controller,
    // maxLength: maxLength ?? 10,
    keyboardType: TextInputType.number,
    textInputAction:
        nextFocus == null ? TextInputAction.done : TextInputAction.next,
    style: customTextstyle(
        fontWeight: FontWeight.w600, color: tTextSecondaryColor),
    textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
    validator: validator ??
        (String? value) {
          if (validation == true) {
            if (value!.isEmpty) {
              return 'Enter $hint';
            } else if (isPhoneNumber == true &&
                value.length != validationLength) {
              return AppLocalizations.of(context)!.invalidnumber;
            } else {
              return null;
            }
          } else {
            return null;
          }
        },

    onSaved: (value) {
      holder![0] = value;
    },

    onChanged: onChanged,
    focusNode: currentFocus,
    onFieldSubmitted: (v) {
      _fieldFocusChange(context, nextFocus, currentFocus);
    },
    autofillHints: autofillHints,
    readOnly: readOnly,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
    ],
    maxLength: maxLength,
    decoration: InputDecoration(
      counterText: '',
      fillColor: tTransparrentColor,
      hintText: hinttext,
      isDense: true,
      alignLabelWithHint: true,
      prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 15, left: 0, top: 15),
          child: prefixIcon),
      contentPadding: EdgeInsets.only(left: 10, right: 0, top: 8, bottom: 8),
      enabled: true,
      labelText: labelText,
      labelStyle:
          customTextstyle(color: tLabelColor, fontWeight: FontWeight.w400),
      suffix: suffixIcon,
      filled: true,
      hintStyle: hintStyle ??
          customTextstyle(
              color: tTextSecondaryColor, fontWeight: FontWeight.w400),
      enabledBorder: enabledBorder ??
          const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: tTextColor, width: 2)),
      border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      disabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      errorBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tTextColor, width: 2)),
    ),
  );
}
