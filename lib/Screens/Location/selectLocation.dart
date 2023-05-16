import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customNavigation.dart';
import '../Home/search.dart';

class LocationSelection extends StatefulWidget {
  const LocationSelection({super.key});

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          // appBar: appBar(text: 'Settings', context: context),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: locations(),
          ),
        ),
      ),
    );
  }

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: tTransparrentColor),
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget searchBar() {
    return TextFormField(
      // readOnly: true,
      // onTap: () {
      //   Routes().pushroute(context: context, pages: SearchScreen());
      // },
      decoration: InputDecoration(
          prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 10, left: 20),
              child: CustomImage(
                image: search_image,
                height: 30,
                width: 20,
                fit: BoxFit.contain,
              )),
          filled: true,
          fillColor: tProductsbgColor,
          hintText: 'Search for Delivery Location',
          hintStyle: customTextstyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: tTextSecondaryColor),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          enabledBorder: inputBorder(),
          border: inputBorder(),
          enabled: true,
          prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          disabledBorder: inputBorder(),
          errorBorder: inputBorder(),
          focusedBorder: inputBorder(),
          focusedErrorBorder: inputBorder()),
    );
  }

  Widget locations() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: customHeight(context: context, height: .05),
          ),
          CustomText(
            text: 'Select Delivery Location',
            fontWeight: FontWeight.w700,
            fontSize: 27,
            color: tTextSecondaryColor,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .07),
          ),
          CustomImage(image: location_selection_image),
          CustomSizedBox(
            height: customHeight(context: context, height: .07),
          ),
          searchBar(),
          CustomSizedBox(
            height: customHeight(context: context, height: .06),
          ),
          CustomButton(
            buttonColor: tProductsbgColor,
            border: Border.all(color: tDotsColor),
            text: 'text',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomPadding(
                    padding: EdgeInsets.only(right: 10, left: 20),
                    child: CustomImage(image: navigation_image)),
                CustomText(
                  text: 'Use current location',
                  fontWeight: FontWeight.w700,
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
}
