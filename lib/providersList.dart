import 'package:anaj_bazar/Controllers/authControllers.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Controllers/introControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Controllers/orderControllers.dart';
import 'package:anaj_bazar/Controllers/productControllers.dart';
import 'package:anaj_bazar/Controllers/profileControllers.dart';
import 'package:anaj_bazar/language.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providersList(AppLanguage appLanguage) {
  return [
    ChangeNotifierProvider(
      create: (_) => appLanguage,
    ),
    ChangeNotifierProvider(
      create: (context) => IntroControllers(),
    ),
    ChangeNotifierProvider(
      create: (context) => AppLanguage(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthControllers(),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeControllers(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProductsController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProfileController(),
    ),
    ChangeNotifierProvider(
      create: (context) => CartControllers(),
    ),
    ChangeNotifierProvider(
      create: (context) => LocationControllers(),
    ),
    ChangeNotifierProvider(
      create: (context) => OrdersControllers(),
    ),
  ];
}
