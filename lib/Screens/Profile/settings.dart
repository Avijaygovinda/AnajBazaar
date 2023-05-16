import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool isValue = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(text: 'Settings', context: context),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: settings(),
          ),
        ),
      ),
    );
  }

  Widget settings() {
    return CustomTap(
      onTap: () {
        isValue = !isValue;
        Provider.of<ProfileController>(context, listen: false)
            .updateIsToggle(isValue);
      },
      child: CustomPadding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Notification',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      CustomText(
                        text: 'This will not affect any Order Updates',
                        // fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
                Consumer<ProfileController>(
                  builder: (context, value, child) => FlutterSwitch(
                    value: value.isToggleValue,
                    padding: 1,
                    width: 50.0,
                    height: 25.0,
                    valueFontSize: 12.0,
                    toggleSize: 18.0,
                    switchBorder: Border.all(color: tToggleColor, width: 2),
                    activeColor: tSwitchColor,
                    inactiveColor: tSwitchColor,
                    inactiveToggleColor: tToggleColor,
                    activeToggleColor: tButtonColor,
                    borderRadius: 25,
                    onToggle: (val) {
                      value.updateIsToggle(val);
                      isValue = val;
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: tDividerColor,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
