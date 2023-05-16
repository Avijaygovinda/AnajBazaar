import 'package:anaj_bazar/Constants/colors.dart';
import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/customTextfield.dart';
import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/authControllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.isLogin});
  final bool isLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _numberFocus = FocusNode();
  List<String?> number = List.filled(1, '');
  TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();

      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLogin;
  }

  bool isLogin = false;

  bool isTapped = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: CustomTap(
              onTap: () {
                dismissLoading();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [loginArea()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImage(
          alignment: Alignment.topCenter,
          image: login,
          height: customHeight(
            context: context,
            height: .4,
          ),
          width: customWidth(context: context, width: 1),
          fit: BoxFit.cover,
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .06),
        ),
        loginsTextArea()
      ],
    );
  }

  Widget loginsTextArea() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomText(
            text: AppLocalizations.of(context)!.enternumber,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            color: tTextSecondaryColor,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .025),
          ),
          CustomText(
            text: AppLocalizations.of(context)!.wewillsendyoucode,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            // color: tTextSecondaryColor,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .02),
          ),
          CustomPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                NumbertextFieldWidget(
                  context: context,
                  hint: AppLocalizations.of(context)!.mobilenumber,
                  hinttext: '',
                  controller: numberController,
                  currentFocus: _numberFocus,
                  isPhoneNumber: true,
                  maxLength: 10,
                  validationLength: 10,
                  nextFocus: null,
                  holder: number,
                  onChanged: (p0) {
                    if (numberController.text.length <= 1) {
                      if (p0 == '0' ||
                          p0 == '1' ||
                          p0 == '2' ||
                          p0 == '3' ||
                          p0 == '4' ||
                          p0 == '5') {
                        numberController.clear();
                        toast(
                            text:
                                "${AppLocalizations.of(context)!.numbercantstartwith} ${p0.toString()}",
                            toastPosition: EasyLoadingToastPosition.center);
                      }
                    }
                  },
                  labelText: AppLocalizations.of(context)!.mobilenumber,
                  prefixIcon: CustomImage(
                    image: mobile,
                    height: 10,
                    width: 10,
                  ),
                ),
                CustomSizedBox(
                  height: customHeight(context: context, height: .05),
                ),
                CustomButton(
                  text: AppLocalizations.of(context)!.getotp,
                  onTap: () async {
                    if (isTapped) {
                      isTapped = false;
                      if (validateAndSave()) {
                        var number = numberController.text;
                        var isLogin = widget.isLogin;
                        await Provider.of<AuthControllers>(context,
                                listen: false)
                            .signupsendOtp(number, false, isLogin, context);
                      }
                      isTapped = true;
                    }
                  },
                ),
                CustomSizedBox(
                  height: customHeight(context: context, height: .02),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      text: !isLogin
                          ? AppLocalizations.of(context)!.alreadyhaveaccount
                          : AppLocalizations.of(context)!.donthaveaccount,
                      fontWeight: FontWeight.w600,
                      color: tTextSecondaryColor,
                    ),
                    CustomTap(
                      onTap: () {
                        isLogin = !isLogin;
                        Routes().pushroute(
                            context: context,
                            pages: LoginScreen(
                              isLogin: isLogin,
                            ));
                      },
                      child: CustomText(
                        text: !isLogin
                            ? AppLocalizations.of(context)!.login
                            : AppLocalizations.of(context)!.signup,
                        fontWeight: FontWeight.w700,
                        color: tTabColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
