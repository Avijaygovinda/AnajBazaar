import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Constants/networkImage.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Controllers/productControllers.dart';
import 'package:anaj_bazar/Model/categorybyid.dart';
import 'package:anaj_bazar/Screens/Products/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customDialoguebox.dart';
import '../../Constants/customNavigation.dart';
import 'mycart.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, required this.productId, required this.isMultipleVarients});
  final int productId;
  final bool isMultipleVarients;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    products = Provider.of<ProductsController>(context, listen: false);
    getProductsList();
    cartControllers = Provider.of<CartControllers>(context, listen: false);

    homeControllers = Provider.of<HomeControllers>(context, listen: false);

    isMultipleVarients = widget.isMultipleVarients;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      products.updateMultiVarients(isMultipleVarients);
    });
  }

  ProductsController products = ProductsController();

  getProductsList() async {
    products.resetValues();
    await products.resetProductByCategory(true);
    await products.getProductsDetailsdata(widget.productId, false, context);
    isAddbtn = products.quantityIncart == 0 ? false : true;

    if (products.variantIncart == 0) {
      isNewItem = true;
    } else {
      isMultipleVarients = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        products.updateMultiVarients(isMultipleVarients);
      });
    }
    await products.setIsALreadyAddedQuantity();
  }

  bool isMultipleVarients = false;
  bool isNewItem = false;

  bool isAddbtn = false;

  var dropddowntypeValue2;

  bool isHandleQuantity = false;

  HomeControllers homeControllers = HomeControllers();
  CartControllers cartControllers = CartControllers();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(text: '', context: context),
          backgroundColor: tPrimaryColor,
          body: Container(
            height: customHeight(context: context, height: 1),
            child: Stack(alignment: Alignment.topCenter, children: [
              productsDetails(),
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

  Widget dropdownBox2({
    required String text,
    required List<Variant> variants,
  }) {
    return DropdownButtonFormField(
      isExpanded: true,
      icon: Icon(Icons.expand_more),
      iconEnabledColor: tTextSecondaryColor,
      iconDisabledColor: tTransparrentColor,
      items: variants.map((category) {
        return DropdownMenuItem(
            onTap: () {
              Provider.of<ProductsController>(context, listen: false)
                  .updateVarients(category, false);
            },
            value: category,
            child: FittedBox(
              child: CustomText(
                  text: '${category.metricValue} ${category.metricType}',
                  fontWeight: FontWeight.w600,
                  color: tTextSecondaryColor,
                  fontSize: 17),
            ));
      }).toList(),
      onChanged: (newValue) {},
      value: dropddowntypeValue2,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: tTextColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: tTextColor),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: tTextColor),
          ),
          hintText: text,
          hintStyle: customTextstyle(
              fontWeight: FontWeight.w600,
              color: tTextSecondaryColor,
              fontSize: 17),
          isDense: true),
    );
  }

  Widget itemDetails(Product products, ProductsController productsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPadding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: CustomText(
            text: products.productName,
            fontWeight: FontWeight.w500,
            color: tTextSecondaryColor,
            fontSize: 20,
          ),
        ),
        CustomTap(
          onTap: () {
            products.variants.length > 1
                ? bottomSheet(
                    productsController, products.productId, products.variants)
                : null;
          },
          child: Row(
            children: [
              CustomPadding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: CustomText(
                  text:
                      '${productsController.metricValue} ${productsController.metricType}',
                  fontWeight: FontWeight.w500,
                  color: tTextSecondaryColor,
                  fontSize: 17,
                ),
              ),
              products.variants.length > 1
                  ? Icon(Icons.expand_more)
                  : Container()
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomPadding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  CustomText(
                    text: '₹${productsController.sellingMoneyOriginal} ',
                    fontWeight: FontWeight.w600,
                    color: tTextSecondaryColor,
                    fontSize: 17,
                  ),
                  productsController.sellingMoneyOriginal ==
                          productsController.discountMoneyOriginal
                      ? Container()
                      : CustomText(
                          text: '₹${productsController.discountMoneyOriginal}',
                          fontWeight: FontWeight.w500,
                          color: tPinkColor,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 17,
                        ),
                  productsController.percentage == 0
                      ? Container()
                      : CustomPadding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: CustomText(
                              textAlign: TextAlign.center,
                              text:
                                  '${productsController.percentage.toStringAsFixed(0)}% OFF',
                              fontSize: 12,
                              color: tPrimaryColor,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0XFF643D22),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          )),
                ],
              ),
            ),
            isMultipleVarients || productsController.isMultipleVarients
                ? Flexible(
                    child: CustomTap(
                      onTap: () {
                        bottomSheet(productsController, products.productId,
                            products.variants);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF078200)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                          child: Row(
                            children: [
                              CustomText(
                                text:
                                    '${productsController.varientsLength.toString()} ${AppLocalizations.of(context)!.options}',
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
                : addAndremoveContainer(productsController)
          ],
        ),
        CustomPadding(
          padding: const EdgeInsets.only(bottom: 5, top: 20),
          child: CustomText(
            text: AppLocalizations.of(context)!.productdetails,
            fontWeight: FontWeight.w700,
            color: tTextSecondaryColor,
            fontSize: 20,
          ),
        ),
        CustomText(
          text: products.description,
          color: tTextSecondaryColor,
          fontSize: 15,
        ),
      ],
    );
  }

  Future bottomSheet(
      ProductsController value, productId, List<Variant> variants) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Color(0XFF000000).withOpacity(.4),
      backgroundColor: tPrimaryColor,
      elevation: 10,
      useRootNavigator: true,
      builder: (BuildContext context) {
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
                          text:
                              value.productsById?.products[0].productName ?? '',
                          fontWeight: FontWeight.w600,
                          color: tPinkColor,
                          fontSize: 20,
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
                            fontSize: 18,
                          ),
                        ),
                        listofVarients(
                            value.productsById?.products[0].variants ?? [],
                            value),
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
                                text: value.radioselectedtype.toString(),
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
                                        '₹${value.radioSelectedMoney.toString()}',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: tTabColor,
                                  ),
                                ],
                              ),
                              CustomTap(
                                onTap: () async {
                                  isMultipleVarients = false;
                                  isAddbtn = true;
                                  Provider.of<ProductsController>(context,
                                          listen: false)
                                      .updateMultiVarients(isMultipleVarients);
                                  Provider.of<ProductsController>(context,
                                          listen: false)
                                      .updateVarients(
                                          variants[value.isSelectedVal], false);
                                  customBottomsheet(
                                      value, false, false, true, true);

                                  Routes().backroute(
                                      context: context,
                                      value: value.isSelectedVarientId);
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

  Widget listofVarients(List<Variant> variants, ProductsController value) {
    return ListView.builder(
      itemCount: variants.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var varientDetails = variants[index];

        return RadioBtn(
          productsController: value,
          varientDetails: varientDetails,
          index: index,
        );
      },
    );
  }

  Widget addAndremoveContainer(ProductsController value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        !isAddbtn || value.isAddBtn
            ? CustomButton(
                onTap: () async {
                  isAddbtn = true;
                  value.updateIsAddbtn(isAddbtn);
                  customBottomsheet(value, true, true, false, false);

                  value.refreshValue();
                },
                borderRadius: BorderRadius.all(Radius.circular(5)),
                text: AppLocalizations.of(context)!.add,
                buttonColor: tTransparrentColor,
                textColor: thomepagecategoriesColor,
                border: Border.all(color: thomepagecategoriesColor),
                fontSize: 17,
                width: customWidth(context: context, width: .2),
                height: customHeight(context: context, height: .04),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: tPrimaryColor,
                  border: Border.all(color: thomepagecategoriesColor),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    CustomTap(
                      onTap: () async {
                        if (value.productQuantity >= 1) {
                          if (value.productQuantity <= 1) {
                            if (widget.isMultipleVarients) {
                              isMultipleVarients = true;
                            } else {
                              isAddbtn = false;
                            }
                          }
                          await customBottomsheet(
                              value, false, false, false, false);
                        } else {
                          if (widget.isMultipleVarients) {
                            isMultipleVarients = true;
                            customBottomsheet(value, true, false, false, false);
                          } else {
                            isAddbtn = false;
                            customBottomsheet(value, true, false, false, false);
                          }
                        }
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
                    CustomPadding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: CustomText(
                        text: value.productQuantity.toString(),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: thomepagecategoriesColor,
                      ),
                    ),
                    CustomTap(
                      onTap: () async {
                        customBottomsheet(value, true, false, false, false);
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
      ],
    );
  }

  customBottomsheet(
      ProductsController value,
      bool isIncrement,
      bool isAddbtnbottomsheet,
      bool isMulitpleVarientsbacktoOriginalStatge,
      bool isBottomsheetValue) async {
    if (isIncrement) {
      if (!isAddbtnbottomsheet) {
        await value.incrementQuantity();
      }
    } else {
      await value.decrementQuantity();
    }
    if (isBottomsheetValue) {
      await value.incrementQuantity();
    }

    if (value.productQuantity < value.availableQuanity) {
      var productId = int.parse(value.productId);
      var variantId = value.varientId;
      var categoryId = value.productsById?.products[0].categoryId ?? 0;

      var quantity = value.productQuantity;

      if (quantity == 0) {
        isHandleQuantity = true;
        await value.setProductQuantityOne(1);
      }

      var cartId = cartControllers.cartItemsModel?.cart.length != 0
          ? cartControllers.cartItemsModel?.cart[0].cartId
          : 0;
      var isWherehouseChanged;
      bool isRejectedreplaceitem = false;

      if (cartControllers.wherehouseIdforcartscheck !=
          homeControllers.whereHouseUserID) {
        await dialogueboxopened().then((val) async {
          if (val == true) {
            isWherehouseChanged = true;
            print(quantity);
            if (quantity == 0) {
              isRejectedreplaceitem = false;
            } else {
              await value.setProductQuantityOne(1);
              quantity = value.productQuantity;
            }
          } else {
            if (widget.isMultipleVarients) {
              value.updateVarients(value.variantfromProductDetails!, true);
            }

            isRejectedreplaceitem = true;

            if (isIncrement) {
              if (!widget.isMultipleVarients) {
                await Provider.of<ProductsController>(context, listen: false)
                    .decrementQuantity();

                print(quantity);
                if (isAddbtn) {
                  if (quantity == 0) {
                    isAddbtn = false;
                    await value.incrementQuantity();
                  } else {
                    if (isNewItem) {
                      isAddbtn = false;
                      await value.incrementQuantity();
                    }
                  }
                }
              } else {
                await value.setProductQuantityOne(value.productQuantity);
              }
            } else {
              isMultipleVarients = false;
              if (!widget.isMultipleVarients) {
                if (isHandleQuantity) {
                  if (quantity == 1) {
                    await value.incrementQuantity();
                  }
                } else {
                  isAddbtn = false;
                  await value.incrementQuantity();
                }

                if (quantity <= 1) {
                  isAddbtn = true;
                } else {
                  isAddbtn = true;
                }
              } else {
                await value.setProductQuantityOne(value.productQuantity);
              }
            }
            if (isMulitpleVarientsbacktoOriginalStatge) {
              isMultipleVarients = false;
              isAddbtn = true;
            }
            value.refreshValue();
          }
        });
      } else {
        isWherehouseChanged = false;
      }

      print(quantity);
      print('quantity');
      !isRejectedreplaceitem
          ? await Provider.of<CartControllers>(context, listen: false)
              .addToCart(
                  productId,
                  variantId,
                  quantity,
                  false,
                  isWherehouseChanged,
                  cartId ?? 0,
                  true,
                  false,
                  categoryId,
                  context)
          : null;
    }
  }

  customcircleAvatar(String text, Color color, void Function() onTap) {
    return CustomTap(
      onTap: onTap,
      child: CircleAvatar(
        radius: 13,
        backgroundColor: color,
        child: CustomText(
          text: text,
          fontWeight: FontWeight.bold,
          color: tPrimaryColor,
          fontSize: 25,
        ),
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

  Widget productsDetails() {
    return CustomPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<ProductsController>(
        builder: (context, value, child) {
          return value.iscategoryLoading
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : value.productsById?.products == null
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.errloading),
                      ),
                    )
                  : value.productsById?.products.isEmpty ??
                          value.productsById?.products == null
                      ? CustomSizedBox(
                          height: size(context: context).height * .7,
                          child: Center(
                            child: CustomText(
                                text: AppLocalizations.of(context)!.nodata),
                          ),
                        )
                      : Column(
                          children: [
                            CustomNetworkImage(
                              image: value.productsById?.products[0].imageUrl ??
                                  '',
                              height:
                                  customHeight(context: context, height: .35),
                              width: customWidth(context: context, width: 1),
                              fit: BoxFit.contain,
                            ),
                            CustomSizedBox(
                              height:
                                  customHeight(context: context, height: .05),
                            ),
                            itemDetails(value.productsById!.products[0], value),
                            CustomSizedBox(
                              height:
                                  customHeight(context: context, height: .035),
                            ),
                          ],
                        );
        },
      ),
    );
  }
}
