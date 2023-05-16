import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Screens/Home/tabs.dart';
import 'package:anaj_bazar/Screens/Orders/myOrders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key, required this.orderID});
  final int orderID;

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Routes().pushroute(context: context, pages: HomeScreenTabs());
        return false;
      },
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: appBar(
              text: AppLocalizations.of(context)!.confirmation,
              context: context,
              onTap: () {
                Routes().pushroute(context: context, pages: HomeScreenTabs());
              },
            ),
            backgroundColor: tPrimaryColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: confirmations(),
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmations() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSizedBox(
            height: customHeight(context: context, height: .12),
          ),
          Center(
              child: CustomImage(
            image: confirm_order,
            height: customHeight(context: context, height: .3),
            width: customWidth(context: context, width: .8),
            fit: BoxFit.contain,
          )),
          CustomPadding(
            padding: EdgeInsets.only(top: 10),
            child: CustomText(
              text: AppLocalizations.of(context)!.ordersuccess,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: tTextSecondaryColor,
            ),
          ),
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomText(
              text: AppLocalizations.of(context)!.thankyourorder,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: tTextSecondaryColor,
            ),
          ),
          CustomText(
            text:
                '${AppLocalizations.of(context)!.orderid}${widget.orderID.toString()}',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: thomepagecategoriesColor,
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .05),
          ),
          CustomButton(
            text: AppLocalizations.of(context)!.trackorder,
            onTap: () {
              Routes().pushroutewithremove(
                  context: context,
                  pages: MyOrdersScreen(
                    isFromOrderConfirm: true,
                  ));
            },
          )
        ],
      ),
    );
  }
}
