// ignore_for_file: must_be_immutable

import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/introControllers.dart';
import 'package:anaj_bazar/Screens/Auth/loginScreen.dart';
import 'package:anaj_bazar/Screens/Home/tabs.dart';
import 'package:anaj_bazar/Screens/Intro/languageSelection.dart';
import 'package:anaj_bazar/language.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customDialoguebox.dart';
import '../../internetChecker.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  List<String> imagesList = [
    splash_1,
    splash_2,
  ];
  List<String> titleList = [
    'Buy at Wholesale',
    'Best Wholesale ',
  ];
  List<String> priceAndratesList = [
    'Prices',
    'Rates',
  ];
  List<String> descriptionList = [
    'Find a wide range of house hold items at AnajBazaar',
    'Easily get your hands on everything that your business needs through AnajBazaar App',
  ];
  PageController controller = PageController();

  var token;

  @override
  void didChangeDependencies() {
    checkuserLanguageSelection();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    introControllers.resetSliderindex();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkuserLanguage();
    introControllers = Provider.of<IntroControllers>(context, listen: false);
  }

  checkuserLanguage() async {
    appLanguage = await Provider.of<AppLanguage>(context, listen: false);
    await appLanguage.fetchLocale();
    if (appLanguage.selectedLanguage == 1) {
      titleList = [
        AppLocalizations.of(context)!.buyatwholesale,
        AppLocalizations.of(context)!.bestwholesale,
      ];
      descriptionList = [
        AppLocalizations.of(context)!.findawiderange,
        AppLocalizations.of(context)!.easilygetyours,
      ];

      priceAndratesList = [
        AppLocalizations.of(context)!.price,
        AppLocalizations.of(context)!.rate,
      ];
      setState(() {});
    }
  }

  checkuserLanguageSelection() async {
    if (appLanguage.selectedLanguage == 1) {
      titleList = [
        AppLocalizations.of(context)!.buyatwholesale,
        AppLocalizations.of(context)!.bestwholesale,
      ];
      descriptionList = [
        AppLocalizations.of(context)!.findawiderange,
        AppLocalizations.of(context)!.easilygetyours,
      ];

      priceAndratesList = [
        AppLocalizations.of(context)!.price,
        AppLocalizations.of(context)!.rate,
      ];
    }
  }

  AppLanguage appLanguage = AppLanguage();
  IntroControllers introControllers = IntroControllers();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageViewBuilder(),
              ],
            ),
            Positioned(
              bottom: customHeight(context: context, height: .01),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dotsGenerator(),
                  CustomSizedBox(
                    height: customHeight(context: context, height: .05),
                  ),
                  Consumer<IntroControllers>(
                    builder: (context, value, child) => CustomButton(
                      text: value.sliderIndex == 0
                          ? AppLocalizations.of(context)!.next
                          : AppLocalizations.of(context)!.getstarted,
                      height: 50,
                      onTap: () {
                        value.sliderIndex == 0
                            ? controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease)
                            : Routes().pushroute(
                                context: context,
                                pages: LoginScreen(
                                  isLogin: true,
                                ));
                      },
                      width: customWidth(context: context, width: .55),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dotsGenerator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        imagesList.length,
        (index) => Consumer<IntroControllers>(
          builder: (context, value, child) => Container(
            height: 9,
            width: value.sliderIndex == index ? 25 : 10,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: value.sliderIndex == index
                  ? tDotsColor
                  : tDotsColor.withOpacity(.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget pageViewBuilder() {
    return Flexible(
        child: ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: PageView.builder(
        controller: controller,
        physics: const PageScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: imagesList.length,
        onPageChanged: (value) {
          Provider.of<IntroControllers>(context, listen: false)
              .updateSliderIndex(value);
        },
        itemBuilder: (context, index) {
          return Slider(
              priceAndrates: priceAndratesList[index],
              image: imagesList[index],
              title: titleList[index],
              description: descriptionList[index]);
        },
      ),
    ));
  }
}

class Slider extends StatelessWidget {
  String image, title, description, priceAndrates;

  //Constructor created
  Slider(
      {required this.image,
      required this.priceAndrates,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: CustomImage(
            alignment: Alignment.center,
            image: image,
            fit: BoxFit.cover,
            height: customHeight(context: context, height: .6),
            width: double.infinity,
          ),
        ),
        buywholesaleText()
      ],
    );
  }

  Widget buywholesaleText() {
    return CustomPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomPadding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomText(
              text: title,
              fontSize: 30,
              color: tTextSecondaryColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomPadding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CustomText(
              text: priceAndrates,
              fontSize: 30,
              color: tButtonColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomText(
            text: description,
            extrafontStyle: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
            fontSize: 17,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class CheckUserLoggedStatus extends StatefulWidget {
  const CheckUserLoggedStatus({super.key});

  @override
  State<CheckUserLoggedStatus> createState() => _CheckUserLoggedStatusState();
}

class _CheckUserLoggedStatusState extends State<CheckUserLoggedStatus> {
  var token;
  String checkisUserAlreadylanguageSelected = '';
  checkUserSIgnedOrNot() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
      checkisUserAlreadylanguageSelected =
          pref.getString('language_code') ?? '-1';
    });

    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => checkisUserAlreadylanguageSelected != '-1'
              ? LogoScreen()
              : const LanguageSelectionScreen(
                  isStartingApp: true,
                ),
        ),
      );
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomeScreenTabs()));
    }
  }

  bool isOnline = false;
  bool isOfline = false;
  @override
  void initState() {
    super.initState();
    // stopNativesplash();
    checkUserSIgnedOrNot();

    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) async {
      _source = source;
      debugPrint('source $_source'.toString());
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';

          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';

          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }

      setState(() {});
      if (string == 'Offline') {
        !isOnline ? customNonetBox() : null;
        isOnline = true;
      } else if (string == 'Mobile: Online' || string == 'WiFi: Online') {
        if (isOnline) {
          isOfline ? null : Navigator.of(context).pop(true);
        }

        isOnline || isOfline
            ? noInternetPopUp('Back To Online', Colors.blue, true)
            : null;
        isOnline = false;
      }
    });
  }

  noInternetPopUp(
    String text,
    Color dependsOnInternet,
    bool dismiss,
  ) {
    return showSimpleNotification(
      Center(
          child: CustomText(
        text: text,
        fontWeight: FontWeight.w600,
        color: tPrimaryColor,
      )),
      autoDismiss: dismiss,
      elevation: 0,
      background: dependsOnInternet,
    );
  }

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void dispose() {
    super.dispose();
    _networkConnectivity.disposeStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  customNonetBox() {
    dialogueBox(
        context: context,
        barrierDismissible: false,
        height: customHeight(context: context, height: .15),
        title: CustomPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'No Internet Connection',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              CustomPadding(
                padding: EdgeInsets.only(top: 7),
                child: CustomText(
                  text: 'Please Check Your Internet Connection',
                  fontSize: 15,
                ),
              ),
              CustomSizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      isOfline = true;
                    },
                    text: 'Close',
                    height: size(context: context).height * .045,
                    width: size(context: context).width * .2,
                    buttonColor: tPrimaryColor,
                    textColor: tButtonColor,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
