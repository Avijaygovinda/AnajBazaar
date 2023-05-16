import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Controllers/productControllers.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:anaj_bazar/Model/cartitems.dart';
import 'package:anaj_bazar/Model/minumumAmmount.dart';
import 'package:anaj_bazar/Screens/Products/confirmation.dart';
import 'package:anaj_bazar/Services/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/customToast.dart';
import '../Services/products.dart';
import 'homeControllers.dart';
import 'locationControllers.dart';

class CartControllers extends ChangeNotifier {
  int _isSelectedVal = 0;
  int wherehouseId = 0;
  int wherehouseIdforcartscheck = 0;
  int get isSelectedVal => _isSelectedVal;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  CartItemsModel? cartItemsModel;
  HomeControllers? homeControllers;
  int _itemsLength = 0;
  List<CartItem> orderItems = [];
  int get itemsLength => _itemsLength;
  double _subTotal = 0;
  int cartIds = 0;
  int _storeCartId = 0;
  int get storeCartId => _storeCartId;
  String promoCode = '';
  double get subTotal => _subTotal;
  double _grandTotal = 0;
  double get grandTotal => _grandTotal;
  double _couponMoney = 0;
  double get couponMoney => _couponMoney;
  String _couponAppliedmsg = '';
  String get couponAppliedmsg => _couponAppliedmsg;
  double _sellingPrice = 0;
  double get sellingPrice => _sellingPrice;
  double _price = 0;
  double get price => _price;
  String _OrderApiResponse = '';
  String get orderAPiResponse => _OrderApiResponse;
  bool _isCouponApplied = false;
  bool get isCouponApplied => _isCouponApplied;
  //check minumum Ammount
  CheckMinumumAmmount? checkMinumumAmmount;
  double _minumumVal = 0;
  double get minumumVal => _minumumVal;

  updateSelectedValues(int isVal) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('_isSelectedVal', isVal);
    _isSelectedVal = isVal;
    getSelectedValues();
    notifyListeners();
  }

  updateCartIdStoring(int val) {
    _storeCartId = val;
    notifyListeners();
  }

  getSelectedValues() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _isSelectedVal = await pref.getInt('_isSelectedVal') ?? 1;
    notifyListeners();
  }

  updatePromo(bool isVal) {
    _isCouponApplied = isVal;
    _grandTotal = _subTotal;
    notifyListeners();
  }

  ProductsController productsController = ProductsController();

  addToCart(
      int productId,
      int variantId,
      int quantity,
      bool isCartScreen,
      bool isChangedWherehouse,
      int cartId,
      bool isProductsScreen,
      bool isProductsRemoveSnackbar,
      int categoryId,
      context) async {
    if (isChangedWherehouse) {
      await deleteCart(cartId, context);
    }

    var res =
        await ProductsServices().addtoCart(productId, variantId, quantity);
    productsController =
        await Provider.of<ProductsController>(context, listen: false);
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      if (isCartScreen) {
        getCartItems(context, true, false);
        productsController.updateLoader(true);
        productsController.setQuantityForProductsPage(quantity, false, context);
        // productsController.getProductsDetailsdata(productId, true, context);
        await productsController.getCategorydata(categoryId, false, context);
      } else {
        getCartItems(context, true, false);
        if (!isProductsScreen) {
          toast(text: res['Message']);
        } else {
          if (!isProductsRemoveSnackbar) {
            productsController.updateLoader(true);
            await productsController.getCategorydata(
                categoryId, false, context);
            // final snackBar = await SnackBar(
            //   duration: Duration(seconds: 1),
            //   content: Text(res['Message']),
            // );
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      }
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  getminumumAmmount() async {
    _isLoading = true;
    await ProductsServices().checkMinumumAmmountFromapi().then((value) async {
      checkMinumumAmmount = value;
      if (value.status == 1) {
        if (value.config.isNotEmpty) {
          var keyCheck =
              value.config.map((e) => e.configKey == 'minOrderValue').toList();

          if (keyCheck[0] == true) {
            var configVal = value.config.map((e) => e.configValue).toList();

            _minumumVal = double.parse(configVal[0].toString());
          }
        }
      }
    }).catchError((onError) {
      toast(text: 'Error Occured!!!');
    });
    _isLoading = false;
    notifyListeners();
  }

  orderPayment(double orderAmount, context) async {
    var res = await OrdersService().orderPayment(orderAmount);
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      _OrderApiResponse = res['razorpayOrderId'];
      // toast(text: res['Message']);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  deleteCartItem(int productId, int variantId, CartControllers cartControllers,
      int categoryId, context) async {
    var res = await ProductsServices().deletecartItems(productId, variantId);
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      if (cartControllers.cartItemsModel?.cart[0].cartItems.length == 1) {
        await cartControllers.deleteCart(
            cartControllers.cartItemsModel?.cart[0].cartId ?? 0, context);
      } else {
        getCartItems(context, true, false);
      }

      productsController.updateLoader(true);

      await productsController.getCategorydata(categoryId, false, context);
      productsController.setQuantityForProductsPage(1, true, context);
      toast(text: res['Message']);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  verifyPromo(String promo, context) async {
    var res = await ProductsServices().verifyPromo(promo, _grandTotal);
    debugPrint(res.toString());
    if (res != null && res['status'] == 1) {
      promoCode = promo;
      var discountValue = res['disountAmount'];
      _couponAppliedmsg = res['Message'];
      _isCouponApplied = true;
      _grandTotal = _subTotal - discountValue;
      _couponMoney = _grandTotal - _subTotal;

      toast(
          text: res['Message'], toastPosition: EasyLoadingToastPosition.center);
    } else {
      _isCouponApplied = false;
      toast(
          text: res['Message'], toastPosition: EasyLoadingToastPosition.center);
    }
    notifyListeners();
  }

  createOrder({context}) async {
    var adressDetails =
        await Provider.of<LocationControllers>(context, listen: false);
    var user = await Provider.of<ProfileController>(context, listen: false);
    user.getUserDetails();
    var addressId = adressDetails.homePgeadressId;
    var name = adressDetails.homePgeadressUserName;
    var address1 = adressDetails.homePageadress1;
    var landmark;
    // if (adressDetails.homePagestreetName.contains(',')) {
    landmark = adressDetails.homePagestreetName;
    // } else {
    //   landmark = adressDetails.homePagestreetName;
    // }

    var address2 = landmark;

    var city = adressDetails.homePagecityName;
    var state = adressDetails.homePagestateName;
    var pincode = adressDetails.homePagepincode;
    var contactNumber = adressDetails.homePgeContact;
    var latitude = adressDetails.homePageLat;
    var longitude = adressDetails.homePageLong;
    var cartId = cartIds;
    var discount = couponMoney;
    var subTotal = _subTotal;
    var promoAmount = couponMoney;
    var deliveryCharges = 0.0;
    var grandTotal = _grandTotal;
    var promocode = promoCode;
    var paymentType = _isSelectedVal;
    var emailId = user.userDetailsModel?.user.emailId ?? '';
    var warehouseId = wherehouseId;
    var OrderItems = orderItems;
    // print(landmark);
    // print(city);
    // print(state);
    var res = await ProductsServices().createOrder(
        cartId,
        addressId,
        name,
        address1,
        address2,
        '',
        city,
        state,
        pincode,
        contactNumber,
        latitude,
        longitude,
        discount,
        subTotal,
        promoAmount,
        deliveryCharges,
        grandTotal,
        promocode,
        paymentType,
        emailId,
        _OrderApiResponse,
        warehouseId,
        OrderItems);
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      Routes().pushroute(
          context: context,
          pages: ConfirmationScreen(
            orderID: res['OrderID'],
          ));

      toast(text: res['Message']);
      getCartItems(context, true, false);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  deleteCart(int cartId, context) async {
    debugPrint(cartId.toString());
    var res = await ProductsServices().deleteCart(cartId);
    debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      getCartItems(context, false, false);
      // toast(text: res['Message']);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  getWhrehousePrefDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    wherehouseIdforcartscheck = pref.getInt('wherehouseIdforcartscheck') ?? 0;

    notifyListeners();
  }

  getCartItems(context, bool isincreasequantitynoloading,
      bool isWhereHouseChanged) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    homeControllers = Provider.of<HomeControllers>(context, listen: false);
    wherehouseId = homeControllers?.whereHouseUserID ?? 0;

    isincreasequantitynoloading ? null : _isLoading = true;
    await ProductsServices().getCarts(wherehouseId).then((value) async {
      debugPrint(value.toString());
      cartItemsModel = value;
      if (value.cart.isNotEmpty) {
        if (value.cart[0].cartItems.isNotEmpty) {
          if (value.cart[0].cartItems[0].quantity == 0 || isWhereHouseChanged) {
            cartIds = value.cart[0].cartId;
            await deleteCart(cartIds, context);
          }

          wherehouseIdforcartscheck = value.cart[0].cartItems[0].warehouseId;

          orderItems = cartItemsModel?.cart[0].cartItems ?? [];
          _itemsLength = cartItemsModel?.cart[0].cartItems.length ?? 0;

          pref.setInt('wherehouseIdforcartscheck', wherehouseIdforcartscheck);

          cartIds = value.cart[0].cartId;
          _subTotal = value.cart[0].cartItems
              .map((e) => e.sellingPrice * e.quantity)
              .sum;
          _grandTotal = _subTotal;
          await getWhrehousePrefDetails();
        } else {
          cartIds = value.cart[0].cartId;
          await deleteCart(cartIds, context);
        }
      } else {
        _itemsLength = 0;
        pref.setInt('wherehouseIdforcartscheck', wherehouseId);
        await getWhrehousePrefDetails();
      }
    })
        // .catchError((onError) {
        //   toast(text: 'Error Occured!!');
        // })
        ;
    isincreasequantitynoloading ? null : _isLoading = false;
    notifyListeners();
  }

  resetValues() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _isSelectedVal = 0;
      _isCouponApplied = false;

      notifyListeners();
    });
  }
}
