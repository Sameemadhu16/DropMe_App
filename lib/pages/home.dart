import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_app_clone/global/global_var.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/night_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteDate = await rootBundle.load(mapStylePath);
    var list = byteDate.buffer
        .asUint8List(byteDate.offsetInBytes, byteDate.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(
      String googleMapStyle, GoogleMapController controller) async {
    controller.setMapStyle(googleMapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: googlePlexInitialPosition,
              onMapCreated: (GoogleMapController mapController) {
                controllerGoogleMap = mapController;
                updateMapTheme(controllerGoogleMap!);//use of null assertion operator100% sure that controllerGoogleMap is not null at this point
                googleMapCompleterController.complete(controllerGoogleMap);
              }),
        ],
      ),
    );
  }
}
