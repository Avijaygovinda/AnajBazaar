import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customButton.dart';
import '../../Constants/customImage.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customPadding.dart';
import '../../Constants/customSizedBox.dart';
import '../../Constants/customText.dart';
import '../../Constants/customTextfield.dart';
import '../../Constants/images.dart';

class AddLocationsSCreen extends StatefulWidget {
  const AddLocationsSCreen({
    super.key,
    required this.id,
    required this.isfromEdit,
    required this.isfromSearch,
    required this.lat,
    required this.long,
  });
  final int id;
  final bool isfromEdit;
  final bool isfromSearch;
  final double lat;
  final double long;

  @override
  State<AddLocationsSCreen> createState() => _AddLocationsSCreenState();
}

class _AddLocationsSCreenState extends State<AddLocationsSCreen> {
  List<String?> first = List.filled(1, '');
  TextEditingController firstController = TextEditingController();
  final FocusNode _houseFocus = FocusNode();
  List<String?> house = List.filled(1, '');
  TextEditingController houseController = TextEditingController();
  final FocusNode _streetFocus = FocusNode();
  List<String?> street = List.filled(1, '');
  TextEditingController streetController = TextEditingController();
  List<String?> number = List.filled(1, '');
  TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  HomeControllers homeControllers = HomeControllers();
  bool validateAndSave() {
    final form = formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();

      return true;
    }
  }

  LocationControllers locationControllers = LocationControllers();

  updateValuesFromEditScreen() async {
    await locationControllers.getAdressDetails(widget.id);
    var checkDefault = false;
    var checkAdressType = int.parse('0');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      locationControllers.updateDefaultSelection(checkDefault);
      locationControllers.updateSelectedValues(checkAdressType);
    });

    firstController.text =
        locationControllers.addressDetailsModel?.address.name ?? '';
    numberController.text =
        locationControllers.addressDetailsModel?.address.contactNumber ?? '';
    var checkCommathereOrNot =
        locationControllers.addressDetailsModel!.address.address1.contains(',');
    if (checkCommathereOrNot) {
      houseController.text = locationControllers
              .addressDetailsModel?.address.address1
              .replaceAll(',', '') ??
          '';
    } else {
      houseController.text =
          locationControllers.addressDetailsModel?.address.address1 ?? '';
    }

    streetController.text =
        locationControllers.addressDetailsModel?.address.address2 ?? '';
    locationControllers.addressDetailsModel?.address.landmark
        .replaceAll('', '');
  }

  ProfileController profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    homeControllers = Provider.of<HomeControllers>(context, listen: false);
    profileController = Provider.of<ProfileController>(context, listen: false);
    profileController.getUserDetails();

    locationControllers =
        Provider.of<LocationControllers>(context, listen: false);
    updateAdress();
    widget.isfromEdit ? updateValuesFromEditScreen() : null;
  }

  updateAdress() async {
    await locationControllers.getAdressFromlatLong(
        widget.lat, widget.long, widget.isfromSearch, widget.isfromEdit);
    streetController.text = await '${locationControllers.updatedAdress}';
    // unChangebleAddress = locationControllers.unchangesAddress;
  }

  bool isTapped = true;

  @override
  Widget build(BuildContext context) {
    return addAdressContainer();
  }

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: tTransparrentColor),
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget addAdressContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [textFields()],
    );
  }

  textFields() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomPadding(
            padding: EdgeInsets.only(top: 10, bottom: 0),
            child: CustomText(
              text: AppLocalizations.of(context)!.adresdetails,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tTextSecondaryColor,
            ),
          ),
          textFieldWidget(
            context: context,
            hint: AppLocalizations.of(context)!.houseno,
            hinttext: '',
            controller: houseController,
            currentFocus: _houseFocus,
            textCapitalization: TextCapitalization.words,
            nextFocus: _streetFocus,
            holder: house,
            // isEmail: true,
            labelText: AppLocalizations.of(context)!.houseno,
            prefixIcon: CustomImage(image: location_home_image),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .01),
          ),
          Consumer<LocationControllers>(
            builder: (context, value, child) {
              if (value.isSelectedMap) {
                if (value.updatedAdress != '') {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    debugPrint(value.updatedAdress.toString());
                    streetController.text = value.updatedAdress;
                    if (WidgetsBinding.instance.window.viewInsets.bottom >
                        0.0) {
                      value.handlekeyboardOpenAdressFetching(false);
                    }
                  });
                }
              }
              return textFieldWidget(
                context: context,
                hint: AppLocalizations.of(context)!.area,
                hinttext: '',
                controller: streetController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validation: true,
                currentFocus: _streetFocus,
                textCapitalization: TextCapitalization.words,
                nextFocus: null,
                holder: street,
                // isEmail: true,
                labelText: AppLocalizations.of(context)!.area,
                prefixIcon: CustomImage(image: location_home_image),
              );
            },
            // child:
          ),
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child:
                Consumer<LocationControllers>(builder: (context, value, child) {
              return CustomText(
                text: value.unchangesAddress,
                fontWeight: FontWeight.w600,
                color: tTextSecondaryColor,
                fontSize: 16,
              );
            }),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .01),
          ),
          addAdressbtn()
        ],
      ),
    );
  }

  Widget addAdressbtn() {
    return Consumer<LocationControllers>(
      builder: (context, value, child) => CustomButton(
        onTap: () async {
          if (isTapped) {
            isTapped = false;
            if (validateAndSave()) {
              var adress1;
              var user = profileController.userDetailsModel?.user;
              var name = '${user?.firstName} ${user?.lastName}';
              var number = user?.mobileNumber ?? '';

              var landmark = streetController.text;
              var adressId = widget.id;
              var isFromedit = widget.isfromSearch ? false : widget.isfromEdit;
              // if (houseController.text.contains(',')) {
              adress1 = houseController.text;
              // } else {
              //   if (isFromedit) {
              //     adress1 = '${houseController.text},';
              //   } else {
              //     adress1 = houseController.text;
              //   }
              // }
              await value.addAdress(adress1, name, number, landmark, context,
                  adressId, isFromedit);
            }
            isTapped = true;
          }
        },
        text: '',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPadding(
                padding: EdgeInsets.only(right: 10),
                child: CustomImage(image: location_add_image)),
            CustomText(
              text: AppLocalizations.of(context)!.confirmadress,
              color: tPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )
          ],
        ),
      ),
    );
  }
}
