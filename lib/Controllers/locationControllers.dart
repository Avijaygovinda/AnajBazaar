import 'dart:convert';

import 'package:anaj_bazar/Model/adressDetails.dart';
import 'package:anaj_bazar/Model/adresslist.dart';
import 'package:anaj_bazar/Services/location.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Constants/customNavigation.dart';
import '../Constants/customToast.dart';
import '../Screens/Location/google_maps.dart';
import '../Services/Apis.dart';

class LocationControllers extends ChangeNotifier {
  int _isSelectedVal = 0;
  int get isSelectedVal => _isSelectedVal;
  String _adressName = '';
  String _updatedAdress = '';
  String _unchangesAddress = '';
  String _streetName = '';
  String _cityName = '';
  String _administartitveCity = '';
  String _stateName = '';
  String _pincode = '';
  double _lat = 0;
  double _long = 0;
  String get updatedAdress => _updatedAdress;
  String get unchangesAddress => _unchangesAddress;
  String get adressName => _adressName;
  String get streetName => _streetName;
  String get cityName => _cityName;
  String get administartitveCity => _administartitveCity;
  String get stateName => _stateName;
  String get pincode => _pincode;
  double get lat => _lat;
  double get long => _long;
  bool _isDefaultAdress = false;
  bool get isDefaultAdress => _isDefaultAdress;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  AddressModel? addressModel;
  AddressDetailsModel? addressDetailsModel;
  List<dynamic> _placeList = [];
  List<dynamic> get placeList => _placeList;
  String _sessionToken = '1234567890';
  bool _isOpened = true;
  bool get isOpened => _isOpened;
  bool _isSelectedMap = false;
  bool get isSelectedMap => _isSelectedMap;

  isPanelUpdate(bool val) {
    _isOpened = val;
    notifyListeners();
  }

  resetValuespanel() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isOpened = true;
      notifyListeners();
    });
  }

  double _latfromsearch = 0;
  double _longfromsearch = 0;

  int _selectedAdressOnTap = -1;
  int get selectedAdressOnTap => _selectedAdressOnTap;
  int _adressLength = 0;
  int get adressLength => _adressLength;

  //homePageSelectedLocation
  String _homePgeadressName = '';
  String _homePgeadressUserName = '';
  double _homePageLat = 0;
  double _homePageLong = 0;
  int _homePgeadressId = 0;
  String _homePagestreetName = '';
  String _homePagecityName = '';
  String _homePageadress1 = '';
  String _homePagestateName = '';
  String _homePagepincode = '';
  String _homePgeupdatedAdress = '';
  String _homePgeContact = '';
  String _homepageTitle = '';
  String get homePagestreetName => _homePagestreetName;
  String get homePagecityName => _homePagecityName;
  String get homePageadress1 => _homePageadress1;
  String get homePagestateName => _homePagestateName;
  String get homePagepincode => _homePagepincode;
  // double get homePagelat => _homePageLat;
  // double get homePagelong => _homePageLong;
  String get homePgeadressName => _homePgeadressName;
  String get homePagetitle => _homepageTitle;
  String get homePgeContact => _homePgeContact;
  String get homePgeadressUserName => _homePgeadressUserName;
  int get homePgeadressId => _homePgeadressId;
  double get homePageLat => _homePageLat;
  double get homePageLong => _homePageLong;
  String get homePgeupdatedAdress => _homePgeupdatedAdress;

  selectedAdress(int isVal, Map mapValuesAdress, context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _selectedAdressOnTap = isVal;
    _homePgeadressName = await mapValuesAdress['adressNamehomepage'];
    _homepageTitle = await mapValuesAdress['ADress1HomepageUpdated'];
    _homePgeupdatedAdress = await mapValuesAdress['fullAdresshomepage'];
    _homePgeadressId = await mapValuesAdress['adressIDhomepage'];
    await pref.setInt('_homePgeadressId', mapValuesAdress['adressIDhomepage']);
    await pref.setString(
        '_homePgeadressName', mapValuesAdress['adressNamehomepage']);
    await pref.setString(
        '_homePageadress1', mapValuesAdress['adressAdress1homepage']);
    await pref.setString(
        '_homepageTitle', mapValuesAdress['ADress1HomepageUpdated']);
    await pref.setString(
        '_homePgeadressUserName', mapValuesAdress['adressUsernamehomepage']);
    await pref.setString(
        '_homePgeupdatedAdress', mapValuesAdress['fullAdresshomepage']);

    await pref.setString(
        '_homePagestreetName', mapValuesAdress['adressLandmarkhomepage']);
    await pref.setString(
        '_homePgeContact', mapValuesAdress['adressContacthomepage']);

    await pref.setString(
        '_homePagecityName', mapValuesAdress['adressCityhomepage']);
    await pref.setString(
        '_homePagestateName', mapValuesAdress['adressStatehomepage']);
    await pref.setString(
        '_homePagepincode', mapValuesAdress['adressPincodehomepage']);
    await pref.setDouble('_homePageLat', mapValuesAdress['lathomepage']);
    await pref.setDouble('_homePageLong', mapValuesAdress['longhomepage']);
    await updatePrefAdress();
    Routes().backroute(context: context, value: true);
    notifyListeners();
  }

  whenNoDataSelectedThenAddedAdress(AddressModel? addressModel) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(
        '_homePgeadressName', "${addressModel?.address[0].address1 ?? ''}");
    await pref.setString('_homePgeupdatedAdress',
        "${addressModel?.address[0].address2 ?? ''}, ${addressModel?.address[0].city ?? ''}, ${addressModel?.address[0].state ?? ''}, ${addressModel?.address[0].pincode ?? ''}");
    await pref.setInt(
        '_homePgeadressId', addressModel?.address[0].userAddressId ?? 0);
    await pref.setString(
        '_homePgeadressUserName', addressModel?.address[0].name ?? '');
    await pref.setString(
        '_homePageadress1', addressModel?.address[0].address1 ?? '');
    await pref.setString(
        '_homePgeadressUserName', addressModel?.address[0].name ?? '');

    await pref.setString(
        '_homePagestreetName', addressModel?.address[0].landmark ?? '');
    await pref.setString(
        '_homePgeContact', addressModel?.address[0].contactNumber ?? '');

    await pref.setString(
        '_homePagecityName', addressModel?.address[0].city ?? '');
    await pref.setString(
        '_homePagestateName', addressModel?.address[0].state ?? '');
    await pref.setString(
        '_homePagepincode', addressModel?.address[0].pincode ?? '');
    await pref.setDouble(
        '_homePageLat', addressModel?.address[0].latitude ?? 0);
    await pref.setDouble(
        '_homePageLong', addressModel?.address[0].longitude ?? 0);
    updatePrefAdress();
    notifyListeners();
  }

  updateSelectedValues(int isVal) {
    _isSelectedVal = isVal;
    notifyListeners();
  }

  updateDefaultSelection(bool isVal) {
    _isDefaultAdress = isVal;
    notifyListeners();
  }

  handlekeyboardOpenAdressFetching(bool val) {
    _isSelectedMap = val;
    notifyListeners();
  }

  List<Marker> markers = [];
  BitmapDescriptor? icon;
  List<Marker> myMarker = [];
  Future getAdressFromlatLong(
    double latitude,
    double longitude,
    bool isFromSearch,
    bool isfromEditScreen,
  ) async {
    LatLng latLng = LatLng(latitude, longitude);
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    // print(placemark);
    Placemark place = placemark[0];
    debugPrint(place.toString());
    _adressName = place.name ?? '';
    _streetName = place.street ?? '';
    _cityName = place.subLocality ?? '';
    _administartitveCity = place.locality ?? '';
    _stateName = place.administrativeArea ?? '';
    _pincode = place.postalCode ?? '';
    _lat = latitude;
    _long = longitude;
    _updatedAdress =
        '${place.name == place.street ? place.name : '${place.name}, ${place.street}'}, ${place.subLocality},';
    _unchangesAddress =
        '${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
    notifyListeners();
    if (isFromSearch || isfromEditScreen) {
      myMarker = [];
      myMarker.add(
        Marker(
            markerId: MarkerId(latLng.toString()),
            position: latLng,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title:
                  '${place.name}${place.subLocality} ${place.locality}${place.administrativeArea} ${place.subAdministrativeArea} ${place.postalCode}',
            ),
            draggable: true,
            onDragEnd: (onenddraged) {
              latLng = onenddraged;
            }),
      );
    }
  }

  Future handletap(LatLng tappedpoint) async {
    List<Placemark> placem = await placemarkFromCoordinates(
        tappedpoint.latitude, tappedpoint.longitude);
    Placemark place = placem[0];
    _adressName = place.name ?? '';
    _streetName = place.street ?? '';
    _cityName = place.subLocality ?? '';
    _administartitveCity = place.administrativeArea ?? '';
    _stateName = place.locality ?? '';
    _pincode = place.postalCode ?? '';
    _lat = tappedpoint.latitude;
    _long = tappedpoint.longitude;
    _updatedAdress =
        '${place.name == place.street ? place.name : '${place.name}, ${place.street}'}, ${place.subLocality},';
    _unchangesAddress =
        '${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
    print(_unchangesAddress);
    notifyListeners();
    myMarker = [];
    myMarker.add(
      Marker(
          markerId: MarkerId(tappedpoint.toString()),
          position: tappedpoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title:
                '${place.name} ${place.subLocality} ${place.locality}${place.administrativeArea} ${place.subAdministrativeArea} ${place.postalCode}',
          ),
          draggable: true,
          onDragEnd: (onenddraged) {
            tappedpoint = onenddraged;
          }),
    );
    notifyListeners();

    return place;
  }

  bool _isMaptype = true;
  bool get isMaptype => _isMaptype;

  isMaptypeUpdate(bool val) {
    _isMaptype = val;
    notifyListeners();
  }

  currentLocation(
    GoogleMapController googleMapController,
    lat,
    long,
  ) {
    resetValues();
    getAdressFromlatLong(lat, long, false, false);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 15)));
  }

  Position? position;

  Future<Position> determinePosition(
      context,
      bool isfromsearch,
      bool isedit,
      double latfromEdit,
      double longfromEdit,
      int id,
      bool isfromSeachRedirect) async {
    bool serviceEnabled;
    LocationPermission permission;
    var lat = 0.0;
    var long = 0.0;
    // await checkLocations().then((value) {
    //   print(value);
    //   print('ddddddddddddddddddddddddddddddddddddddddddddddd');
    // });

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toast(text: 'Location Permissions are Denied..');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Routes().backroute(context: context);
      toast(text: 'Location Permissions are Denied');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      position = await Geolocator.getCurrentPosition();
      lat = position?.latitude ?? 0;
      long = position?.longitude ?? 0;

      var mapLatLong = {"lat": lat, "long": long, "position": position};

      isfromsearch
          ? Routes().backroute(context: context, value: mapLatLong)
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => GoogleMapsScreen(
                        id: id,
                        isFromSearch: isfromSeachRedirect,
                        isfromEditScreen: isedit ? true : false,
                        lat: isedit || isfromSeachRedirect ? latfromEdit : lat,
                        long:
                            isedit || isfromSeachRedirect ? longfromEdit : long,
                      ))).then((value) {
              if (value == true) {
                // if (isfromSeachRedirect) {
                //   Routes().backroute(context: context, value: true);
                // }
                if (isedit) {
                } else {
                  Routes().backroute(context: context, value: true);
                }
              }
            });

      return Future.error('Location services are disabled.');
    }

    position = await Geolocator.getCurrentPosition();
    lat = position?.latitude ?? 0;
    long = position?.longitude ?? 0;
    var mapLatLong = {"lat": lat, "long": long, "position": position};
    isfromsearch
        ? Routes().backroute(context: context, value: mapLatLong)
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => GoogleMapsScreen(
                      isFromSearch: isfromSeachRedirect,
                      id: id,
                      isfromEditScreen: isedit ? true : false,
                      lat: isedit || isfromSeachRedirect ? latfromEdit : lat,
                      long: isedit || isfromSeachRedirect ? longfromEdit : long,
                    ))).then((value) {
            if (value == true) {
              // if (isfromSeachRedirect) {
              //   Routes().backroute(context: context, value: true);
              // }
              if (isedit) {
              } else {
                Routes().backroute(context: context, value: true);
              }
            }
          });

    return position!;
  }

  void getSuggestion(String input) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';

      String request =
          '$baseURL?input=$input&key=$google_maps_key&sessiontoken=$_sessionToken&components=country:IN';

      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        // var data = json.decode(response.body);

        _placeList = json.decode(response.body)['predictions'];

        notifyListeners();
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // notifyListeners();
  }

  getCordinates(String placeId, context) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String request = '$baseURL?placeid=$placeId&key=$google_maps_key';
      // print(request);
      var response = await http.get(Uri.parse(request));
      // var data = json.decode(response.body);

      if (response.statusCode == 200) {
        _latfromsearch =
            json.decode(response.body)['result']['geometry']['location']['lat'];
        _longfromsearch =
            json.decode(response.body)['result']['geometry']['location']['lng'];
        determinePosition(
            context, false, false, _latfromsearch, _longfromsearch, 0, true);
        // GoogleMapsScreen(
        //     lat: _latfromsearch,
        //     long: _longfromsearch,
        //     position: position??0,
        //     isfromEditScreen: false,
        //     id: 0);
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      // toastMessage('success');
    }
  }

  jumpToSelectedLocation(
      GoogleMapController googleMapController, context) async {
    LatLng latLng = LatLng(_latfromsearch, _longfromsearch);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_latfromsearch, _longfromsearch), zoom: 15)));
    List<Placemark> placem =
        await placemarkFromCoordinates(_latfromsearch, _longfromsearch);
    Placemark place = placem[0];
    _adressName = place.name ?? '';
    _streetName = place.street ?? '';
    _cityName = place.subLocality ?? '';
    _administartitveCity = place.administrativeArea ?? '';
    _stateName = place.locality ?? '';
    _pincode = place.postalCode ?? '';
    _lat = _latfromsearch;
    _long = _latfromsearch;
    _updatedAdress =
        '${place.name == place.street ? place.name : '${place.name}, ${place.street}'}, ${place.subLocality},';
    _unchangesAddress =
        '${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
    notifyListeners();
    myMarker = [];
    myMarker.add(
      Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title:
                '${place.name} ${place.subLocality} ${place.locality}${place.administrativeArea} ${place.subAdministrativeArea} ${place.postalCode}',
          ),
          draggable: true,
          onDragEnd: (onenddraged) {
            latLng = onenddraged;
          }),
    );
    notifyListeners();
  }

  addAdress(String address1, String name, String contactNumber, String landmark,
      context, int adressId, bool isfromEdit) async {
    var isDefaulttoInt = 0;
    var adress1Updated;
    if (isfromEdit) {
      adress1Updated = address1;
    } else {
      adress1Updated = '$address1';
    }

    var landmarkafterComma;
    var administartitveCityafterComma;
    var stateNameafterComma;
    if (landmark.contains(',')) {
      landmarkafterComma = landmark.substring(0, landmark.length - 1);
    } else {
      landmarkafterComma = landmark;
    }
    if (administartitveCity.contains(',')) {
      administartitveCityafterComma =
          administartitveCity.substring(0, administartitveCity.length - 1);
    } else {
      administartitveCityafterComma = administartitveCity;
    }
    if (stateName.contains(',')) {
      stateNameafterComma = stateName.substring(0, stateName.length - 1);
    } else {
      stateNameafterComma = stateName;
    }

    var res = await LocationServices().addtoLocation(
        adress1Updated,
        landmarkafterComma,
        '$_adressName, $_cityName',
        administartitveCityafterComma,
        stateNameafterComma,
        pincode,
        isSelectedVal.toString(),
        name,
        contactNumber,
        isDefaulttoInt,
        lat,
        long,
        adressId,
        isfromEdit);

    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      getAdress();
      Routes().backroute(context: context, value: true);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  List<int> adresses = [];
  int _getSelectedAdressIdFromPrefs = 0;
  int get getSelectedAdressIdFromPrefs => _getSelectedAdressIdFromPrefs;

  updatePrefAdress() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _getSelectedAdressIdFromPrefs = pref.getInt('_homePgeadressId') ?? 0;
    _homePgeadressName = pref.getString('_homePgeadressName') ?? '';
    _homePgeupdatedAdress = pref.getString('_homePgeupdatedAdress') ?? '';
    _homePgeadressUserName = pref.getString('_homePgeadressUserName') ?? '';
    _homePageLat = pref.getDouble('_homePageLat') ?? 0;
    _homePageLong = pref.getDouble('_homePageLong') ?? 0;
    _homePagestreetName = pref.getString('_homePagestreetName') ?? '';
    _homePagecityName = pref.getString('_homePagecityName') ?? '';
    _homePagestateName = pref.getString('_homePagestateName') ?? '';
    _homePagepincode = pref.getString('_homePagepincode') ?? '';
    _homePageadress1 = pref.getString('_homePageadress1') ?? '';
    _homePgeContact = pref.getString('_homePgeContact') ?? '';

    notifyListeners();
  }

  removePrefAdress() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('_homePgeadressId');
    pref.remove('_homePgeadressName');
    pref.remove('_homePgeupdatedAdress');
    pref.remove('_homePgeadressUserName');
    pref.remove('_homePageLat');
    pref.remove('_homePageLong');
    pref.remove('_homePagestreetName');
    pref.remove('_homePagecityName');
    pref.remove('_homePagestateName');
    pref.remove('_homePagepincode');
    pref.remove('_homePageadress1');
    pref.remove('_homePgeContact');
    updatePrefAdress();
    notifyListeners();
  }

  getAdress() async {
    adresses.clear();
    _isLoading = true;
    await LocationServices().getAdressList().then((value) async {
      addressModel = value;
      var checkADress;
      if (value.address.isNotEmpty) {
        for (var i = 0; i < value.address.length; i++) {
          checkADress = value.address[i].userAddressId;
          adresses.add(checkADress);
        }

        if (!adresses.contains(_getSelectedAdressIdFromPrefs)) {
          removePrefAdress();
          _homePgeadressName = '';
          _homePgeupdatedAdress = '';
        }
      } else {
        removePrefAdress();
        _homePgeadressName = '';
        _homePgeupdatedAdress = '';
      }
      notifyListeners();
    })

        // .catchError((onError) {
        //   toast(text: 'Error Occured!!');
        // })
        ;
    _isLoading = false;
    notifyListeners();
  }

  getAdressDetails(int id) async {
    await LocationServices().getAdressDetails(id).then((value) async {
      addressDetailsModel = value;
    }).catchError((onError) {
      toast(text: 'Error Occured!!!');
    });
    notifyListeners();
  }

  deleteAdress(int addressId, context) async {
    var res = await LocationServices().deletecartItems(addressId);
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      getAdress();
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  // removePlaceLists() {
  //   // WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
  //   _placeList.clear();
  //   // });
  // }

  resetValues() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      myMarker.clear();
      markers.clear();
      _isDefaultAdress = false;
      _isSelectedVal = 0;
      // placeList.clear();
      _isSelectedMap = false;
      addressDetailsModel = null;
      notifyListeners();
    });
  }
}
