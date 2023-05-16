import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Constants/networkImage.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Controllers/productControllers.dart';
import 'package:anaj_bazar/Screens/Products/mycart.dart';
import 'package:anaj_bazar/Screens/Products/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customDialoguebox.dart';
import '../../Constants/customSizedBox.dart';
import '../../Model/categorybyid.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage(
      {super.key, required this.categoryId, required this.ProductName});
  final int categoryId;
  final String ProductName;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartControllers>(context, listen: false)
        .getCartItems(context, true, false);
    productsController =
        Provider.of<ProductsController>(context, listen: false);
    productsController.resetProductByCategory(true);
    productsController.getCategorydata(widget.categoryId, false, context);
  }

  ProductsController productsController = ProductsController();
  bool isSlideUp = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
              text: widget.ProductName, context: context, color: tPrimaryColor),
          backgroundColor: tPrimaryColor,
          body: Container(
            height: customHeight(context: context, height: 1),
            child: Stack(alignment: Alignment.topCenter, children: [
              itemsGridList(),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Consumer<CartControllers>(
                    builder: (context, value, child) => value.itemsLength < 1
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black, //New
                                  blurRadius: 20.0,
                                  spreadRadius: 7,
                                  offset: Offset(
                                    20,
                                    20,
                                  ),
                                ),
                              ],
                              color: tPrimaryColor,
                            ),
                            child: CustomPadding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImage(
                                        image: cart_image,
                                        height: 25,
                                      ),
                                      CustomPadding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 6),
                                        child: CustomText(
                                          text:
                                              '${value.itemsLength.toString()} ${AppLocalizations.of(context)!.item}',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: tTextSecondaryColor,
                                        ),
                                      ),
                                      CustomPadding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: CircleAvatar(
                                          radius: 4,
                                          backgroundColor: tTabColor,
                                        ),
                                      ),
                                      CustomText(
                                        text: '₹${value.grandTotal.toString()}',
                                        // '₹${value.radioSelectedMoney == 0 ? varientsFirstMoney : value.radioSelectedMoney.toString()}',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: tTabColor,
                                      ),
                                    ],
                                  ),
                                  CustomTap(
                                    onTap: () {
                                      Routes().pushroute(
                                          context: context,
                                          pages: MyCartDetails(
                                              isFromMenuScreen: true));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: tTabColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      padding: EdgeInsets.all(8),
                                      child: CustomText(
                                        text: AppLocalizations.of(context)!
                                            .viewcart,
                                        color: tPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Widget itemsGridList() {
    return Consumer<ProductsController>(
      builder: (context, value, child) {
        var products = value.categoryByIdModel?.products;

        return value.isLoading
            ? CustomSizedBox(
                height: size(context: context).height * .7,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : products == null
                ? CustomSizedBox(
                    height: size(context: context).height * .7,
                    child: Center(
                      child: CustomText(
                          text: AppLocalizations.of(context)!.errloading),
                    ),
                  )
                : products.isEmpty
                    ? CustomSizedBox(
                        height: size(context: context).height * .7,
                        child: Center(
                          child: CustomText(
                              text: AppLocalizations.of(context)!.nodata),
                        ),
                      )
                    : ListView.builder(
                        itemCount: products.length,
                        physics: BouncingScrollPhysics(),
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 35),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var productDetails = products[index];

                          return ProductsSelection(
                              productsController: productsController,
                              productDetails: productDetails);
                        },
                      );
      },
    );
  }
}

class ProductsSelection extends StatefulWidget {
  const ProductsSelection(
      {super.key,
      required this.productDetails,
      required this.productsController});
  final Product productDetails;
  final ProductsController productsController;

  @override
  State<ProductsSelection> createState() => _ProductsSelectionState();
}

class _ProductsSelectionState extends State<ProductsSelection> {
  @override
  void initState() {
    super.initState();

    cartControllers = Provider.of<CartControllers>(context, listen: false);

    homeControllers = Provider.of<HomeControllers>(context, listen: false);
    productsController =
        Provider.of<ProductsController>(context, listen: false);
    varientsList = widget.productDetails.variants;
    itemsName = widget.productDetails.productName;
    varientsLength = varientsList.length;
    isCheckVarientsLength =
        widget.productDetails.variants.length > 1 ? true : false;
    _discountMoney = widget.productDetails.variants[0].price;
    _sellingMoney = widget.productDetails.variants[0].sellingPrice;
    percentages = (_discountMoney - _sellingMoney) / _discountMoney * 100;
    productMetricTypeandValue =
        '${widget.productDetails.variants[0].metricValue} ${widget.productDetails.variants[0].metricType}';
    varientsFirstMoney = widget.productDetails.variants[0].sellingPrice;
    availableQty = widget.productDetails.variants[0].availableQty;
    updateAlreadyAddedQuantity();
  }

  updateAlreadyAddedQuantity() {
    if (widget.productDetails.quantityIncart != 0) {
      isItemAdded = true;
      productQuantity = widget.productDetails.quantityIncart;
      ismultipleVarientsSelected =
          widget.productDetails.variantIncart != 0 ? true : false;
      for (var i = 0; i < widget.productDetails.variants.length; i++) {
        var varients = widget.productDetails.variants[i];
        // print(varients);
        if (widget.productDetails.variantIncart == varients.variantId) {
          index = i;
          productMetricTypeandValue =
              '${varients.metricValue} ${varients.metricType}';
          _discountMoney = varients.price;
          _sellingMoney = varients.sellingPrice;
          percentages = (_discountMoney - _sellingMoney) / _discountMoney * 100;

          selectedVarient = i;
          selectedVal = i;
        }
      }
    } else {
      isItemAdded = false;
    }
  }

  int index = 0;

  bool isInitNotCalling = true;

  bool isAlredyQuantityAdded = false;

  int varientsLength = 0;
  bool isCheckVarientsLength = false;

  CartControllers cartControllers = CartControllers();
  HomeControllers homeControllers = HomeControllers();
  ProductsController productsController = ProductsController();

  int productQuantity = 1;
  bool isMoreVarients = false;
  bool isAlreadyOpened = false;
  var _discountMoney;
  var _sellingMoney;
  var percentages;
  var productMetricTypeandValue;
  var radioSelctedMetrictype;
  bool ismultipleVarientsSelected = false;
  final pagestorekey = const PageStorageKey<String>('controllerA');
  double selectedMoneyInBottomsheet = 0;

  List<Variant> varientsList = [];
  String itemsName = '';
  double varientsFirstMoney = 0;
  var selectedVal = 0;
  var selectedVarient = 0;
  bool isItemAdded = false;
  int availableQty = 0;
  @override
  Widget build(BuildContext context) {
    return CustomTap(
      onTap: () async {
        Routes().pushroute(
            context: context,
            pages: ProductDetailsScreen(
              isMultipleVarients:
                  widget.productDetails.variants.length > 1 ? true : false,
              productId: widget.productDetails.productId,
            ));
      },
      child: Consumer<ProductsController>(builder: (context, value, child) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                percentages == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(bottom: 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: CustomText(
                          textAlign: TextAlign.center,
                          text: '${percentages.toStringAsFixed(0)}% OFF',
                          fontSize: 12,
                          color: tPrimaryColor,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0XFF643D22),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                Row(
                  children: [
                    CustomPadding(
                      padding: EdgeInsets.only(right: 10),
                      child: CustomNetworkImage(
                        image: widget.productDetails.imageUrl,
                        height: customHeight(context: context, height: .08),
                        width: customWidth(context: context, width: .2),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.productDetails.productName,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: tTextSecondaryColor,
                          ),
                          CustomTap(
                            onTap: () async {
                              if (varientsLength > 1) {
                                await bottomSheet(_sellingMoney,
                                        productMetricTypeandValue)
                                    .then((val) async {
                                  if (val != null) {
                                    await quantityChangeItem(
                                        selectedVarient, true);
                                    value.refreshValue();
                                  }
                                });
                              }
                            },
                            child: CustomPadding(
                              padding: EdgeInsets.only(top: 5, bottom: 7),
                              child: Wrap(
                                children: [
                                  CustomText(
                                    text: productMetricTypeandValue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: tPinkColor,
                                  ),
                                  varientsLength > 1
                                      ? Icon(
                                          Icons.expand_more,
                                          size: 20,
                                          color: tTextColor,
                                        )
                                      : CustomText(text: '')
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CustomText(
                                text: '₹${_sellingMoney.toString()}',
                                fontWeight: FontWeight.w600,
                                color: tTextSecondaryColor,
                                fontSize: 15,
                              ),
                              _sellingMoney == _discountMoney
                                  ? Container()
                                  : CustomPadding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: FittedBox(
                                        child: CustomText(
                                          text: '₹${_discountMoney.toString()}',
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 12,
                                          color: tPinkColor,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomPadding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    thickness: .5,
                    color: Colors.black.withOpacity(.2),
                  ),
                )
              ],
            ),
            varientsLength > 1 && !ismultipleVarientsSelected
                ? CustomPadding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: CustomTap(
                      onTap: () async {
                        await bottomSheet(
                                _sellingMoney, productMetricTypeandValue)
                            .then((val) async {
                          if (val != null) {
                            await quantityChangeItem(selectedVarient, true);
                            value.refreshValue();
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF078200)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.all(5),
                        height: customHeight(context: context, height: .04),
                        child: FittedBox(
                          child: Row(
                            children: [
                              CustomText(
                                text:
                                    '${varientsLength.toString()} ${AppLocalizations.of(context)!.options}',
                                fontWeight: FontWeight.w700,
                                color: Color(0XFF078200),
                              ),
                              Icon(
                                Icons.expand_more,
                                color: Color(0XFF078200),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : CustomTap(
                    onTap: () async {
                      isItemAdded = true;
                      value.refreshValue();
                      if (productQuantity < availableQty) {
                        await quantityChangeItem(selectedVarient, true);
                      } else {
                        toast(
                            text: AppLocalizations.of(context)!
                                .availablequantityexceeded);
                      }
                    },
                    child: CustomPadding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: !isItemAdded
                          ? CustomButton(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              text: AppLocalizations.of(context)!.add,
                              textColor: thomepagecategoriesColor,
                              fontSize: 17,
                              buttonColor: tTransparrentColor,
                              border:
                                  Border.all(color: thomepagecategoriesColor),
                              width: customWidth(context: context, width: .2),
                              height:
                                  customHeight(context: context, height: .04),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: tTransparrentColor,
                                border:
                                    Border.all(color: thomepagecategoriesColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Wrap(
                                children: [
                                  CustomTap(
                                    onTap: () async {
                                      productQuantity--;
                                      if (productQuantity < 1) {
                                        ismultipleVarientsSelected = false;
                                        isItemAdded = false;
                                        await quantityChangeItem(
                                            selectedVarient, false);
                                        productQuantity = 1;
                                      } else {
                                        await quantityChangeItem(
                                            selectedVarient, true);
                                      }
                                      value.refreshValue();
                                    },
                                    child: CustomPadding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: CustomText(
                                        text: '-',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: thomepagecategoriesColor,
                                      ),
                                    ),
                                  ),
                                  CustomText(
                                    text: productQuantity.toString(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: thomepagecategoriesColor,
                                  ),
                                  CustomTap(
                                    onTap: () async {
                                      if (productQuantity < availableQty) {
                                        productQuantity++;
                                        await quantityChangeItem(
                                            selectedVarient, true);

                                        value.refreshValue();
                                      } else {
                                        toast(
                                            text: AppLocalizations.of(context)!
                                                .availablequantityexceeded);
                                      }
                                    },
                                    child: CustomPadding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: CustomText(
                                        text: '+',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: thomepagecategoriesColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
          ],
        );
      }),
    );
  }

  quantityChangeItem(int selectedVarientIndex, bool isNagitiveQuantity) async {
    var productId =
        widget.productDetails.variants[selectedVarientIndex].productId;
    var categoryId = widget.productDetails.categoryId;
    var variantId =
        widget.productDetails.variants[selectedVarientIndex].variantId;

    var quantity = productQuantity;
    var cartId = cartControllers.cartItemsModel?.cart.length != 0
        ? cartControllers.cartItemsModel?.cart[0].cartId
        : 0;
    var isWherehouseChanged;
    bool isRejectedreplaceitem = false;
    if (isNagitiveQuantity) {
      // _discountMoney = widget.productDetails.variants[selectedVarient].price *
      //     productQuantity;
      // _sellingMoney =
      //     widget.productDetails.variants[selectedVarient].sellingPrice *
      //         productQuantity;
      _discountMoney = widget.productDetails.variants[selectedVarient].price;
      _sellingMoney =
          widget.productDetails.variants[selectedVarient].sellingPrice;
      percentages = (_discountMoney - _sellingMoney) / _discountMoney * 100;
      productMetricTypeandValue =
          '${widget.productDetails.variants[selectedVarient].metricValue} ${widget.productDetails.variants[selectedVarient].metricType}';
    }

    // print(cartControllers.wherehouseIdforcartscheck);
    // print(homeControllers.whereHouseUserID);
    if (cartControllers.itemsLength != 0) {
      if (cartControllers.wherehouseIdforcartscheck !=
          homeControllers.whereHouseUserID) {
        await dialogueboxopened().then((value) {
          if (value == true) {
            isWherehouseChanged = true;
          } else {
            isItemAdded = false;
            ismultipleVarientsSelected = false;
            Provider.of<ProductsController>(context, listen: false)
                .refreshValue();
            isRejectedreplaceitem = true;
          }
        });
      } else {
        isWherehouseChanged = false;
      }
    } else {
      isWherehouseChanged = false;
    }

    !isRejectedreplaceitem
        ? await Provider.of<CartControllers>(context, listen: false).addToCart(
            productId,
            variantId,
            quantity,
            false,
            isWherehouseChanged,
            cartId ?? 0,
            true,
            true,
            categoryId,
            context)
        : null;
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
                text: AppLocalizations.of(context)!.replacecart,
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
                text: AppLocalizations.of(context)!.cnfrmreplacecart,
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
                      text: AppLocalizations.of(context)!.cancel,
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
                            text: AppLocalizations.of(context)!.replace,
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

  Widget listofVarients(List<Variant> variants) {
    return ListView.builder(
      itemCount: variants.length,
      key: pagestorekey,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var varientDetails = variants[index];
        return CustomTap(
          onTap: () {
            radioSelctedMetrictype =
                '${varientDetails.metricValue} ${varientDetails.metricType}';
            selectedVal = index;
            selectedMoneyInBottomsheet = varientDetails.sellingPrice;
            selectedVarient = index;
            availableQty = varientDetails.availableQty;
            Provider.of<ProductsController>(context, listen: false)
                .refreshValue();
          },
          child: Row(
            children: [
              CustomPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Consumer<ProductsController>(
                  builder: (context, value, child) => Radio(
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    value: index,
                    groupValue: selectedVal,
                    onChanged: (val) async {
                      selectedVal = val!;
                      selectedMoneyInBottomsheet = varientDetails.sellingPrice;
                      selectedVarient = val;
                      radioSelctedMetrictype =
                          '${varientDetails.metricValue} ${varientDetails.metricType}';
                      availableQty = varientDetails.availableQty;
                      value.refreshValue();
                    },
                    focusColor: tTabColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // hoverColor: tPinkColor,
                    activeColor: tTabColor,
                  ),
                ),
              ),
              CustomPadding(
                padding: EdgeInsets.only(left: 5, right: 20),
                child: CustomText(
                  text:
                      '${varientDetails.metricValue} ${varientDetails.metricType}',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: tTextSecondaryColor,
                ),
              ),
              Row(
                children: [
                  CustomText(
                    text: '₹${varientDetails.sellingPrice.toStringAsFixed(2)}',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: tPinkColor,
                  ),
                  CustomPadding(
                    padding: EdgeInsets.only(left: 5),
                    child: CustomText(
                      text: '₹${varientDetails.price.toStringAsFixed(2)}',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: tPinkColor,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future bottomSheet(double money, String metricValAndType) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Color(0XFF000000).withOpacity(.4),
      backgroundColor: tPrimaryColor,
      elevation: 10,
      useRootNavigator: true,
      builder: (BuildContext context) {
        selectedMoneyInBottomsheet = money;
        radioSelctedMetrictype = metricValAndType;
        return Consumer<ProductsController>(builder: (context, value, child) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Wrap(
                children: [
                  CustomPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: CustomTap(
                            onTap: () {
                              Provider.of<ProductsController>(context,
                                      listen: false)
                                  .updateIsSlider(false, context);
                            },
                            child: CustomPadding(
                              padding: EdgeInsets.only(top: 10),
                              child: CustomImage(
                                image: slide_up_cancel,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                        CustomText(
                          text: AppLocalizations.of(context)!.selectquantity,
                          fontWeight: FontWeight.w600,
                          color: tTextSecondaryColor,
                          fontSize: 18,
                        ),
                        CustomSizedBox(
                          height: customHeight(context: context, height: .016),
                        ),
                        CustomText(
                          text: itemsName,
                          fontWeight: FontWeight.w600,
                          color: tPinkColor,
                          fontSize: 17,
                        ),
                        CustomSizedBox(
                          height: customHeight(context: context, height: .02),
                        ),
                        CustomPadding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: CustomText(
                            text: AppLocalizations.of(context)!.choosevarient,
                            fontWeight: FontWeight.w700,
                            color: tTextSecondaryColor,
                            fontSize: 16,
                          ),
                        ),
                        listofVarients(
                          varientsList,
                        ),
                        CustomSizedBox(
                          height: customHeight(context: context, height: .01),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: customWidth(context: context, width: 1),
                    height: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black, //New
                          blurRadius: 20.0,
                          spreadRadius: 7,
                          offset: Offset(
                            20,
                            20,
                          ),
                        ),
                      ],
                      color: tPrimaryColor,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CustomPadding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CustomPadding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: radioSelctedMetrictype.toString(),
                                fontWeight: FontWeight.w600,
                                color: tTextSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: tDividerColor,
                        ),
                        CustomPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomImage(
                                    image: cart_image,
                                    height: 25,
                                  ),
                                  CustomPadding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    child: CustomText(
                                      text: AppLocalizations.of(context)!
                                          .itemtotal,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: tTextSecondaryColor,
                                    ),
                                  ),
                                  CustomPadding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: tTabColor,
                                    ),
                                  ),
                                  CustomText(
                                    text:
                                        '₹${selectedMoneyInBottomsheet.toString()}',
                                    // '₹${value.radioSelectedMoney == 0 ? varientsFirstMoney : value.radioSelectedMoney.toString()}',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: tTabColor,
                                  ),
                                ],
                              ),
                              CustomTap(
                                onTap: () {
                                  ismultipleVarientsSelected = true;
                                  productQuantity = 1;
                                  isItemAdded = true;
                                  productMetricTypeandValue =
                                      radioSelctedMetrictype;
                                  Routes().backroute(
                                      context: context, value: selectedVarient);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: tTabColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.all(8),
                                  child: CustomText(
                                    text: AppLocalizations.of(context)!.additem,
                                    color: tPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }
}

class RadioBtn extends StatefulWidget {
  const RadioBtn(
      {super.key,
      required this.varientDetails,
      required this.index,
      required this.productsController});
  final Variant varientDetails;
  final int index;
  final ProductsController productsController;

  @override
  State<RadioBtn> createState() => _RadioBtnState();
}

class _RadioBtnState extends State<RadioBtn> {
  @override
  void initState() {
    super.initState();
  }

  var metricvalueAndType;
  var sellingPrice;
  var price;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsController>(builder: (context, value, child) {
      return CustomTap(
        onTap: () {
          var metricvalueAndType =
              '${widget.varientDetails.metricValue} ${widget.varientDetails.metricType}';
          value.updateSelectedValues(
              widget.index,
              widget.varientDetails.sellingPrice,
              metricvalueAndType,
              widget.varientDetails.variantId);
        },
        child: Row(
          children: [
            CustomPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Radio(
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                value: widget.index,
                groupValue: value.isSelectedVal,
                onChanged: (val) async {
                  metricvalueAndType =
                      '${widget.varientDetails.metricValue} ${widget.varientDetails.metricType}';
                  // sellingPrice = widget.varientDetails.sellingPrice;
                  // price = widget.varientDetails.price;
                  value.updateSelectedValues(
                      val!,
                      widget.varientDetails.sellingPrice,
                      metricvalueAndType,
                      widget.varientDetails.variantId);
                },
                focusColor: tTabColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                hoverColor: tPinkColor,
                activeColor: tTabColor,
              ),
            ),
            CustomPadding(
              padding: EdgeInsets.only(left: 5, right: 20),
              child: CustomText(
                text:
                    '${widget.varientDetails.metricValue} ${widget.varientDetails.metricType}',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: tTextSecondaryColor,
              ),
            ),
            Row(
              children: [
                CustomText(
                  text:
                      '₹${widget.varientDetails.sellingPrice.toStringAsFixed(2)}',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: tPinkColor,
                ),
                CustomPadding(
                  padding: EdgeInsets.only(left: 5),
                  child: CustomText(
                    text: '₹${widget.varientDetails.price.toStringAsFixed(2)}',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: tPinkColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
