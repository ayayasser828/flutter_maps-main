import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/constnats/strings.dart';
import 'package:flutter_maps/helpers/location_helper.dart';
import 'package:flutter_maps/presentation/widgets/custom_button.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  static String currentAddress = '';
  const MapScreen({Key? key}) : super(key: key);


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? name;
  String? street;
  String? locality;
  String? administrativeArea;
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  static Position? position;
  Completer<GoogleMapController> _mapController = Completer();

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  /// function to get the current location from location helper class
  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  /// function to navigate to my location
  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  ///function to get current position then convert it to address
  void getAddress() async {
    await getMyCurrentLocation();
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    print('latitude' + currentPosition.latitude.toString());
    print('longitude' + currentPosition.longitude.toString());

    List<Placemark> placeMarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark placeMark = placeMarks[0];
    String? street = placeMark.street;
    String? locality = placeMark.locality;

    String? administrativeArea = placeMark.administrativeArea;

    String address = " $street,$locality, $administrativeArea";
    setState(() {
      MapScreen.currentAddress = address;
    });
    print(MapScreen.currentAddress);
  }

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  ///Map Widget
  Widget buildMap() {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: _myCurrentLocationCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
      ),
      floatingActionButton: buildFAB(),
    );
  }

  /// FAB Widget
  Widget buildFAB() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 8, 100),
      child: FloatingActionButton(
        heroTag: null,
        elevation: 3,
        backgroundColor: Colors.grey,
        onPressed: _goToMyCurrentLocation,
        child: Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          position != null
              ? Container(
            height: height,
            child: buildMap(),
          )
              : Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: width,
              height: 160,
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${MapScreen.currentAddress}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF727272),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: CustomButton(
                      width: 300,
                      height: 50,
                      text: "تاكيد",
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: Colors.blue,
                        textStyle:
                        TextStyle(fontSize: 17, fontFamily: 'Frutiger'),
                      ),
                      onPressed: () {
                        print("Clicked");
                        Navigator.of(context).pushNamed(
                            showAddressScreen,
                            arguments: MapScreen.currentAddress);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 50,
              right: 30,
              child: InkWell(
                child: Container(
                    width: width*0.09,
                    height: height*0.09,
                    child: Icon(Icons.logout,color: Colors.red,size: 30,)
                ),
                onTap: () async {
                  await phoneAuthCubit.logOut();
                  Navigator.of(context).pushReplacementNamed(loginScreen);
                },
              )
          )
        ],
      ),
      floatingActionButton: buildFAB(),
    );
  }
}
