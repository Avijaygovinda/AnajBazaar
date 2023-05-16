import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Model/categorybyid.dart';
import 'package:anaj_bazar/Services/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsController extends ChangeNotifier {
  int _productsQuantity = 1;
  int get productQuantity => _productsQuantity;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _iscategoryLoading = false;
  bool get iscategoryLoading => _iscategoryLoading;
  CategoryByIdModel? categoryByIdModel;
  CategoryByIdModel? productsById;
  HomeControllers? homeControllers;
  int wherehouseId = 0;
  int availableQuanity = 0;
  String _productId = '0';
  int _varientId = 0;
  int _varientsLength = 0;
  double _sellingMoney = 0;
  String _metricType = '';
  String _metricValue = '';
  String get productId => _productId;
  int get varientId => _varientId;
  int get varientsLength => _varientsLength;
  String get metricType => _metricType;
  String get metricValue => _metricValue;
  double _sellingMoneyOriginal = 0;
  double _discountMoneyOriginal = 0;
  double get sellingMoney => _sellingMoney;
  double get sellingMoneyOriginal => _sellingMoneyOriginal;
  double get discountMoneyOriginal => _discountMoneyOriginal;
  double _discountMoney = 0;
  double _percentage = 0;
  double get percentage => _percentage;
  double get discountMoney => _discountMoney;
  Variant? variantfromProductDetails;
  int _quantityIncart = 0;
  int get quantityIncart => _quantityIncart;
  int _variantIncart = 0;
  int get variantIncart => _variantIncart;
  int _varientIdInCart = 0;
  int get varientIdInCart => _varientIdInCart;
  //categoryById

  bool _isSliderOpen = false;
  bool get isSliderOpen => _isSliderOpen;
  bool _isMoreVarients = false;
  bool get isMoreVarients => _isMoreVarients;
  bool _isAddBtn = false;
  bool get isAddBtn => _isAddBtn;
  bool _isMultipleVarients = false;
  bool get isMultipleVarients => _isMultipleVarients;

  int _isSelectedVal = 0;
  int get isSelectedVal => _isSelectedVal;
  int _isSelectedVarientId = 0;
  int get isSelectedVarientId => _isSelectedVarientId;
  int _isupdatedVarientId = 0;
  int get isupdatedVarientId => _isupdatedVarientId;
  double _radioselectedMoney = 0;
  double get radioSelectedMoney => _radioselectedMoney;
  String _radioselectedtype = '';
  String get radioselectedtype => _radioselectedtype;
  updateSelectedValues(int isVal, double money,
      String selectedMetricTypeandValue, int varientId) {
    _isSelectedVal = isVal;
    _radioselectedMoney = money;
    _radioselectedtype = selectedMetricTypeandValue;
    _isSelectedVarientId = varientId;
    notifyListeners();
  }

  updateVarient(int varientId) {
    _isupdatedVarientId = varientId;
    notifyListeners();
  }

  updateIsAddbtn(bool isVal) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isAddBtn = false;
      notifyListeners();
    });
  }

  updateMultiVarients(bool val) {
    _isMultipleVarients = val;
    print(_isMoreVarients);
    notifyListeners();
  }

  updateLoader(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  updatemoreVarient(bool val) {
    _isMoreVarients = val;
    notifyListeners();
  }

  refreshValue() {
    notifyListeners();
  }

  setRadioBtn(int isVal) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isSelectedVal = isVal;
      notifyListeners();
    });
  }

  setQuantityForProductsPage(
      int val, bool isDeleteproductDetailsFromCart, context) {
    _productsQuantity = val;
    if (isDeleteproductDetailsFromCart) {
      if (varientsLength > 1) {
        _isMultipleVarients = true;
      } else {
        _isAddBtn = true;
      }

      // resetValues();
      // getProductsDetailsdata(int.parse(_productId), false, context);
    }
    notifyListeners();
  }

  incrementQuantity() {
    if (_productsQuantity >= availableQuanity) {
      toast(text: "Available Quantity Limit Exceeded");
    } else {
      _productsQuantity++;
      // _sellingMoneyOriginal = _sellingMoney * _productsQuantity;
      // _discountMoneyOriginal = _discountMoney * _productsQuantity;
    }

    notifyListeners();
  }

  setIsALreadyAddedQuantity() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (quantityIncart != 0) {
        _productsQuantity = quantityIncart;
        _sellingMoneyOriginal = _sellingMoney;
        _discountMoneyOriginal = _discountMoney;
        // _sellingMoneyOriginal = _sellingMoney * _productsQuantity;
        // _discountMoneyOriginal = _discountMoney * _productsQuantity;
        notifyListeners();
      }
    });
  }

  // setVarient(Variant varient) {
  //   updateVarients(varient);
  //   notifyListeners();
  // }

  updateVarients(Variant variants, bool isQuantityThere) {
    _sellingMoney = variants.sellingPrice;
    _discountMoney = variants.price;
    _metricType = variants.metricType;
    _productId = variants.productId.toString();
    _varientId = variants.variantId;
    _productsQuantity = isQuantityThere ? _quantityIncart : 1;
    _metricValue = variants.metricValue;
    _sellingMoneyOriginal = _sellingMoney;
    _discountMoneyOriginal = _discountMoney;
    availableQuanity = variants.availableQty;
    _percentage = (_discountMoney - _sellingMoney) / _discountMoney * 100;
    notifyListeners();
  }

  updateUndoChanges(Variant variants) {
    _sellingMoney = variants.sellingPrice;
    _discountMoney = variants.price;
    _metricType = variants.metricType;
    _productId = variants.productId.toString();
    _varientId = variants.variantId;
    _productsQuantity = _quantityIncart;
    _metricValue = variants.metricValue;
    _sellingMoneyOriginal = _sellingMoney;
    _discountMoneyOriginal = _discountMoney;
    availableQuanity = variants.availableQty;
    _percentage = (_discountMoney - _sellingMoney) / _discountMoney * 100;
    notifyListeners();
  }

  decrementQuantity() {
    _productsQuantity--;
    // _sellingMoneyOriginal = _sellingMoney * _productsQuantity;
    // _discountMoneyOriginal = _discountMoney * _productsQuantity;

    notifyListeners();
  }

  setProductQuantityOne(int val) {
    _productsQuantity = val;
    _sellingMoneyOriginal = _sellingMoney * _productsQuantity;
    _discountMoneyOriginal = _discountMoney * _productsQuantity;

    notifyListeners();
  }

  updateIsSlider(bool val, context) {
    _isSliderOpen = val;
    if (!val) {
      Routes().backroute(context: context);
    }
    notifyListeners();
  }

  updateRadioPreviouseValues(
      int selectedRadio, double selectedMoney, String selectedmetricValueType) {
    _isSelectedVal = selectedRadio;
    _radioselectedMoney = selectedMoney;
    _radioselectedtype = selectedmetricValueType;
    notifyListeners();
  }

  updateRadioMoney(double val) {
    _radioselectedMoney = val;
    notifyListeners();
  }

  resetProductByCategory(bool isInitState) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _radioselectedMoney = 0;
      _isSelectedVal = 0;
      _radioselectedtype = '';
      _quantityIncart = 0;
      _variantIncart = 0;
      _isAddBtn = false;
      if (varientsLength > 1) {
        _isMultipleVarients = true;
      }
      _isMoreVarients = false;
      productsById = null;
      if (isInitState) {
        _isSelectedVarientId = 0;
        _isSliderOpen = false;
      }
      notifyListeners();
    });
  }

  getCategorydata(int catID, bool stopLoading, context) async {
    homeControllers = Provider.of<HomeControllers>(context, listen: false);
    wherehouseId = homeControllers?.whereHouseUserID ?? 0;
    stopLoading ? null : _isLoading = true;

    await ProductsServices()
        .getCategorybyIdData(catID, wherehouseId)
        .then((value) async {
      categoryByIdModel = value;
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    stopLoading ? null : _isLoading = false;
    notifyListeners();
  }

  getProductsDetailsdata(int productId, bool isNotLoader, context) async {
    homeControllers = Provider.of<HomeControllers>(context, listen: false);
    wherehouseId = homeControllers?.whereHouseUserID ?? 0;
    !isNotLoader ? _iscategoryLoading = true : null;
    await ProductsServices()
        .getProductbyIdData(productId, wherehouseId)
        .then((value) async {
      debugPrint(value.toString());
      productsById = value;
      if (value.products.isNotEmpty) {
        var varients = value.products[0].variants[0];
        _sellingMoney = varients.sellingPrice;
        _discountMoney = varients.price;
        _metricType = varients.metricType;
        _metricValue = varients.metricValue;
        _varientId = varients.variantId;
        _productId = varients.productId.toString();
        _radioselectedMoney = _sellingMoney;
        _radioselectedtype = '${varients.metricValue} ${varients.metricType}';
        _varientsLength = value.products[0].variants.length;
        _sellingMoneyOriginal = _sellingMoney;
        _quantityIncart = value.products[0].quantityIncart;
        _variantIncart = value.products[0].variantIncart;
        _discountMoneyOriginal = _discountMoney;
        availableQuanity = varients.availableQty;
        _percentage = (_discountMoney - _sellingMoney) / _discountMoney * 100;
        for (var i = 0; i < value.products[0].variants.length; i++) {
          var varients = value.products[0].variants[i];
          if (variantIncart == varients.variantId) {
            variantfromProductDetails = varients;
            _metricValue = varients.metricValue;
            _metricType = varients.metricType;
            _sellingMoney = varients.sellingPrice;
            _discountMoney = varients.price;
            _varientId = varients.variantId;
            _isSelectedVal = i;
            _radioselectedtype = '$_metricValue $_metricType';
            _radioselectedMoney = _sellingMoney;
          }
        }
      }
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    !isNotLoader ? _iscategoryLoading = false : null;
    notifyListeners();
  }

  resetValues() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productsQuantity = 1;
      _isAddBtn = false;
      notifyListeners();
    });
  }
}
