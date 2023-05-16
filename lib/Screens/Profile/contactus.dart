import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customMediaQuery.dart';

class ContactsUsSCreen extends StatefulWidget {
  const ContactsUsSCreen({super.key});

  @override
  State<ContactsUsSCreen> createState() => _ContactsUsSCreenState();
}

class _ContactsUsSCreenState extends State<ContactsUsSCreen> {
  String number = '0';

  @override
  void initState() {
    super.initState();
    number = contactNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
        backgroundColor: tPrimaryColor,
        appBar: appBar(
            text: AppLocalizations.of(context)!.contactus,
            context: context,
            color: tPrimaryColor),
        body: CustomPadding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomPadding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: CustomImage(
                  image: contactus_image,
                  height: customHeight(context: context, height: .35),
                  width: customWidth(context: context, width: 1),
                ),
              ),
              Row(
                children: [
                  CustomImage(
                    image: call_image,
                    height: customHeight(context: context, height: .05),
                    width: customWidth(context: context, width: .2),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Contact Us $number',
                        fontWeight: FontWeight.w700,
                      ),
                      CustomPadding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: CustomButton(
                          onTap: () async {
                            await FlutterPhoneDirectCaller.callNumber(number);
                          },
                          text: 'Call',
                          width: customWidth(context: context, width: .25),
                          height: customHeight(context: context, height: .045),
                        ),
                      )
                    ],
                  )
                ],
              ),
              // CustomPadding(
              //   padding: EdgeInsets.symmetric(vertical: 20),
              //   child: Row(
              //     children: [
              //       CustomImage(
              //         image: whatsapp_image,
              //         height: customHeight(context: context, height: .065),
              //         width: customWidth(context: context, width: .2),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           CustomText(
              //             text: 'Whatsapp Us $number',
              //             fontWeight: FontWeight.w700,
              //           ),
              //           CustomPadding(
              //             padding: EdgeInsets.symmetric(vertical: 9),
              //             child: CustomButton(
              //               onTap: () async {},
              //               text: 'Message',
              //               fontSize: 15,
              //               width: customWidth(context: context, width: .25),
              //               height:
              //                   customHeight(context: context, height: .045),
              //             ),
              //           )
              //         ],
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      )),
    );
  }

  // void launchWhatsapp() async {
  //   if (await canLaunch(Constants.whatsapppNumber)) {
  //     await launch(Constants.whatsapppNumber);
  //   } else {
  //     customToast(message: 'failed to launch');
  //     throw 'Could not launch $Constants.whatsapppNumber';
  //   }
  // }
}
