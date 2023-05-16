import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customSizedBox.dart';
import '../../Constants/customText.dart';
import '../../Controllers/homeControllers.dart';

class TicketTab extends StatefulWidget {
  const TicketTab({super.key});

  @override
  State<TicketTab> createState() => _TicketTabState();
}

class _TicketTabState extends State<TicketTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeControllers>(context, listen: false).getCouponsdata();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
            text: AppLocalizations.of(context)!.coupon,
            context: context,
            onTap: () {
              Provider.of<HomeControllers>(context, listen: false)
                  .changeIndex(0);
            },
          ),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: coupons(),
            physics: BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget coupons() {
    return Consumer<HomeControllers>(
      builder: (context, value, child) => value.isLoading
          ? CustomSizedBox(
              height: size(context: context).height * .7,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : value.couponsModel?.promoCodes == null
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: Center(
                    child: CustomText(
                        text: AppLocalizations.of(context)!.errloading),
                  ),
                )
              : value.couponsModel?.promoCodes.isEmpty ??
                      value.couponsModel?.promoCodes == null
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.nodata),
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.couponsModel?.promoCodes.length,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var coupons = value.couponsModel?.promoCodes[index];
                        DateTime date = new DateFormat("yyyy-MM-dd").parse(
                            coupons?.endDate.toString() ??
                                '2022-11-19T00:00:00.000Z');
                        var formatedDay = DateFormat.d().format(date);
                        var formatedMonth = DateFormat.MMM().format(date);
                        var formatedDate = DateFormat.y().format(date);

                        return CustomPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CustomText(
                                      text: coupons?.title ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: tTextSecondaryColor,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: AppLocalizations.of(context)!
                                            .expires,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: tPinkColor,
                                      ),
                                      CustomText(
                                        text:
                                            '${formatedDay} ${formatedMonth} ${formatedDate}',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: tTextSecondaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                height: customHeight(
                                    context: context, height: .009),
                              ),
                              CustomText(
                                text: coupons?.description ?? '',
                                fontSize: 15,
                                color: tTextSecondaryColor,
                              ),
                              CustomSizedBox(
                                height: customHeight(
                                    context: context, height: .015),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: coupons?.promoCode ?? '',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: tButtonColor,
                                  ),
                                  CustomTap(
                                    onTap: () async {
                                      await FlutterClipboard.copy(
                                              coupons?.promoCode ?? '')
                                          .then((value) => toast(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .copiedsuccess));
                                    },
                                    child: CustomImage(
                                      image: copy_image,
                                      // child: CustomButton(

                                      //   text: 'Copy',
                                      //   fontSize: 15,
                                      //   alignment: Alignment.center,
                                      //   height: customHeight(
                                      //       context: context, height: .04),
                                      //   width: customWidth(
                                      //       context: context, width: .3),
                                      // ),
                                    ),
                                  )
                                ],
                              ),
                              CustomSizedBox(
                                height: customHeight(
                                    context: context, height: .018),
                              ),
                              Divider(
                                thickness: 0.5,
                                color: tDividerColor,
                              ),
                              CustomSizedBox(
                                height: customHeight(
                                    context: context, height: .018),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
