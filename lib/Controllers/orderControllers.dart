import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Model/currentorders.dart';
import 'package:anaj_bazar/Model/orderDetails.dart';
import 'package:anaj_bazar/Screens/Products/mycart.dart';
import 'package:anaj_bazar/Services/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/customNavigation.dart';
import '../Constants/customToast.dart';

class OrdersControllers extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  CurrentOrdersModel? currentOrdersModel;
  OrderDetailsModel? orderDetailsModel;
  CartControllers cartControllers = CartControllers();
  CurrentOrdersModel? pastOrdersModel;

  getCurrentOrders(bool isCurrent) async {
    _isLoading = true;
    await OrdersService().getcurrentOrders(isCurrent).then((value) async {
      debugPrint(value.toString());
      if (isCurrent) {
        currentOrdersModel = value;
      } else {
        pastOrdersModel = value;
      }
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    _isLoading = false;
    notifyListeners();
  }

  getOrdersDetails(int orderId) async {
    _isLoading = true;
    await OrdersService().getOrderDetails(orderId).then((value) async {
      debugPrint(value.toString());
      orderDetailsModel = value;
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    _isLoading = false;
    notifyListeners();
  }

  reOrder(int orderId, int warehouseId, context) async {
    var res = await OrdersService().reOrders(orderId, warehouseId);
    debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      cartControllers = Provider.of<CartControllers>(context, listen: false);
      cartControllers.getCartItems(context, false, false);
      toast(text: res['Message']);
      Routes().pushroutewithremove(
          context: context, pages: MyCartDetails(isFromMenuScreen: false));
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  cancelOrder(int orderId, String reason, context) async {
    var res = await OrdersService().cacnelOrder(orderId, reason);
    debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      cartControllers = Provider.of<CartControllers>(context, listen: false);
      cartControllers.getCartItems(context, false, false);
      toast(text: res['Message']);

      await getCurrentOrders(true);
      // await getCurrentOrders(false);
      Routes().backroute(context: context, value: true);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }
}
