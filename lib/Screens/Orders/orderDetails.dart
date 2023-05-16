import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/orderControllers.dart';
import 'package:anaj_bazar/Screens/Orders/pdfViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customDialoguebox.dart';
import '../../Constants/customPadding.dart';
import '../../Constants/customText.dart';
import '../../Constants/customToast.dart';

class OrdersDetailsScreen extends StatefulWidget {
  const OrdersDetailsScreen(
      {super.key, required this.isPastOrders, required this.orderId});
  final int isPastOrders;
  final int orderId;

  @override
  State<OrdersDetailsScreen> createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrdersControllers>(context, listen: false)
        .getOrdersDetails(widget.orderId);
  }

  List<String?> name = List.filled(1, '');
  TextEditingController nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isCLicked = false;
  bool isTapped = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
            text: AppLocalizations.of(context)!.orderdetails,
            context: context,
          ),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: orders(),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: tPrimaryColor,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }

  Widget orders() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<OrdersControllers>(
        builder: (context, value, child) => value.isLoading
            ? CustomSizedBox(
                height: size(context: context).height * .7,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : value.orderDetailsModel?.orders == null
                ? CustomSizedBox(
                    height: size(context: context).height * .7,
                    child: Center(
                      child: CustomText(
                          text: AppLocalizations.of(context)!.errloading),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderDetails(value),
                      itemsDetails(value),
                      reUsablePrices(
                          AppLocalizations.of(context)!.itemtotal,
                          value.orderDetailsModel?.orders.subTotal.toString() ??
                              ''),
                      reUsablePrices(
                          AppLocalizations.of(context)!.deliverycharges,
                          value.orderDetailsModel?.orders.deliveryCharges
                                  .toString() ??
                              ''),
                      reUsablePrices(
                          AppLocalizations.of(context)!.discountammount,
                          value.orderDetailsModel?.orders.promoAmount
                                  .toString() ??
                              ''),
                      reUsablePrices(
                          AppLocalizations.of(context)!.amountpaid,
                          value.orderDetailsModel?.orders.grandTotal
                                  .toString() ??
                              ''),
                      value.orderDetailsModel?.orders.orderStatus == 3 ||
                              value.orderDetailsModel?.orders.orderStatus == 4
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomPadding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    color: tDividerColor,
                                    thickness: .5,
                                  ),
                                ),
                                CustomText(
                                  text: AppLocalizations.of(context)!
                                      .cancellationreason,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: tTextSecondaryColor,
                                ),
                                CustomPadding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: CustomText(
                                    text: value.orderDetailsModel?.orders
                                            .cancellationReason ??
                                        '',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: tTextSecondaryColor,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      CustomSizedBox(
                        height: customHeight(context: context, height: .02),
                      ),
                      Column(
                        children: [
                          widget.isPastOrders == 1
                              ? Container()
                              : value.orderDetailsModel?.orders.orderStatus == 1
                                  ? CustomButton(
                                      text:
                                          AppLocalizations.of(context)!.reorder,
                                      onTap: () async {
                                        if (isTapped) {
                                          isTapped = false;
                                          var orderId = value.orderDetailsModel
                                                  ?.orders.orderId ??
                                              0;
                                          var warehouseId = value
                                                  .orderDetailsModel
                                                  ?.orders
                                                  .warehouseId ??
                                              0;
                                          await value.reOrder(
                                              orderId, warehouseId, context);
                                          isTapped = true;
                                        }
                                      },
                                    )
                                  : Container(),
                          CustomSizedBox(
                            height: customHeight(context: context, height: .03),
                          ),
                          widget.isPastOrders == 1 ||
                                  value.orderDetailsModel?.orders.orderStatus ==
                                      1
                              ? CustomButton(
                                  text: widget.isPastOrders == 1
                                      ? AppLocalizations.of(context)!
                                          .cancelorder
                                      : AppLocalizations.of(context)!
                                          .viewinvoice,
                                  buttonColor: tPrimaryColor,
                                  textColor: tTextSecondaryColor,
                                  border:
                                      Border.all(color: tTextSecondaryColor),
                                  onTap: () async {
                                    if (widget.isPastOrders == 1) {
                                      dialogueboxopened(value.orderDetailsModel
                                                  ?.orders.orderId ??
                                              0)
                                          .then((value) {
                                        if (value == true) {
                                          Routes().backroute(context: context);
                                        }
                                      });
                                    } else {
                                      Routes().pushroute(
                                          context: context,
                                          pages: PDFViewer(
                                              pdfUrls: value.orderDetailsModel!
                                                  .orders.invoiceFile));
                                    }
                                  },
                                )
                              : Container(),
                          CustomSizedBox(
                            height: customHeight(context: context, height: .03),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }

  Future dialogueboxopened(int orderIdfromOrderDetails) {
    return dialogueBox(
        context: context,
        height: customHeight(context: context, height: .37),
        title: CustomPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: size(context: context).height * .02,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.reasonforcancellation,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: tTextSecondaryColor,
              ),
              CustomSizedBox(
                height: size(context: context).height * .02,
              ),
              TextFormField(
                maxLines: 6,
                controller: nameController,
                decoration: InputDecoration(
                    fillColor: tProductsbgColor,
                    filled: true,
                    hintText: AppLocalizations.of(context)!.typereason,
                    hintStyle: customTextstyle(
                        color: Color(0XFF727280),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    focusedBorder: inputBorder(),
                    border: inputBorder(),
                    errorBorder: inputBorder(),
                    enabledBorder: inputBorder(),
                    disabledBorder: inputBorder(),
                    focusedErrorBorder: inputBorder()),
              ),
              CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: CustomButton(
                    text: AppLocalizations.of(context)!.submit,
                    onTap: () {
                      if (isTapped) {
                        isTapped = false;
                        if (nameController.text.isNotEmpty) {
                          var cancellationReason = nameController.text;
                          var orderId = orderIdfromOrderDetails;

                          if (isCLicked == false) {
                            isCLicked = true;
                            Provider.of<OrdersControllers>(context,
                                    listen: false)
                                .cancelOrder(
                                    orderId, cancellationReason, context);
                            easyLoading(context: context);
                            ;
                            isCLicked = false;
                            nameController.clear();
                          }
                        } else {
                          toast(
                              text: AppLocalizations.of(context)!
                                  .entercancellationreason,
                              toastPosition: EasyLoadingToastPosition.top);
                        }
                        isTapped = true;
                      }
                    },
                  )),
            ],
          ),
        ));
  }

  Widget itemsDetails(OrdersControllers value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppLocalizations.of(context)!.items,
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: tTextSecondaryColor,
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .01),
        ),
        ListView.builder(
          itemCount: value.orderDetailsModel?.orders.orderItems.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var orders = value.orderDetailsModel?.orders.orderItems[index];
            return CustomPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustomText(
                          text:
                              '${orders?.productName ?? ''} x${orders?.quantity.toString() ?? ''}',
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: tTextSecondaryColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomText(
                        text: '₹${orders?.totalAmount}',
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: tTextSecondaryColor,
                      ),
                    ],
                  ),
                  CustomPadding(
                    padding: EdgeInsets.only(top: 3),
                    child: CustomText(
                      text: '${orders?.metricValue} ${orders?.metricType}',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: tTextSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        CustomPadding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: tDividerColor,
            thickness: .5,
          ),
        )
      ],
    );
  }

  Widget reUsablePrices(String text, String money) {
    return CustomPadding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: tTextSecondaryColor,
          ),
          CustomText(
            text: '₹${money}',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: tTextSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget orderDetails(OrdersControllers value) {
    var orders = value.orderDetailsModel?.orders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text:
                  '${AppLocalizations.of(context)!.orderidorders}${widget.orderId}',
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: tTextSecondaryColor,
            ),
            widget.isPastOrders != 0
                ? Container()
                : Flexible(
                    child: CustomPadding(
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomImage(
                            image:
                                value.orderDetailsModel?.orders.orderStatus == 1
                                    ? delivered_image
                                    : cancelled_image,
                            height: 15,
                            width: 15,
                            fit: BoxFit.contain,
                          ),
                          Flexible(
                            child: CustomPadding(
                              padding: EdgeInsets.only(left: 5, bottom: 3),
                              child: CustomText(
                                text: value.orderDetailsModel?.orders
                                            .orderStatus ==
                                        1
                                    ? AppLocalizations.of(context)!.delivered
                                    : value.orderDetailsModel?.orders
                                                .orderStatus ==
                                            2
                                        ? AppLocalizations.of(context)!.pending
                                        : value.orderDetailsModel?.orders
                                                    .orderStatus ==
                                                3
                                            ? AppLocalizations.of(context)!
                                                .usercancelled
                                            : value.orderDetailsModel?.orders
                                                        .orderStatus ==
                                                    4
                                                ? AppLocalizations.of(context)!
                                                    .admincancelled
                                                : '',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0XFF23AA49),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        // CustomPadding(
        //   padding: EdgeInsets.symmetric(vertical: 5),
        //   child: CustomText(
        //     text: orders?.expectedDelivery ?? '00',
        //     fontWeight: FontWeight.w500,
        //     fontSize: 14,
        //     color: tTextSecondaryColor,
        //   ),
        // ),
        CustomSizedBox(
          height: customHeight(context: context, height: .018),
        ),
        CustomPadding(
          padding: EdgeInsets.only(bottom: 5),
          child: CustomText(
            text: AppLocalizations.of(context)!.deliveryto,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: tTextSecondaryColor,
          ),
        ),
        CustomText(
          text:
              '${orders?.address1}, ${orders?.address2}, ${orders?.city}, ${orders?.state}, ${orders?.pincode} ',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: tTextSecondaryColor,
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .018),
        ),
        CustomText(
          text: AppLocalizations.of(context)!.paymentmethod,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: tTextSecondaryColor,
        ),
        CustomPadding(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: CustomText(
            text: orders?.paymentType == 1
                ? AppLocalizations.of(context)!.cashondelivery
                : AppLocalizations.of(context)!.online,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: tTextSecondaryColor,
          ),
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .018),
        ),
        CustomText(
          text: AppLocalizations.of(context)!.orderedon,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: tTextSecondaryColor,
        ),
        CustomPadding(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: CustomText(
            text: orders?.createdAt ?? '',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: tTextSecondaryColor,
          ),
        ),

        CustomPadding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: tDividerColor,
            thickness: .5,
          ),
        )
      ],
    );
  }
}
