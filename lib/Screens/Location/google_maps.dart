import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import 'addlocation.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen(
      {super.key,
      required this.lat,
      required this.long,
      required this.isfromEditScreen,
      required this.id,
      required this.isFromSearch});
  final double lat;
  final double long;
  final bool isfromEditScreen;
  final int id;
  final bool isFromSearch;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  late GoogleMapController googleMapController;
  @override
  void initState() {
    super.initState();
    Provider.of<LocationControllers>(context, listen: false).resetValues();
    Provider.of<LocationControllers>(context, listen: false).resetValuespanel();
    controllers = Provider.of<LocationControllers>(context, listen: false);
  }

  LocationControllers controllers = LocationControllers();

  PanelController panelController = PanelController();
  bool isMaptype = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          floatingActionButton: Consumer<LocationControllers>(
            builder: (context, value, child) => CustomPadding(
              padding:
                  EdgeInsets.only(bottom: size(context: context).height * .52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      isMaptype = !isMaptype;
                      Provider.of<LocationControllers>(context, listen: false)
                          .isMaptypeUpdate(isMaptype);
                    },
                    child: const CustomPadding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.layers_sharp,
                          color: tPrimaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await value.handlekeyboardOpenAdressFetching(true);
                      var position = await GeolocatorPlatform.instance
                          .getCurrentPosition();

                      await Provider.of<LocationControllers>(context,
                              listen: false)
                          .currentLocation(googleMapController,
                              position.latitude, position.longitude);
                      // await value.handlekeyboardOpenAdressFetching(false);
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),
          ),
          body: googleMapContainer(),
        ),
      ),
    );
  }

  Widget googleMapContainer() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Consumer<LocationControllers>(builder: (context, value, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.lat, widget.long), zoom: 14.0),
                markers: Set.of(value.myMarker),
                mapType: value.isMaptype ? MapType.normal : MapType.hybrid,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                indoorViewEnabled: true,
                myLocationButtonEnabled: false,
                onTap: (argument) async {
                  value.handlekeyboardOpenAdressFetching(true);
                  await value.handletap(argument);
                },
                onMapCreated: (GoogleMapController controller) async {
                  // if (widget.isFromSearch || widget.isfromEditScreen) {}
                  googleMapController = controller;
                  value.getAdressFromlatLong(widget.lat, widget.long,
                      widget.isFromSearch, widget.isfromEditScreen);
                  // googleMapController.animateCamera(
                  //     CameraUpdate.newCameraPosition(CameraPosition(
                  //         target: LatLng(widget.lat, widget.long),
                  //         zoom: 14.4746)));

                  value.markers.clear();

                  value.markers.add(Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(widget.lat, widget.long),
                      icon: BitmapDescriptor.defaultMarker));
                },
              );
            }),
            Positioned(
                top: 10,
                left: 10,
                child: CustomTap(
                    onTap: () {
                      Routes().backroute(context: context);
                    },
                    child: Icon(Icons.arrow_back_ios_new))),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SlidingUpPanel(
                  controller: panelController,
                  minHeight: customHeight(context: context, height: .47),
                  maxHeight: customHeight(context: context, height: .47),
                  panel: Consumer<LocationControllers>(
                      builder: (context, value, child) => CustomPadding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomSizedBox(
                                      height: customHeight(
                                          context: context, height: .005),
                                    ),
                                    CustomText(
                                      text: AppLocalizations.of(context)!
                                          .selectdeliverylocation,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: tTabColor,
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: tDividerColor,
                                    ),
                                    CustomSizedBox(
                                      height: customHeight(
                                          context: context, height: .002),
                                    ),
                                  ],
                                ),
                                AddLocationsSCreen(
                                    lat: widget.lat,
                                    long: widget.long,
                                    isfromSearch: widget.isFromSearch,
                                    id: widget.id,
                                    isfromEdit: widget.isfromEditScreen)
                              ],
                            ),
                          ))),
              // )
            ),
          ],
        ))
      ],
    );
  }
}
