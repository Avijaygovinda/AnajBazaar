import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customImage.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customSizedBox.dart';
import '../../Constants/customText.dart';
import '../../Constants/customTextfield.dart';
import '../../Constants/images.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FocusNode _firstFocus = FocusNode();
  List<String?> first = List.filled(1, '');
  TextEditingController firstController = TextEditingController();
  final FocusNode _lastFocus = FocusNode();
  List<String?> last = List.filled(1, '');
  TextEditingController lastController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  List<String?> email = List.filled(1, '');
  TextEditingController emailController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();
  List<String?> number = List.filled(1, '');
  TextEditingController numberController = TextEditingController();
  final FocusNode _tradeFocus = FocusNode();
  List<String?> tradelist = List.filled(1, '');
  TextEditingController tradeController = TextEditingController();
  final FocusNode _gstFocus = FocusNode();
  List<String?> gst = List.filled(1, '');
  TextEditingController gstController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    profileController = Provider.of<ProfileController>(context, listen: false);
    profileController.getUserDetails();
    updateUserDetails();
  }

  var dropddowntypeValue2;

  ProfileController profileController = ProfileController();

  updateUserDetails() {
    firstController.text =
        profileController.userDetailsModel?.user.firstName ?? '';
    lastController.text =
        profileController.userDetailsModel?.user.lastName ?? '';
    emailController.text =
        profileController.userDetailsModel?.user.emailId ?? '';
    tradeController.text =
        profileController.userDetailsModel?.user.tradeName ?? '';
    gstController.text = profileController.userDetailsModel?.user.gstNo ?? '';
  }

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
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
              text: AppLocalizations.of(context)!.editprofile,
              context: context),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: editUserInfo(),
          ),
        ),
      ),
    );
  }

  Widget editUserInfo() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Color(0XFFF5921E).withOpacity(.4),
              child: CustomText(
                text: profileController.userDetailsModel?.user.firstName[0]
                        .toString() ??
                    '',
                fontSize: 30,
                color: tTabSelectedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          textFields(),
          CustomSizedBox(
            height: customHeight(context: context, height: .1),
          ),
          Row(
            children: [
              Flexible(
                child: CustomButton(
                  text: AppLocalizations.of(context)!.cancel,
                  fontSize: 17,
                  onTap: () {
                    Routes().backroute(context: context);
                  },
                  textColor: tTextSecondaryColor,
                  buttonColor: tTransparrentColor,
                  border: Border.all(color: tTextSecondaryColor, width: 1.2),
                ),
              ),
              CustomSizedBox(
                width: customWidth(context: context, width: .04),
              ),
              Flexible(
                  child: CustomButton(
                text: AppLocalizations.of(context)!.save,
                fontSize: 17,
                onTap: () async {
                  if (validateAndSave()) {
                    var fcmToken =
                        await FirebaseMessaging.instance.getToken() ?? '';
                    var firstName = firstController.text;
                    var lastName = lastController.text;
                    var emailId = emailController.text;
                    var tradeName = tradeController.text;
                    var gstName = gstController.text;

                    var userId =
                        profileController.userDetailsModel?.user.userId ?? 0;
                    Provider.of<ProfileController>(context, listen: false)
                        .updateUserDetails(firstName, lastName, emailId,
                            gstName, tradeName, fcmToken, userId, context);
                  }
                },
              )),
            ],
          )
        ],
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
              // height: 30,
              // width: 20,
              // fit: BoxFit.contain,
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
              // height: 30,
              // width: 20,
              // fit: BoxFit.contain,
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .015),
          ),
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.email,
            hinttext: '',
            controller: emailController,
            currentFocus: _emailFocus,
            nextFocus: _numberFocus,
            holder: email,
            isEmail: true,
            labelText: AppLocalizations.of(context)!.email,
            prefixIcon: CustomImage(
              image: massage,
              // height: 30,
              // width: 20,
              // fit: BoxFit.contain,
            ),
          ),
          // CustomSizedBox(
          //   height: customHeight(context: context, height: .015),
          // ),
          // NumbertextFieldWidget(
          //   context: context,
          //   hint: 'Mobile Number',
          //   hinttext: '',
          //   isPhoneNumber: true,
          //   validationLength: 10,
          //   maxLength: 10,
          //   controller: numberController,
          //   currentFocus: _numberFocus,
          //   nextFocus: _tradeFocus,
          //   holder: number,
          //   labelText: 'Mobile Number',
          //   prefixIcon: CustomImage(
          //     image: call,
          //     height: 10,
          //     width: 10,
          //   ),
          // ),
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
              // height: 30,
              // width: 20,
              // fit: BoxFit.contain,
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
            maxLength:15,
            currentFocus: _gstFocus,
            nextFocus: null,
            textCapitalization: TextCapitalization.characters,
            holder: gst,
            labelText: AppLocalizations.of(context)!.gstnumber,
            prefixIcon: CustomImage(
              image: call,
              // height: 30,
              // width: 20,
              // fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
