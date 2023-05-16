import 'package:anaj_bazar/Constants/customAppbar.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Controllers/authControllers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../../Constants/customButton.dart';
import '../../Constants/customImage.dart';
import '../../Constants/customText.dart';
import '../../Constants/customTextfield.dart';
import '../../Constants/customToast.dart';
import '../../Constants/images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, required this.mobileNumber});
  final String mobileNumber;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstFocus = FocusNode();
  List<String?> first = List.filled(1, '');
  TextEditingController firstController = TextEditingController();
  final FocusNode _lastFocus = FocusNode();
  List<String?> last = List.filled(1, '');
  TextEditingController lastController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  List<String?> email = List.filled(1, '');
  TextEditingController emailController = TextEditingController();
  final FocusNode _tradeFocus = FocusNode();
  List<String?> tradelist = List.filled(1, '');
  TextEditingController tradeController = TextEditingController();
  final FocusNode _gstFocus = FocusNode();
  List<String?> gst = List.filled(1, '');
  TextEditingController gstController = TextEditingController();
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

  bool isTapped = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(text: '', context: context),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: createAccountContainer(),
          ),
        ),
      ),
    );
  }

  Widget createAccountContainer() {
    return CustomTap(
      onTap: () {
        dismissLoading();
      },
      child: CustomPadding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: AppLocalizations.of(context)!.createacount,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            CustomPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CustomText(
                text: AppLocalizations.of(context)!.pleaseenterbelowdetails,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            textFields(),
            CustomSizedBox(
              height: customHeight(context: context, height: .05),
            ),
            CustomButton(
              text: AppLocalizations.of(context)!.signupbtn,
              onTap: () async {
                if (isTapped) {
                  isTapped = false;
                  if (validateAndSave()) {
                    var fcmToken =
                        await FirebaseMessaging.instance.getToken() ?? '';
                    var mobileNumber = widget.mobileNumber;
                    var firstName = firstController.text;
                    var lastName = lastController.text;
                    var GSTNo = gstController.text;
                    var emailId = emailController.text;
                    var profilePic;
                    var tradeName = tradeController.text;
                    Provider.of<AuthControllers>(context, listen: false)
                        .createAccount(
                            mobileNumber: mobileNumber,
                            firstName: firstName,
                            lastName: lastName,
                            GSTNo: GSTNo,
                            context: context,
                            emailId: emailId,
                            fcmToken: fcmToken,
                            profilePic: profilePic,
                            tradeName: tradeName);
                  }
                  isTapped = true;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  textFields() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.firstname,
            hinttext: '',
            controller: firstController,
            currentFocus: _firstFocus,
            nextFocus: _lastFocus,
            textCapitalization: TextCapitalization.words,
            holder: first,
            labelText: AppLocalizations.of(context)!.firstname,
            prefixIcon: CustomImage(
              image: profile,
              height: 10,
              width: 10,
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .015),
          ),
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.lastname,
            hinttext: '',
            controller: lastController,
            currentFocus: _lastFocus,
            nextFocus: _emailFocus,
            textCapitalization: TextCapitalization.words,
            holder: last,
            labelText: AppLocalizations.of(context)!.lastname,
            prefixIcon: CustomImage(
              image: profile,
              height: 10,
              width: 10,
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .015),
          ),
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.emailoptional,
            hinttext: '',
            controller: emailController,
            currentFocus: _emailFocus,
            validation: false,
            nextFocus: _tradeFocus,
            holder: email,
            isEmail: true,
            labelText: AppLocalizations.of(context)!.emailoptional,
            prefixIcon: CustomImage(
              image: massage,
              height: 10,
              width: 10,
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .015),
          ),
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.tradename,
            validation: false,
            hinttext: '',
            controller: tradeController,
            textCapitalization: TextCapitalization.words,
            currentFocus: _tradeFocus,
            nextFocus: _gstFocus,
            holder: tradelist,
            labelText: AppLocalizations.of(context)!.tradename,
            prefixIcon: CustomImage(
              image: trade,
              height: 10,
              width: 10,
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .015),
          ),
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.gstnumber,
            hinttext: '',
            controller: gstController,
            validation: false,
            currentFocus: _gstFocus,
            nextFocus: null,
            textCapitalization: TextCapitalization.characters,
            holder: gst,
            labelText: AppLocalizations.of(context)!.gstnumber,
            prefixIcon: CustomImage(
              image: call,
              height: 10,
              width: 10,
            ),
          ),
        ],
      ),
    );
  }
}
