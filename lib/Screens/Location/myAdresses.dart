import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Screens/Location/searchLocation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customDialoguebox.dart';
import '../../Constants/customToast.dart';
import '../../Controllers/homeControllers.dart';

class MyAdressesScreen extends StatefulWidget {
  const MyAdressesScreen(
      {super.key, required this.isfromAddADress, required this.whenNoAdress});
  final bool isfromAddADress;
  final bool whenNoAdress;

  @override
  State<MyAdressesScreen> createState() => _MyAdressesScreenState();
}

class _MyAdressesScreenState extends State<MyAdressesScreen> {
  @override
  void initState() {
    super.initState();
    locationControllers =
        Provider.of<LocationControllers>(context, listen: false);
    locationControllers.getAdress();
    locationControllers.updatePrefAdress();
    // locationControllers.removePlaceLists();
  }

  LocationControllers locationControllers = LocationControllers();
  bool isTapped = true;
  var firstIndexLat = 0.0;
  var firstIndexLong = 0.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (widget.isfromAddADress) {
        if (locationControllers.getSelectedAdressIdFromPrefs == 0) {
          if (locationControllers.addressModel?.address.isEmpty ??
              locationControllers.addressModel?.address.length == 0) {
            toast(
                text: AppLocalizations.of(context)!.addadrestofurtheroperation);
          } else if (locationControllers.addressModel?.address.length == 1) {
            await locationControllers.whenNoDataSelectedThenAddedAdress(
                locationControllers.addressModel);
            var lat = firstIndexLat;
            var long = firstIndexLong;
            await Provider.of<HomeControllers>(context, listen: false)
                .sendWherehouse(lat, long, true, context);

            Routes().backroute(context: context);
            Provider.of<CartControllers>(context, listen: false)
                .getCartItems(context, false, false);
          } else {
            toast(
                text: AppLocalizations.of(context)!.addadrestofurtheroperation);
          }
        } else {
          Routes().backroute(context: context);
        }
        return false;
      },
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar:
                // widget.isfromAddADress
                //     ?
                appBar(
              text: AppLocalizations.of(context)!.myadress,
              context: context,
              onTap: () async {
                if (locationControllers.getSelectedAdressIdFromPrefs == 0) {
                  if (locationControllers.addressModel?.address.isEmpty ??
                      locationControllers.addressModel?.address.length == 0) {
                    toast(
                        text: AppLocalizations.of(context)!
                            .addadrestofurtheroperation);
                  } else if (locationControllers.addressModel?.address.length ==
                      1) {
                    await locationControllers.whenNoDataSelectedThenAddedAdress(
                        locationControllers.addressModel);
                    var lat = firstIndexLat;
                    var long = firstIndexLong;
                    await Provider.of<HomeControllers>(context, listen: false)
                        .sendWherehouse(lat, long, true, context);

                    Routes().backroute(context: context);
                    Provider.of<CartControllers>(context, listen: false)
                        .getCartItems(context, false, false);
                  } else {
                    toast(
                        text: AppLocalizations.of(context)!
                            .addadrestofurtheroperation);
                  }
                } else {
                  Routes().backroute(context: context);
                }
              },
            ),
            // : appBar(text: 'My Address', context: context),
            backgroundColor: tPrimaryColor,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: adressDetails(),
            ),
          ),
        ),
      ),
    );
  }

  Widget noadressContainer() {
    return CustomPadding(
      padding: EdgeInsets.only(left: 40, right: 40, top: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: CustomImage(
            image: location_no_image,
            height: customHeight(context: context, height: .3),
            width: customWidth(context: context, width: .8),
            fit: BoxFit.contain,
          )),
          CustomSizedBox(
            height: customHeight(context: context, height: .04),
          ),
          CustomText(
            text: AppLocalizations.of(context)!.noadressadded,
            fontWeight: FontWeight.w700,
            color: tTextSecondaryColor,
            fontSize: 23,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .025),
          ),
          CustomText(
            text: AppLocalizations.of(context)!.pleaseaddadress,
            fontWeight: FontWeight.w600,
            // color: tTextSecondaryColor,
            fontSize: 16,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .04),
          ),
          addAdressbtn()
        ],
      ),
    );
  }

  Widget addAdressbtn() {
    return CustomButton(
      onTap: () {
        Routes().pushroute(context: context, pages: LocationSelection());
      },
      text: '',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPadding(
              padding: EdgeInsets.only(right: 10),
              child: CustomImage(image: location_add_image)),
          CustomText(
            text: AppLocalizations.of(context)!.addadres,
            color: tPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )
        ],
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
                text: AppLocalizations.of(context)!.delete,
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
                text: AppLocalizations.of(context)!.deleteadress,
                fontWeight: FontWeight.w500,
              ),
              CustomSizedBox(
                height: size(context: context).height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTap(
                    onTap: () {
                      Routes().backroute(context: context);
                    },
                    child: CustomText(
                      text: AppLocalizations.of(context)!.no,
                      fontSize: 16,
                      color: tTextSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomTap(
                    onTap: () {
                      Routes().backroute(context: context, value: true);
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
                            text: AppLocalizations.of(context)!.yes,
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

  Widget adressDetails() {
    return Consumer<LocationControllers>(
      builder: (context, value, child) => value.addressModel?.address.isEmpty ??
              value.addressModel?.address.length == 0
          ? noadressContainer()
          : value.isLoading
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : value.addressModel?.address == null
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.errloading),
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          itemCount: value.addressModel?.address.length,
                          shrinkWrap: true,
                          // padding: EdgeInsets.only(top: 0),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var adressList = value.addressModel?.address[index];
                            if (value.addressModel?.address.length != 0) {
                              firstIndexLat =
                                  value.addressModel?.address[0].latitude ?? 0;
                              firstIndexLong =
                                  value.addressModel?.address[0].longitude ?? 0;
                            }

                            return CustomTap(
                              onTap: () async {
                                if (widget.isfromAddADress) {
                                  Map mapValues = await {
                                    "adressNamehomepage":
                                        "${adressList?.address2}, ${adressList?.city}, ${adressList?.state}, ${adressList?.pincode}",
                                    "ADress1HomepageUpdated":
                                        '${adressList?.address1},',
                                    "lathomepage": adressList?.latitude,
                                    "longhomepage": adressList?.longitude,
                                    "adressIDhomepage":
                                        adressList?.userAddressId,
                                    "adressUsernamehomepage": adressList?.name,
                                    "adressAdress1homepage":
                                        adressList?.address1,
                                    "adressCityhomepage": adressList?.city,
                                    "adressContacthomepage":
                                        adressList?.contactNumber,
                                    "adressLandmarkhomepage":
                                        adressList?.address2,
                                    "adressPincodehomepage":
                                        adressList?.pincode,
                                    "adressStatehomepage": adressList?.state,
                                    "fullAdresshomepage":
                                        "${adressList?.address2}, ${adressList?.city}, ${adressList?.state}, ${adressList?.pincode}",
                                  };
                                  await Provider.of<HomeControllers>(context,
                                          listen: false)
                                      .sendWherehouse(
                                          adressList?.latitude ?? 0,
                                          adressList?.longitude ?? 0,
                                          true,
                                          context);
                                  await Provider.of<CartControllers>(context,
                                          listen: false)
                                      .getCartItems(context, false, false);
                                  value.selectedAdress(
                                      index, mapValues, context);
                                }
                              },
                              child: CustomPadding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(
                                      //     color:
                                      //         value.getSelectedAdressIdFromPrefs ==
                                      //                 adressList?.userAddressId
                                      //             ? tTabColor
                                      //             : tTransparrentColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomPadding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: CustomText(
                                          text: adressList?.name ?? '',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: tTextSecondaryColor,
                                        ),
                                      ),
                                      CustomText(
                                        text:
                                            '${adressList?.address1}, ${adressList?.address2}, ${adressList?.city}, ${adressList?.state}, ${adressList?.pincode}',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: tTextSecondaryColor,
                                      ),
                                      CustomPadding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: CustomText(
                                          text:
                                              '${AppLocalizations.of(context)!.mobilenumber}: ${adressList?.contactNumber}',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: tTextSecondaryColor,
                                        ),
                                      ),
                                      CustomPadding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CustomTap(
                                              onTap: () async {
                                                try {
                                                  if (isTapped) {
                                                    isTapped = false;
                                                    await value.determinePosition(
                                                        context,
                                                        false,
                                                        true,
                                                        adressList?.latitude ??
                                                            0,
                                                        adressList?.longitude ??
                                                            0,
                                                        adressList
                                                                ?.userAddressId ??
                                                            0,
                                                        false);
                                                    isTapped = true;
                                                  }
                                                } catch (e) {
                                                  isTapped = true;
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  CustomImage(
                                                    image: edit_image,
                                                    height: 20,
                                                    width: 30,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  CustomPadding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: CustomText(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .edit,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          tTextSecondaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CustomTap(
                                              onTap: () async {
                                                dialogueboxopened()
                                                    .then((val) async {
                                                  if (val == true) {
                                                    var adressId = adressList
                                                            ?.userAddressId ??
                                                        0;
                                                    await value.deleteAdress(
                                                        adressId, context);
                                                  }
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  CustomImage(
                                                    image: delete_image,
                                                    height: 20,
                                                    width: 30,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  CustomText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .remove,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: tTextSecondaryColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color:
                                            value.getSelectedAdressIdFromPrefs ==
                                                    adressList?.userAddressId
                                                ? tButtonColor
                                                : tDividerColor,
                                        thickness:
                                            value.getSelectedAdressIdFromPrefs ==
                                                    adressList?.userAddressId
                                                ? 1.3
                                                : .3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        value.addressModel?.address.isNotEmpty ??
                                value.addressModel?.address.length != 0
                            ? CustomPadding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: addAdressbtn())
                            : Container()
                      ],
                    ),
    );
  }
}
