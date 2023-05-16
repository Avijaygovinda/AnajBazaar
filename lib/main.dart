import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/providersList.dart';
import 'package:anaj_bazar/pushnotifications.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Constants/colors.dart';
import 'Model/pushnotificationModel.dart';
import 'Screens/Intro/logo_Screen.dart';
import 'constants.dart';
import 'l10n/l10n.dart';
import 'language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: providersList(appLanguage), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        Localnotificationservice.displaymassage(event);
      }
      Localnotificationservice.initilize();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Localnotificationservice.displaymassage(event);
    });
  }

  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        FirebaseMessaging.onBackgroundMessage((message) async {
          return;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: Consumer<AppLanguage>(
        builder: (context, value, child) => MaterialApp(
            home: AnimatedSplashScreen(
              // nextScreen: const LanguageSelectionScreen(),
              nextScreen: const CheckUserLoggedStatus(),
              splashTransition: SplashTransition.fadeTransition,
              splash: CustomPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'Assets/Icons/Anajbazaar_latest_updated_splashlogo.png',
                      height: 150,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    CustomText(
                      text: 'by',
                      color: thomepagecategoriesColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    CustomPadding(
                      padding: EdgeInsets.only(top: 15),
                      child: CustomText(
                        text: 'Wonderworld Groceries AJCorp',
                        color: thomepagecategoriesColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              splashIconSize: 300,
            ),
            builder: EasyLoading.init(),
            title: appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: tPrimaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/',
            // routes: {
            //   '/': (context) => const CheckUserLoggedStatus(),
            // },

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: value.appLocal,
            supportedLocales: L10n.all),
      ),
    );
  }
}
