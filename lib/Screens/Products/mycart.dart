import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:anaj_bazar/Screens/Home/tabs.dart';
import 'package:anaj_bazar/Screens/Location/myAdresses.dart';
import 'package:anaj_bazar/Screens/Products/cartList.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customTap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Services/Apis.dart';

class MyCartDetails extends StatefulWidget {
  const MyCartDetails({super.key, required this.isFromMenuScreen});
  final bool isFromMenuScreen;

  @override
  State<MyCartDetails> createState() => _MyCartDetailsState();
}

class _MyCartDetailsState extends State<MyCartDetails> {
  @override
  void initState() {
    super.initState();
    cartControllers = Provider.of<CartControllers>(context, listen: false);
    cartControllers.resetValues();
    cartControllers.getCartItems(context, false, false);
    cartControllers.getSelectedValues();
    cartControllers.getminumumAmmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toast(text: "Payment Processing Cancelled by User");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External SDK Response: $response'.toString());
  }

  late Razorpay _razorpay;

  double subTotal = 0;
  CartControllers cartControllers = CartControllers();
  TextEditingController promoController = TextEditingController();
  bool isTapped = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromMenuScreen) {
          Routes().backroute(context: context);
        } else {
          Routes().pushroute(context: context, pages: HomeScreenTabs());
        }
        return false;
      },
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: appBar(
              text: AppLocalizations.of(context)!.mycart,
              context: context,
              onTap: () {
                if (widget.isFromMenuScreen) {
                  Routes().backroute(context: context);
                } else {
                  Routes().pushroute(context: context, pages: HomeScreenTabs());
                }
              },
            ),
            backgroundColor: tPrimaryColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: myCartList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget myCartList() {
    return Consumer<CartControllers>(
      builder: (context, value, child) =>
          cartControllers.cartItemsModel?.cart.isEmpty ??
                  cartControllers.cartItemsModel?.cart.length == 0
              ? noDataFoundContainer()
              : Column(
                  children: [deliveryADress(), cartLists(), paymentContainer()],
                ),
    );
  }

  Widget cartLists() {
    return CustomPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                CustomText(
                  text: AppLocalizations.of(context)!.yourcart,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: tTextSecondaryColor,
                ),
                Container(
                  height: customHeight(context: context, height: .037),
                  width: customWidth(context: context, width: .25),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0XFF643D22),
                      borderRadius: BorderRadius.circular(20)),
                  child: Consumer<CartControllers>(
                    builder: (context, value, child) => CustomText(
                      text:
                          '${value.itemsLength} ${AppLocalizations.of(context)!.items}',
                      color: tPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          cartItemsList()
        ],
      ),
    );
  }

  Widget cartItemsList() {
    return Consumer<CartControllers>(
      builder: (context, value, child) {
        var cart = value.cartItemsModel?.cart[0].cartItems;
        return value.isLoading
            ? CustomSizedBox(
                height: size(context: context).height * .7,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : cart == null
                ? CustomSizedBox(
                    height: size(context: context).height * .7,
                    child: Center(
                      child: CustomText(
                          text: AppLocalizations.of(context)!.errloading),
                    ),
                  )
                : cart.isEmpty
                    ? CustomSizedBox(
                        height: size(context: context).height * .7,
                        child: Center(
                          child: CustomText(
                              text: AppLocalizations.of(context)!.nodata),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cart.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var cartItems = cart[index];
                          var sellingPrice =
                              cartItems.sellingPrice * cartItems.quantity;
                          var price = cartItems.price * cartItems.quantity;
                          subTotal =
                              cart.map((e) => e.sellingPrice * e.quantity).sum;
                          return CartListDetails(
                            index: index,
                            cartControllers: cartControllers,
                            cartItem: cartItems,
                            price: price,
                            sellingPrice: sellingPrice,
                          );
                        },
                      );
      },
    );
  }

  Widget noDataFoundContainer() {
    return CustomPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSizedBox(
            height: customHeight(context: context, height: .1),
          ),
          Center(
              child: CustomImage(
            image: cart_nodata_image,
            height: customHeight(context: context, height: .37),
            width: customWidth(context: context, width: .9),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          )),
          CustomText(
            text: AppLocalizations.of(context)!.cartempty,
            fontWeight: FontWeight.w700,
            fontSize: 27,
            color: tTextSecondaryColor,
          ),
          CustomPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomText(
              text: AppLocalizations.of(context)!.lookslikenotaddedcart,
              fontWeight: FontWeight.w500,
              fontSize: 17,
              textAlign: TextAlign.center,
              color: tTextSecondaryColor,
            ),
          ),
          CustomButton(
            text: AppLocalizations.of(context)!.shopnow,
            onTap: () {
              Routes().backroute(context: context);
            },
            width: customWidth(context: context, width: .4),
          )
        ],
      ),
    );
  }

  Widget paymentContainer() {
    return CustomPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          CustomSizedBox(
            height: customHeight(context: context, height: .007),
          ),
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 3),
                  blurRadius: 12,
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                )
              ],
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Consumer<CartControllers>(
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TextFormField(
                          controller: promoController,
                          style: customTextstyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: tTextSecondaryColor,
                          ),
                          readOnly: value.isCouponApplied ? true : false,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  const CustomImage(image: cart_promo_image),
                              hintText:
                                  AppLocalizations.of(context)!.applypromocode,
                              contentPadding: const EdgeInsets.only(top: 13),
                              hintStyle: customTextstyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: tTextColor,
                              )),
                        ),
                        value.isCouponApplied
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: value.couponAppliedmsg,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: tTextSecondaryColor,
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, -3),
                                    child: CustomText(
                                      text:
                                          '${AppLocalizations.of(context)!.yousaved} ₹${value.couponMoney.toStringAsFixed(2).replaceAll('-', '')}',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: tTextSecondaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )),
                    value.isCouponApplied
                        ? CustomTap(
                            onTap: () {
                              value.updatePromo(false);
                              promoController.clear();
                            },
                            child: CustomPadding(
                              padding: EdgeInsets.only(right: 15),
                              child: CustomImage(
                                image: cart_promo_cancel,
                                height: 30,
                                width: 25,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : CustomPadding(
                            padding: EdgeInsets.only(right: 5),
                            child: CustomButton(
                              onTap: () async {
                                if (promoController.text.isNotEmpty) {
                                  var promo = promoController.text;
                                  await Provider.of<CartControllers>(context,
                                          listen: false)
                                      .verifyPromo(promo, context)
                                      .then((val) {
                                    value.isCouponApplied
                                        ? promoController.text = ' '
                                        : promoController.clear();
                                  });
                                } else {
                                  toast(
                                      text: AppLocalizations.of(context)!
                                          .promotoverify,
                                      toastPosition:
                                          EasyLoadingToastPosition.center);
                                }
                              },
                              text: AppLocalizations.of(context)!.apply,
                              width: customWidth(context: context, width: .3),
                              height:
                                  customHeight(context: context, height: .04),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .015),
          ),
          Consumer<CartControllers>(
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subtotalReusable(
                    text: AppLocalizations.of(context)!.subtotal,
                    money: value.subTotal.toStringAsFixed(2)),
                // subtotalReusable(text: 'Tax & Fee', money: '0'),
                subtotalReusable(
                    text: AppLocalizations.of(context)!.deliverycharges,
                    money: '0'),
                value.isCouponApplied
                    ? subtotalReusable(
                        text: AppLocalizations.of(context)!.discountammount,
                        money: value.couponMoney.toStringAsFixed(2),
                        color: Color(0XFF70C043))
                    : Container(),
                CustomSizedBox(
                  height: customHeight(context: context, height: .03),
                ),
                const DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
                subtotalReusable(
                    text: AppLocalizations.of(context)!.total,
                    money: value.grandTotal.toStringAsFixed(2),
                    fontsize: 25),
              ],
            ),
          ),
          Divider(
            color: tDividerColor,
          ),
          CustomPadding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                const CustomPadding(
                    padding: EdgeInsets.only(right: 8),
                    child: CustomImage(image: cart_cash_image)),
                CustomText(
                  text: AppLocalizations.of(context)!.paymentmethod,
                  color: tTextSecondaryColor,
                )
              ],
            ),
          ),
          Consumer<CartControllers>(
            builder: (context, value, child) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Theme(
                    data: ThemeData(
                        unselectedWidgetColor: thomepagecategoriesColor),
                    child: Radio(
                      value: 1,
                      groupValue: value.isSelectedVal,
                      activeColor: const Color(0XFF7F8B1F),
                      onChanged: (val) {
                        value.updateSelectedValues(val ?? 0);
                      },
                    ),
                  ),
                ),
                CustomTap(
                  onTap: () {
                    Provider.of<CartControllers>(context, listen: false)
                        .updateSelectedValues(1);
                  },
                  child: CustomText(
                    text: AppLocalizations.of(context)!.cash,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Flexible(
                  child: Theme(
                    data: ThemeData(
                        unselectedWidgetColor: thomepagecategoriesColor),
                    child: Radio(
                      value: 2,
                      groupValue: value.isSelectedVal,
                      activeColor: const Color(0XFF7F8B1F),
                      onChanged: (val) {
                        value.updateSelectedValues(val ?? 0);
                      },
                    ),
                  ),
                ),
                CustomTap(
                  onTap: () {
                    Provider.of<CartControllers>(context, listen: false)
                        .updateSelectedValues(2);
                  },
                  child: CustomText(
                    text: AppLocalizations.of(context)!.payonline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          CustomSizedBox(
            height: customHeight(context: context, height: .03),
          ),
          CustomButton(
            text: AppLocalizations.of(context)!.placeorder,
            onTap: () async {
              if (isTapped) {
                isTapped = false;
                var adressDetails = await Provider.of<LocationControllers>(
                    context,
                    listen: false);
                var carts =
                    await Provider.of<CartControllers>(context, listen: false);
                if (adressDetails.getSelectedAdressIdFromPrefs != 0) {
                  if (carts.isSelectedVal != 0) {
                    if (carts.grandTotal >= carts.minumumVal) {
                      if (carts.isSelectedVal == 1) {
                        await Provider.of<CartControllers>(context,
                                listen: false)
                            .createOrder(context: context);
                      } else {
                        var grandTotal = carts.grandTotal;
                        await carts.orderPayment(grandTotal, context);
                        await openCheckout();
                      }
                    } else {
                      toast(
                          text:
                              '${AppLocalizations.of(context)!.minumumordermorethan} ${carts.minumumVal.toStringAsFixed(2)}',
                          toastPosition: EasyLoadingToastPosition.center);
                    }
                  } else {
                    toast(
                        text: AppLocalizations.of(context)!.pleaseselectpayment,
                        toastPosition: EasyLoadingToastPosition.center);
                  }
                } else {
                  toast(
                      text: AppLocalizations.of(context)!.pleaseselectaddress,
                      toastPosition: EasyLoadingToastPosition.center);
                }
                isTapped = true;
              }
            },
          )
        ],
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Provider.of<CartControllers>(context, listen: false)
        .createOrder(context: context);
  }

  openCheckout() async {
    await Provider.of<ProfileController>(context, listen: false)
        .getUserDetails();
    var cartData = Provider.of<CartControllers>(context, listen: false);
    var userDetails = Provider.of<ProfileController>(context, listen: false);
    var contact = userDetails.userDetailsModel?.user.mobileNumber;
    var emailID = userDetails.userDetailsModel?.user.emailId;
    var options = {
      'key': razopay_key,
      'order_id': cartData.orderAPiResponse,
      'amount': cartData.grandTotal,
      'name': 'Anaj Bazaar',
      'description': 'Order Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': contact, 'email': emailID},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Widget subtotalReusable(
      {required String text,
      required String money,
      double? fontsize,
      Color? color}) {
    return CustomPadding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            fontWeight: FontWeight.w700,
            color: tTextSecondaryColor,
            fontSize: fontsize,
          ),
          CustomText(
            text: '₹$money',
            fontWeight: FontWeight.w700,
            color: color ?? tTextSecondaryColor,
            fontSize: fontsize,
          )
        ],
      ),
    );
  }

  Widget deliveryADress() {
    return Container(
      color: tProductsbgColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Consumer<LocationControllers>(
        builder: (context, value, child) =>
            value.getSelectedAdressIdFromPrefs == 0
                ? CustomTap(
                    onTap: () {
                      Routes().pushroute(
                          context: context,
                          pages: MyAdressesScreen(
                            isfromAddADress: true,
                            whenNoAdress: false,
                          ));
                    },
                    child: Row(
                      children: [
                        CustomText(
                          text: AppLocalizations.of(context)!.pleaseaddaddress,
                          fontWeight: FontWeight.w700,
                          color: tTextSecondaryColor,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomImage(image: cart_location_image),
                      CustomSizedBox(
                        width: customWidth(context: context, width: .05),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: CustomText(
                                    text: AppLocalizations.of(context)!
                                        .deliveryto,
                                    color: tPinkColor,
                                  ),
                                ),
                                CustomText(
                                  text: value.homePgeadressUserName,
                                  color: tTextSecondaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ],
                            ),
                            CustomText(
                              text:
                                  '${value.homePageadress1}, ${value.homePgeupdatedAdress}',
                              color: tPinkColor,
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ),
                      CustomTap(
                        onTap: () {
                          Routes().pushroute(
                              context: context,
                              pages: MyAdressesScreen(
                                isfromAddADress: true,
                                whenNoAdress: false,
                              ));
                        },
                        child: CustomText(
                          text: AppLocalizations.of(context)!.change,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: tButtonColor,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
