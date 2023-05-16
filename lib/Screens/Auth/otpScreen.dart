import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/authControllers.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customButton.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final bool isLogin;
  const OTPScreen(
      {super.key, required this.mobileNumber, required this.isLogin});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isTapped = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authControllers = Provider.of<AuthControllers>(context, listen: false);
      authControllers.setTimer();
    });
  }

  AuthControllers authControllers = AuthControllers();

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authControllers.disposeTimer();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: otpArea(),
          ),
        ),
      ),
    );
  }

  Widget otpArea() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CustomText(
              text: AppLocalizations.of(context)!.verificationcode,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          CustomImage(
            image: password,
            alignment: Alignment.center,
            height: customHeight(
              context: context,
              height: .2,
            ),
            width: double.infinity,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .05),
          ),
          otpContainer(),
          button()
        ],
      ),
    );
  }

  Widget button() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomButton(
            text: AppLocalizations.of(context)!.verifyotp,
            onTap: () async {
              if (isTapped) {
                isTapped = false;
                var mobileNumber = widget.mobileNumber;
                var otp = numberController.text;
                var islogin = widget.isLogin;
                try {
                  await Provider.of<AuthControllers>(context, listen: false)
                      .signupverifyOtp(mobileNumber, otp, islogin, context);
                  isTapped = true;
                } catch (e) {
                  isTapped = true;
                }
              }
            },
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .02),
          ),
          Consumer<AuthControllers>(
            builder: (context, value, child) => GestureDetector(
              onTap: () {
                if (value.resendotp == false) {
                  var islogin = widget.isLogin;
                  var mobileNumber = widget.mobileNumber;
                  numberController.clear();
                  value.signupsendOtp(mobileNumber, true, islogin, context);
                  value.setTimer();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: value.resendotp
                        ? AppLocalizations.of(context)!.resendin
                        : AppLocalizations.of(context)!.resend,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  CustomText(
                    text: !value.resendotp ? '' : ' ${value.time()}S',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: tButtonColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget otpContainer() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          CustomText(
            text: AppLocalizations.of(context)!.enterverificationcode,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .01),
          ),
          CustomText(
            text: widget.mobileNumber,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: PinCodeTextField(
              onChanged: (value) {},
              appContext: context,
              length: 4,
              obscureText: false,
              textStyle:
                  customTextstyle(fontSize: 20, fontWeight: FontWeight.w500),
              pinTheme: PinTheme(
                  borderWidth: 1.4,
                  disabledColor: tPrimaryColor,
                  inactiveFillColor: tPrimaryColor,
                  selectedColor: tTextSecondaryColor,
                  selectedFillColor: tPrimaryColor,
                  shape: PinCodeFieldShape.box,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  fieldHeight: 40,
                  fieldWidth: 45,
                  activeFillColor: tOTPboxesColor,
                  activeColor: tTextSecondaryColor,
                  inactiveColor: tTextSecondaryColor),
              keyboardType: TextInputType.number,
              enablePinAutofill: true,
              backgroundColor: tPrimaryColor,
              animationType: AnimationType.none,
              enableActiveFill: true,
              controller: numberController,
              onCompleted: (v) {},
              beforeTextPaste: (text) {
                return true;
              },
            ),
          ),
        ],
      ),
    );
  }
}
