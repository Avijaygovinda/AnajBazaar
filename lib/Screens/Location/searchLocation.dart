import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Controllers/locationControllers.dart';

class LocationSelection extends StatefulWidget {
  const LocationSelection({super.key});

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  late GoogleMapController googleMapController;
  bool isTapped = true;
  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      Provider.of<LocationControllers>(context, listen: false)
          .getSuggestion(searchController.text);
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
              text: AppLocalizations.of(context)!.searchlocationnofor,
              context: context),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(child: locations()),
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

  Widget adressList() {
    return Consumer<LocationControllers>(
      builder: (context, value, child) => value.placeList.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: value.placeList.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 20),
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return CustomTap(
                  onTap: () async {
                    try {
                      if (isTapped) {
                        isTapped = false;
                        await movetoselectedplace(value, index);
                        isTapped = true;
                      }
                    } catch (e) {
                      isTapped = true;
                    }
                  },
                  child: CustomPadding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Card(
                      child: CustomPadding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 5),
                        child: CustomText(
                            text: value.placeList[index]['description']),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  movetoselectedplace(LocationControllers value, int index) async {
    searchController.clear();
    // _searchFocus.unfocus();
    var placeId = value.placeList[index]['place_id'];

    await value.getCordinates(placeId, context);

    // await value.jumpToSelectedLocation(googleMapController, context);
  }

  Widget searchBar() {
    return TextFormField(
      controller: searchController,
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
          hintText: AppLocalizations.of(context)!.searchlocation,
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: customHeight(context: context, height: .05),
          ),
          // CustomText(
          //   text: 'Select Delivery Location',
          //   fontWeight: FontWeight.w700,
          //   fontSize: 27,
          //   color: tTextSecondaryColor,
          // ),
          // CustomSizedBox(
          //   height: customHeight(context: context, height: .07),
          // ),
          // CustomImage(image: location_selection_image),
          // CustomSizedBox(
          //   height: customHeight(context: context, height: .07),
          // ),
          searchBar(),
          Column(
            children: [
              adressList(),
              CustomPadding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      textAlign: TextAlign.center,
                      text: AppLocalizations.of(context)!.or,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: tTextSecondaryColor,
                    ),
                  ],
                ),
              ),
              CustomButton(
                onTap: () async {
                  try {
                    if (isTapped) {
                      isTapped = false;
                      await Provider.of<LocationControllers>(context,
                              listen: false)
                          .determinePosition(
                              context, false, false, 0, 0, 0, false)
                          .then((value) {
                        isTapped = true;
                        if (value == true) {
                          Provider.of<LocationControllers>(context,
                                  listen: false)
                              .getAdress();
                        }
                      });
                      isTapped = true;
                    }
                  } catch (e) {
                    isTapped = true;
                  }
                },
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
                      text: AppLocalizations.of(context)!.usecurrentlocation,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: tTextSecondaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
