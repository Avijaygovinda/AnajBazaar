import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Model/cartitems.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Constants/customImage.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customPadding.dart';
import '../../Constants/customSizedBox.dart';
import '../../Constants/customTap.dart';
import '../../Constants/customText.dart';
import '../../Constants/images.dart';
import '../../Constants/networkImage.dart';

class CartListDetails extends StatefulWidget {
  const CartListDetails(
      {super.key,
      required this.cartItem,
      required this.sellingPrice,
      required this.price,
      required this.cartControllers,
      required this.index});
  final CartItem cartItem;
  final double sellingPrice;
  final double price;
  final CartControllers cartControllers;
  final int index;

  @override
  State<CartListDetails> createState() => _CartListDetailsState();
}

class _CartListDetailsState extends State<CartListDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          color: tProductsbgColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomNetworkImage(
                      image: widget.cartItem.imageUrl,
                      height: customHeight(context: context, height: .12),
                      width: customWidth(context: context, width: .3),
                      fit: BoxFit.contain,
                    ),
                    CustomSizedBox(
                      width: customWidth(context: context, width: .05),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.cartItem.productName,
                            color: tTextSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            overflow: TextOverflow.ellipsis,
                          ),
                          CustomPadding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: CustomText(
                              text:
                                  '${widget.cartItem.metricValue} ${widget.cartItem.metricType}',
                              color: tPinkColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              CustomText(
                                text:
                                    '₹ ${widget.sellingPrice.toStringAsFixed(2)} ',
                                fontWeight: FontWeight.w700,
                                color: tTextSecondaryColor,
                                fontSize: 13,
                              ),
                              widget.sellingPrice == widget.price
                                  ? Container()
                                  : CustomText(
                                      text:
                                          '₹ ${widget.price.toStringAsFixed(2)}',
                                      fontWeight: FontWeight.w700,
                                      color: tPinkColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 13,
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CustomTap(
                onTap: () async {
                  var productId = widget.cartItem.productId;
                  var variantId = widget.cartItem.variantId;
                  var categoryId = widget.cartItem.categoryId;
                  await widget.cartControllers.deleteCartItem(productId,
                      variantId, widget.cartControllers, categoryId, context);
                },
                child: const CustomPadding(
                    padding: EdgeInsets.only(right: 8),
                    child: CustomImage(image: delete_image)),
              )
            ],
          ),
          Positioned(
              right: 10,
              bottom: 0,
              child: addAndremoveContainer(
                  widget.cartItem, widget.cartControllers, widget.index))
        ],
      ),
    );
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

  Widget addAndremoveContainer(
      CartItem cartItems, CartControllers cartControllers, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        customcircleAvatar('-', const Color(0XFFD3DB24), () async {
          var productId = cartItems.productId;
          var categoryId = cartItems.categoryId;
          var variantId = cartItems.variantId;
          var quantity = cartItems.quantity;
          quantity--;
          if (quantity < 1) {
            await cartControllers.deleteCartItem(
                productId, variantId, cartControllers, categoryId, context);
          } else {
            await cartControllers.addToCart(productId, variantId, quantity,
                true, false, 0, false, false, categoryId, context);
          }
        }),
        CustomPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomText(
            text: '${cartItems.quantity}',
            fontWeight: FontWeight.w700,
          ),
        ),
        customcircleAvatar('+', tTabColor, () async {
          var productId = cartItems.productId;
          var variantId = cartItems.variantId;
          var categoryId = cartItems.categoryId;
          var quantity = cartItems.quantity;
          quantity++;
          if (quantity > cartItems.availableQty) {
            toast(text: 'Available Quantity Limit Exceeded!!');
          } else {
            await cartControllers.addToCart(productId, variantId, quantity,
                true, false, 0, false, false, categoryId, context);
          }
        }),
      ],
    );
  }
}
