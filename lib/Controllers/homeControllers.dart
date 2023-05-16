import 'dart:async';

import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Model/categoryTab.dart';
import 'package:anaj_bazar/Model/coupons.dart';
import 'package:anaj_bazar/Model/homeTab.dart';
import 'package:anaj_bazar/Model/notifications.dart';
import 'package:anaj_bazar/Screens/Location/myAdresses.dart';
import 'package:anaj_bazar/Services/tabs.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Constants/colors.dart';
import '../Constants/customDialoguebox.dart';
import '../Constants/customMediaQuery.dart';
import '../Constants/customNavigation.dart';
import '../Constants/customPadding.dart';
import '../Constants/customSizedBox.dart';
import '../Constants/customTap.dart';
import '../Constants/customText.dart';
import '../Constants/customToast.dart';

class HomeControllers extends ChangeNotifier {
  int _pageIndex = 0;
  bool _isLocationEnabled = true;
  bool get isLocationEnabled => _isLocationEnabled;
  int get pageIndex => _pageIndex;
  Position? _currentPosition;
  String get currentAdressName => _currentAdressName;
  String get getToken => _getToken;
  String get fullAdress => _fullAddress;
  String _currentAdressName = "";
  String _fullAddress = "";
  String _currentAdressNameBackup = "";
  String _fullAddressBackup = "";
  String _getToken = "";
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _whereHouseUserID = 0;
  int get whereHouseUserID => _whereHouseUserID;
  double _lat = 0;
  double _long = 0;
  double get lat => _lat;
  double get long => _long;
  String onChangesText = '';
  List<dynamic> _productsList = [];
  List<dynamic> get productsList => _productsList;
  bool isAcceptLocationRequest = false;
  HomeTabModel? homeTabModel;
  CategoryTabModel? categoryTabModel;
  NotificationsModel? notificationsModel;
  CouponsModel? couponsModel;
  CartControllers? cartControllers;
  LocationControllers? locationControllers;
  bool isLocationAddedSucces = false;

  bool isLocationStatusDisabled = false;
  changeIndex(int val) {
    _pageIndex = val;
    notifyListeners();
  }

  onChangedTexts(String val) {
    onChangesText = val;
    notifyListeners();
  }

  resetSearchString() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productsList.clear();
      onChangesText = '';
      notifyListeners();
    });
  }

  changeLocationStatus(bool val) {
    _isLocationEnabled = val;
    notifyListeners();
  }

  getTokenupdate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _getToken = pref.getString('token') ?? '';
    notifyListeners();
  }

  final geolocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);

  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      notifyListeners();
      getAddressFromLatLng();
    }).catchError((e) {
      debugPrint(e.toString());
    });
    notifyListeners();
  }

  removePopUpInHomeScreen() {
    isLocationAddedSucces = true;
    notifyListeners();
  }

  StreamSubscription<loc.LocationData>? locationSubscription;
  checkgps(context) async {
    locationControllers =
        await Provider.of<LocationControllers>(context, listen: false);

    await locationControllers?.getAdress();

    try {
      loc.Location location = loc.Location();

      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;
      _serviceEnabled = await location.serviceEnabled();

      if (!_serviceEnabled) {
        await checkLocationenablesorNot(context).then((value) async {
          if (value == true) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              if (locationControllers?.getSelectedAdressIdFromPrefs == 0) {
                if (locationControllers?.addressModel?.address.isNotEmpty ??
                    locationControllers?.addressModel?.address.length != 0) {
                  locationControllers?.whenNoDataSelectedThenAddedAdress(
                      locationControllers?.addressModel);
                  await sendWherehouse(_lat, _long, true, context);
                } else {
                  isAcceptLocationRequest
                      ? null
                      : await dialogueboxopened(context, '');
                }
              } else {
                _lat = locationControllers?.homePageLat ?? 0;
                _long = locationControllers?.homePageLong ?? 0;
                await sendWherehouse(_lat, _long, true, context);
              }

              return;
            } else {
              isAcceptLocationRequest = true;
              if (locationControllers?.getSelectedAdressIdFromPrefs == 0) {
                await noAdressRedirectToADressScreen(
                    locationControllers, context);
                if (locationControllers?.addressModel?.address.length != 0) {
                  locationControllers?.whenNoDataSelectedThenAddedAdress(
                      locationControllers?.addressModel);
                }
              }

              notifyListeners();
            }
          }
        });

        // }

        if (locationControllers?.addressModel?.address.length != 0 ||
            locationControllers?.addressModel?.address.length != null) {
          if (locationControllers?.getSelectedAdressIdFromPrefs != 0) {
            _lat = locationControllers?.homePageLat ?? 0;
            _long = locationControllers?.homePageLong ?? 0;
          } else {
            if (locationControllers?.addressModel?.address.isEmpty ??
                locationControllers?.addressModel?.address.length == 0) {
              await checkLocationenablesorNot(context).then((value) {});
              var position =
                  await GeolocatorPlatform.instance.getCurrentPosition();
              _lat = position.latitude;
              _long = position.longitude;
            } else {
              _lat =
                  locationControllers?.addressModel?.address[0].latitude ?? 0;
              _long =
                  locationControllers?.addressModel?.address[0].longitude ?? 0;
            }
          }
        }
        await sendWherehouse(_lat, _long, true, context);
        return;
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        _serviceEnabled = await location.serviceEnabled();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return;
        }
      }

      var latStream;
      var longStream;
      await noAdressRedirectToADressScreen(locationControllers, context);
      // locationSubscription = location.onLocationChanged.listen((event) async {
      await checkLocationenablesorNot(context).then((value) {});
      var position = await GeolocatorPlatform.instance.getCurrentPosition();
      latStream = await position.latitude;
      longStream = await position.longitude;
      // });
      if (locationControllers?.addressModel?.address.length != 0) {
        if (locationControllers?.getSelectedAdressIdFromPrefs != 0) {
          _lat = locationControllers?.homePageLat ?? 0;
          _long = locationControllers?.homePageLong ?? 0;
        } else {
          _lat = latStream;
          _long = longStream;
        }
      } else {
        if (locationControllers?.addressModel?.address.isEmpty ??
            locationControllers?.addressModel?.address.length == 0) {
          await checkLocationenablesorNot(context).then((value) {});
          var position = await GeolocatorPlatform.instance.getCurrentPosition();
          _lat = position.latitude;
          _long = position.longitude;
        } else {
          _lat = locationControllers?.addressModel?.address[0].latitude ?? 0;
          _long = locationControllers?.addressModel?.address[0].longitude ?? 0;
        }
        // _lat = latStream;
        // _long = longStream;
      }

      // try {
      await sendWherehouse(_lat, _long, true, context);
      if (locationControllers?.getSelectedAdressIdFromPrefs == 0) {
        await locationControllers?.whenNoDataSelectedThenAddedAdress(
            locationControllers?.addressModel);
      }

      // await getHomedata(context, true);
      getCurrentLocation();
      // } catch (e) {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future checkLocationenablesorNot(
    context,
  ) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLocationStatusDisabled = true;
        dialogueboxopened(
            context, AppLocalizations.of(context)!.locationperminentlydenied);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Routes().backroute(context: context);
      isLocationStatusDisabled = true;
      // toast(
      //     text:
      //         'Location permissions are permanently denied, Please Accept in Settings');
      dialogueboxopened(
          context, AppLocalizations.of(context)!.locationperminentlydenied);

      return false;
    }
    notifyListeners();
    return true;
  }

  noAdressRedirectToADressScreen(
      LocationControllers? locationControllers, context) async {
    if (locationControllers?.addressModel?.address.isEmpty ??
        locationControllers?.addressModel?.address.length == 0) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MyAdressesScreen(
                    isfromAddADress: true,
                    whenNoAdress: true,
                  ))).then((value) {
        isLocationAddedSucces = true;
      });
      // await Routes().pushroute(
      //     context: context,
      //     pages: );
      await Provider.of<HomeControllers>(context, listen: false)
          .removePopUpInHomeScreen();
    }
  }

  Future dialogueboxopened(context, String text) {
    LocationPermission permission;
    return dialogueBox(
        context: context,
        barrierDismissible: false,
        title: CustomPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: size(context: context).height * .02,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.location,
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
                text: text == ''
                    ? AppLocalizations.of(context)!
                        .pleaseacceptlocationtofurther
                    : text,
                fontWeight: FontWeight.w500,
              ),
              CustomSizedBox(
                height: size(context: context).height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTap(
                    onTap: () async {
                      if (text != '') {
                        AppSettings.openAppSettings().then((value) async {
                          permission = await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission == LocationPermission.denied) {
                            } else {
                              isAcceptLocationRequest = true;
                              Routes().backroute(context: context);
                            }
                          } else {
                            isAcceptLocationRequest = true;
                            Routes().backroute(context: context);
                          }
                        });
                      } else {
                        await checkgps(context).then((val) {
                          if (isLocationAddedSucces) {
                            Routes().backroute(context: context);
                          }
                        });
                      }
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
                            text: AppLocalizations.of(context)!.accept,
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

  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      _currentAdressNameBackup = "${place.name}";
      _fullAddressBackup =
          "${place.subLocality} ${place.administrativeArea} ${place.locality}";
      updateBackuplocationData();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  updateBackuplocationData() {
    _currentAdressName = _currentAdressNameBackup;
    _fullAddress = _fullAddressBackup;
    notifyListeners();
  }

  getHomedata(context, bool callAfterWhereHouse, bool isLoderStop) async {
    if (callAfterWhereHouse) {
      cartControllers = Provider.of<CartControllers>(context, listen: false);

      isLoderStop ? null : _isLoading = true;
      await TabsServices()
          .getHomeTabData(_whereHouseUserID)
          .then((value) async {
        homeTabModel = value;
      }).catchError((onError) {
        toast(text: 'Error Occured!!');
      });
      isLoderStop ? null : _isLoading = false;
      notifyListeners();
    }
  }

  getCategorydata() async {
    _isLoading = true;
    await TabsServices().getCategoryTabData().then((value) async {
      categoryTabModel = value;
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    _isLoading = false;
    notifyListeners();
  }

  int notificationsLength = 0;

  getNotificationsdata() async {
    _isLoading = true;
    await TabsServices().getNotificationsTabData().then((value) async {
      notificationsModel = value;
      if (value.notifications.isNotEmpty) {
        notificationsLength = value.notifications.length;
      } else {
        notificationsLength = 0;
      }
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    _isLoading = false;
    notifyListeners();
  }

  getCouponsdata() async {
    _isLoading = true;
    await TabsServices().getCouponsTabData().then((value) async {
      couponsModel = value;
    }).catchError((onError) {
      toast(text: 'Error Occured!!');
    });
    _isLoading = false;
    notifyListeners();
  }

  sendWherehouse(
      double lat, double long, bool callAfterWhereHousehomeApi, context) async {
    var res = await TabsServices().sendWherehouse(lat, long);
    debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      _whereHouseUserID = await res['Warehouses']['warehouseId'];
      getHomedata(context, callAfterWhereHousehomeApi, true);

      notifyListeners();
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  clearNotifications() async {
    var res = await TabsServices().deleteNotifications();
    debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      toast(text: res['Message']);
      getNotificationsdata();
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  getSearchProducts(String productName) async {
    _isLoading = true;

    var res = await TabsServices()
        .searchProducts(_whereHouseUserID.toString(), productName);
    // debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      _productsList = res['Products'];
    } else {
      // toast(text: res['Message']);
    }
    _isLoading = false;
    notifyListeners();
  }

  resetValues() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageIndex = 0;
      _isLocationEnabled = true;
      // _whereHouseUserID = 0;
      notifyListeners();
    });
  }

  disposelocation() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      locationSubscription?.cancel();
      notifyListeners();
    });
  }
}
