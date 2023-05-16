import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:anaj_bazar/Screens/Auth/loginScreen.dart';
import 'package:anaj_bazar/Screens/Home/webviewWidget.dart';
import 'package:anaj_bazar/Screens/Intro/languageSelection.dart';
import 'package:anaj_bazar/Screens/Location/myAdresses.dart';
import 'package:anaj_bazar/Screens/Orders/myOrders.dart';
import 'package:anaj_bazar/Screens/Profile/editprofile.dart';
import 'package:anaj_bazar/Services/Apis.dart';
import 'package:anaj_bazar/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customDialoguebox.dart';
import '../../Constants/customImage.dart';
import '../../Constants/customText.dart';
import '../../Controllers/homeControllers.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  List<String> images = [
    myorders_image,
    location_image,
    privacypolice_image,
    // notifications_profile_image,
    // setting_image,
    termsandcondition_image,
    termsandcondition_image,
    // changelanguage_image,
    deleteaccount_image
  ];

  List<String> titles = [
    "My Orders",
    "My Address",
    "Privacy And Policy",
    // "Notifications",
    // "Settings",
    "Terms And Conditions",
    "Change Language",
    "Delete Account",
  ];

  bool isLanguageChanged = false;
  String langaugeCode = '';

  @override
  void initState() {
    super.initState();
    termsandconditionUrl = termsAndConditions;
    privacypolicyUrl = privacyAndPolicy;
    appLanguage = Provider.of<AppLanguage>(context, listen: false);
    appLanguage.fetchLocale();
    profileController = Provider.of<ProfileController>(context, listen: false);
    profileController.getUserDetails();
  }

  ProfileController profileController = ProfileController();

  AppLanguage appLanguage = AppLanguage();

  @override
  void didChangeDependencies() {
    if (appLanguage.selectedLanguage == 1) {
      titles = [
        AppLocalizations.of(context)!.myorders,
        AppLocalizations.of(context)!.myadress,
        AppLocalizations.of(context)!.privacypolicy,
        AppLocalizations.of(context)!.termscondition,
        AppLocalizations.of(context)!.changelanguage,
        AppLocalizations.of(context)!.deletaccount,
      ];
    } else {
      titles = [
        "My Orders",
        "My Address",
        "Privacy And Policy",
        "Terms And Conditions",
        "Change Language",
        "Delete Account",
      ];
    }
    super.didChangeDependencies();
  }

  String termsandconditionUrl = '';
  String privacypolicyUrl = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
            text: AppLocalizations.of(context)!.profile,
            context: context,
            actions: [
              CustomTap(
                  onTap: () {
                    Routes().pushroute(
                        context: context, pages: EditProfileScreen());
                  },
                  child: CustomImage(image: edit_image))
            ],
            onTap: () {
              Provider.of<HomeControllers>(context, listen: false)
                  .changeIndex(0);
            },
          ),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: myProfile(),
            physics: BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget myProfile() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          userDetails(),
          CustomSizedBox(
            height: customHeight(context: context, height: .06),
          ),
          CustomButton(
            text: '',
            onTap: () {
              dialogueboxopened(isDelete: false);
            },
            border: Border.all(color: tTextSecondaryColor, width: 2),
            buttonColor: tTransparrentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(image: logout_image),
                CustomSizedBox(
                  width: customWidth(context: context, width: .04),
                ),
                CustomText(
                  text: AppLocalizations.of(context)!.logout,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: tTextSecondaryColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future dialogueboxopened(
      {String? title, required bool isDelete, String? deleteContect}) {
    return dialogueBox(
        context: context,
        title: CustomPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: size(context: context).height * .02,
              ),
              CustomText(
                text: title ?? '${AppLocalizations.of(context)!.logout} ??',
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: tTextSecondaryColor,
              ),
              CustomPadding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Divider(
                  color: tDividerColor,
                ),
              ),
              Flexible(
                child: CustomText(
                  text: deleteContect ??
                      AppLocalizations.of(context)!.cnfrmlogout,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomSizedBox(
                height: size(context: context).height * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTap(
                    onTap: () {
                      Routes().backroute(context: context);
                    },
                    child: CustomText(
                      text: AppLocalizations.of(context)!.cancel,
                      fontSize: 16,
                      color: tTextSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomTap(
                    onTap: () async {
                      if (!isDelete) {
                        final SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        Routes().pushroutewithremove(
                            context: context,
                            pages: LoginScreen(isLogin: true));
                      } else {
                        Routes().backroute(context: context, value: true);
                      }
                    },
                    child: CustomPadding(
                      padding: EdgeInsets.only(left: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: tButtonColor,
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: CustomPadding(
                          padding: EdgeInsets.all(6),
                          child: CustomText(
                            text: title ?? AppLocalizations.of(context)!.logout,
                            fontSize: 16,
                            color: tPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget userDetails() {
    return Consumer<ProfileController>(
      builder: (context, value, child) => value.isLoading
          ? CustomSizedBox(
              height: size(context: context).height * .7,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : value.userDetailsModel == null
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: Center(
                    child: CustomText(
                        text: AppLocalizations.of(context)!.errloading),
                  ),
                )
              : value.userDetailsModel?.user == null
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.nodata),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Color(0XFFF5921E).withOpacity(.4),
                              child: CustomText(
                                text: value.userDetailsModel?.user.firstName[0]
                                        .toString() ??
                                    '',
                                fontSize: 30,
                                color: tTabSelectedColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomSizedBox(
                              width: customWidth(context: context, width: .07),
                            ),
                            CustomText(
                              text:
                                  '${value.userDetailsModel?.user.firstName} ${value.userDetailsModel?.user.lastName}',
                              fontSize: 20,
                              color: tTextSecondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        CustomSizedBox(
                          height: 10,
                        ),
                        emailandnumber(massage,
                            value.userDetailsModel?.user.emailId ?? ''),
                        emailandnumber(call,
                            value.userDetailsModel?.user.mobileNumber ?? ''),
                        CustomPadding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: tDividerColor,
                            thickness: .7,
                          ),
                        ),
                        ListView.builder(
                          itemCount: images.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return profileRowsreusable(
                                images[index], titles[index], index);
                          },
                        ),
                      ],
                    ),
    );
  }

  Widget emailandnumber(String images, String text) {
    return CustomPadding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CustomImage(image: images),
          CustomSizedBox(
            width: customWidth(context: context, width: .05),
          ),
          CustomText(
            text: text,
            color: tTextSecondaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ],
      ),
    );
  }

  Widget profileRowsreusable(String images, String names, int index) {
    return CustomTap(
      onTap: () async {
        if (index == 2) {
          Routes().pushroute(
              context: context,
              pages: WebViewScreen(
                url: privacypolicyUrl,
                titles: AppLocalizations.of(context)!.privacypolicy,
              ));
        } else if (index == 0) {
          Routes().pushroute(
              context: context,
              pages: MyOrdersScreen(
                isFromOrderConfirm: false,
              ));
        } else if (index == 3) {
          Routes().pushroute(
              context: context,
              pages: WebViewScreen(
                url: termsandconditionUrl,
                titles: AppLocalizations.of(context)!.termscondition,
              ));
        } else if (index == 1) {
          Routes().pushroute(
              context: context,
              pages: MyAdressesScreen(
                whenNoAdress: false,
                isfromAddADress: false,
              ));
        } else if (index == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LanguageSelectionScreen(
                        isStartingApp: false,
                      ))).then((value) {
            appLanguage.fetchLocale();
          });
        } else if (index == 5) {
          dialogueboxopened(
            isDelete: true,
            title: AppLocalizations.of(context)!.delete,
            deleteContect: AppLocalizations.of(context)!.deleteaccConfirm,
          ).then((value) => value != null
              ? {
                  if (value == true)
                    {
                      profileController.deleteUser(context),
                    }
                }
              : {});
        }
      },
      child: CustomPadding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomImage(
                  image: images,
                ),
                CustomSizedBox(
                  width: customWidth(context: context, width: .07),
                ),
                CustomText(
                  text: names,
                  fontWeight: FontWeight.w500,
                  color: tTextSecondaryColor,
                  fontSize: 16,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 17,
            )
          ],
        ),
      ),
    );
  }
}
