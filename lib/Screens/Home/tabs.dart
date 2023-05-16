import 'dart:async';

import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Screens/Home/category_Tab.dart';
import 'package:anaj_bazar/Screens/Home/homeTab.dart';
import 'package:anaj_bazar/Screens/Home/notification_Tab.dart';
import 'package:anaj_bazar/Screens/Home/profile_Tab.dart';
import 'package:anaj_bazar/Screens/Home/ticket_Tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../../Constants/customDialoguebox.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customNavigation.dart';
import '../../Constants/customSizedBox.dart';
import '../../Controllers/cartControllers.dart';
import '../../language.dart';

class HomeScreenTabs extends StatefulWidget {
  const HomeScreenTabs({super.key});

  @override
  State<HomeScreenTabs> createState() => _HomeScreenTabsState();
}

class _HomeScreenTabsState extends State<HomeScreenTabs> {
  final pages = [
    const HomeTab(),
    const NotificationTab(),
    const CategoryTabs(),
    const TicketTab(),
    const ProfileTab(),
  ];

  Location location = Location();

  @override
  void initState() {
    super.initState();

    locationControllers =
        Provider.of<LocationControllers>(context, listen: false);

    locationControllers.getAdress();

    homeControllers = Provider.of<HomeControllers>(context, listen: false);

    checkGps();
    homeControllers.getTokenupdate();
    homeControllers.resetValues();
  }

  AppLanguage appLanguage = AppLanguage();

  LocationControllers locationControllers = LocationControllers();

  checkGps() async {
    appLanguage = await Provider.of<AppLanguage>(context, listen: false);
    await appLanguage.fetchLocale();
    await locationControllers.updatePrefAdress();
    updatewhenNoDataSelectedThenAddedAdress();

    await homeControllers.checkgps(context);
    await Provider.of<CartControllers>(context, listen: false)
        .getCartItems(context, true, false);
  }

  updatewhenNoDataSelectedThenAddedAdress() async {
    await locationControllers.getAdress();
    if (locationControllers.addressModel?.address.length != 0) {
      await locationControllers.getSelectedAdressIdFromPrefs == 0
          ? null
          : await homeControllers.sendWherehouse(
              locationControllers.addressModel?.address[0].latitude ?? 0,
              locationControllers.addressModel?.address[0].longitude ?? 0,
              true,
              context);
    }
  }

  @override
  void dispose() {
    homeControllers.disposelocation();
    // homeControllers.dispose();
    super.dispose();
  }

  HomeControllers homeControllers = HomeControllers();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (homeControllers.pageIndex > 0) {
          homeControllers.changeIndex(0);
        } else {
          dialogueboxopened();
        }

        return false;
      },
      child: Material(
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: bottomNavBar(),
            backgroundColor: tPrimaryColor,
            body: Consumer<HomeControllers>(
                builder: (context, value, child) => pages[value.pageIndex]),
          ),
        ),
      ),
    );
  }

  Future dialogueboxopened() {
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
                text: 'Exit',
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
              CustomText(
                text: 'Are You Sure You Want To Exit??',
                fontWeight: FontWeight.w500,
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
                      text: 'No',
                      fontSize: 16,
                      color: tTextSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomTap(
                    onTap: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                      Navigator.pop(context);
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
                            text: 'Yes',
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

  bottomNavBar() {
    return Container(
      // height: 60,
      decoration: BoxDecoration(
        color: tTabColor,
      ),
      child: Consumer<HomeControllers>(
        builder: (context, value, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomTap(
                onTap: () {
                  value.changeIndex(0);
                },
                child: CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: CustomImage(
                    height: 25,
                    width: 25,
                    image: value.pageIndex == 0 ? fill_home : home_image,
                    // color: value.pageIndex == 0 ? tTabSelectedColor : null,
                  ),
                )),
            CustomTap(
                onTap: () {
                  value.changeIndex(1);
                },
                child: CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: CustomImage(
                    height: 25,
                    width: 25,
                    image: value.pageIndex == 1
                        ? fill_notifications
                        : notification_image,
                    // color: value.pageIndex == 1 ? tTabSelectedColor : null,
                  ),
                )),
            CustomTap(
                onTap: () {
                  value.changeIndex(2);
                },
                child: CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: CustomImage(
                    height: 25,
                    width: 25,
                    image:
                        value.pageIndex == 2 ? fill_categories : category_image,
                    // color: value.pageIndex == 2 ? tTabSelectedColor : null,
                  ),
                )),
            CustomTap(
                onTap: () {
                  value.changeIndex(3);
                },
                child: CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: CustomImage(
                    height: 25,
                    width: 25,
                    image: value.pageIndex == 3 ? fill_tickets : ticket_image,
                    // color: value.pageIndex == 3 ? tTabSelectedColor : null,
                  ),
                )),
            CustomTap(
                onTap: () {
                  value.changeIndex(4);
                },
                child: CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  child: CustomImage(
                    height: 25,
                    width: 25,
                    image:
                        value.pageIndex == 4 ? fill_profile : myprofile_image,
                    // color: value.pageIndex == 4 ? tTabSelectedColor : null,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
