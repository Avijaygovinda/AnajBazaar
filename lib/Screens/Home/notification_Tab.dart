import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customText.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({super.key});

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  List<String> notificationsList = [
    notification_1_image,
    notification_2_image,
    notification_3_image
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<HomeControllers>(context, listen: false).getNotificationsdata();
  }

  String formattedTime = '';
  String formattedDate = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
              text: AppLocalizations.of(context)!.notification,
              context: context,
              onTap: () {
                Provider.of<HomeControllers>(context, listen: false)
                    .changeIndex(0);
              },
              actions: [
                Consumer<HomeControllers>(
                  builder: (context, value, child) => CustomTap(
                      onTap: () async {
                        value.clearNotifications();
                      },
                      child: value.notificationsLength == 0
                          ? Container()
                          : CustomImage(image: delete_image)),
                )
              ]),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: notifications(),
            physics: BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget notifications() {
    return Consumer<HomeControllers>(
      builder: (context, value, child) => value.isLoading
          ? CustomSizedBox(
              height: size(context: context).height * .7,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : value.notificationsModel?.notifications == null
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: Center(
                    child: CustomText(
                        text: AppLocalizations.of(context)!.errloading),
                  ),
                )
              : value.notificationsModel?.notifications.isEmpty ??
                      value.notificationsModel?.notifications == null
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.nodata),
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.notificationsModel?.notifications.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var notifications =
                            value.notificationsModel?.notifications[index];
                        var dateTime =
                            DateTime.parse(notifications?.createdAt ?? '2021');
                        formattedDate =
                            '${DateFormat.yMMMd().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
                        // DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
                        // print(DateFormat.yMMMd().format(dateTime));
                        // print(DateFormat.jm().format(dateTime));
                        // formattedTime = DateFormat('kk:mm').format(dateTime);

                        return CustomPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomImage(
                                          image: notification_1_image,
                                          height: customHeight(
                                              context: context, height: .06),
                                          width: customWidth(
                                              context: context, width: .15),
                                          fit: BoxFit.contain,
                                        ),
                                        Expanded(
                                          child: CustomPadding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomText(
                                                  text: notifications?.title ??
                                                      '',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: tTextSecondaryColor,
                                                ),
                                                // CustomSizedBox(
                                                //   height: customHeight(
                                                //       context: context,
                                                //       height: .005),
                                                // ),
                                                CustomPadding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: CustomText(
                                                    text: notifications
                                                            ?.message ??
                                                        '',
                                                    fontSize: 15,
                                                    color: tTextSecondaryColor,
                                                  ),
                                                ),
                                                CustomText(
                                                  text: formattedDate,
                                                  fontSize: 15,
                                                  color: tTextSecondaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // CustomText(
                                      //   text: formattedTime,
                                      //   fontSize: 15,
                                      //   color: tTextSecondaryColor,
                                      // ),
                                      // CustomSizedBox(
                                      //   height: customHeight(
                                      //       context: context, height: .017),
                                      // ),
                                      // CustomPadding(
                                      //   padding: EdgeInsets.only(right: 5),
                                      //   child: CircleAvatar(
                                      //     radius: 5,
                                      //     backgroundColor: tButtonColor,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                height: customHeight(
                                    context: context, height: .015),
                              ),
                              Divider(
                                thickness: 0.5,
                                color: tDividerColor,
                              ),
                              CustomSizedBox(
                                height: customHeight(
                                    context: context, height: .015),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
