import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outdo_app/model/meeting_model.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../provider/location_provider.dart';
import '../../util/dimensions.dart';
import '../../util/images.dart';
import '../../widgets/custom_button.dart';

class PickMapScreen extends StatefulWidget {
  double lat;
  double long;
  bool isFromUpcomingMeeting;
  Upcoming? upcomingMeeting;
  PickMapScreen(this.lat, this.long,
      {this.isFromUpcomingMeeting = false, this.upcomingMeeting});
  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  LatLng? _initialPosition;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    loadData();
    super.initState();
  }

  final List<Marker> _markers = <Marker>[];
  List<String> images = [Images.pick_marker];
  // declared method to get Images
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    // created list of coordinates of various locations
    final List<LatLng> _latLen = <LatLng>[
      LatLng(
        widget.lat,
        widget.long,
      )
    ];
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // created method for displaying custom markers according to index
  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markIcons = await getImages(images[i], 100);
      // makers added according to index
      _markers.add(Marker(
        // given marker id
        markerId: MarkerId(i.toString()),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons),
        // given position
        position: LatLng(
          widget.lat,
          widget.long,
        ),
        infoWindow: InfoWindow(
          // given title for marker
          title: 'Location: ' + i.toString(),
        ),
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocationProvider>(context);
    _initialPosition = LatLng(
      widget.lat,
      widget.long,
    );
    // _initialPosition = LatLng(
    //   loc.currentPosition != null ? loc.currentPosition!.latitude : 0.0,
    //   loc.currentPosition != null ? loc.currentPosition!.longitude : 0.0,
    // );

    return Scaffold(
      body: SafeArea(
          child: Center(
              child: SizedBox(
        child: Stack(children: [
          GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: false,
            indoorViewEnabled: true,
            mapToolbarEnabled: false,
            mapType: MapType.normal,
            // myLocationButtonEnabled: true,
            // myLocationEnabled: true,

            markers: Set<Marker>.of(_markers),
            initialCameraPosition: CameraPosition(
              target: _initialPosition!,
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) async {
              var visible = await controller.getVisibleRegion();
              _controller.complete(controller);
              _mapController = controller;
              log('northeast : ${visible.northeast}');
              log('southwest : ${visible.southwest}');
            },
            onCameraMove: (CameraPosition position) {
              _cameraPosition = position;
              log('latitude is : ${position.target.latitude}');
              log('longitude is : ${position.target.longitude}');
              // log('latitude is : ${_cameraPosition!.target.latitude}');
              // log('longitude is : ${_cameraPosition!.target.longitude}');
            },
          ),
          Center(
              child:
                  // !locationController.loading
                  //     ?
                  Image.asset(Images.pick_marker, height: 50, width: 50)
              // : CircularProgressIndicator()
              ),
          // Positioned(
          //   top: Dimensions.PADDING_SIZE_LARGE,
          //   left: Dimensions.PADDING_SIZE_SMALL,
          //   right: Dimensions.PADDING_SIZE_SMALL,
          //   child: SearchLocationWidget(
          //       mapController: _mapController,
          //       pickedAddress: locationController.pickAddress,
          //       isEnabled: null),
          // ),
          Positioned(
            bottom: 80,
            right: Dimensions.PADDING_SIZE_SMALL,
            child: FloatingActionButton(
                child: Icon(Icons.my_location,
                    color: Theme.of(context).primaryColor),
                mini: true,
                backgroundColor: Theme.of(context).cardColor,
                onPressed: () async {
                  await loc.getCurrentPosition();
                  _mapController!
                      .moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                            loc.currentPosition!.latitude,
                            loc.currentPosition!.longitude,
                          ),
                          zoom: 16)));
                  loc.currentPosition = Position(
                    longitude: _cameraPosition!.target.longitude,
                    latitude: _cameraPosition!.target.latitude,
                    timestamp: DateTime.now(),
                    accuracy: 1,
                    altitude: 1,
                    heading: 1,
                    speed: 1,
                    speedAccuracy: 1,
                  );
                }),
          ),
          Positioned(
            bottom: Dimensions.PADDING_SIZE_LARGE,
            left: Dimensions.PADDING_SIZE_SMALL,
            right: Dimensions.PADDING_SIZE_SMALL,
            child: !loc.isLoading
                ? CustomButton(
                    buttonText: 'pick location',
                    onPressed: () async {
                      if (widget.isFromUpcomingMeeting) {
                        log('First position : ${widget.upcomingMeeting!.latitude} , ${widget.upcomingMeeting!.longitude}');
                        widget.upcomingMeeting!.latitude =
                            _cameraPosition!.target.latitude.toString();
                        widget.upcomingMeeting!.longitude =
                            _cameraPosition!.target.longitude.toString();
                        log('After position : ${widget.upcomingMeeting!.latitude} , ${widget.upcomingMeeting!.longitude}');
                        loc
                            .getMeetingLocation(
                                widget.upcomingMeeting!, context,
                                isFromGoogleMap: true)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        loc.currentPosition = Position(
                          longitude: _cameraPosition!.target.longitude,
                          latitude: _cameraPosition!.target.latitude,
                          timestamp: DateTime.now(),
                          accuracy: 1,
                          altitude: 1,
                          heading: 1,
                          speed: 1,
                          speedAccuracy: 1,
                        );
                        loc.setIsCurrentLocation(true);
                        await loc.getCurrentPosition();
                        Get.back();
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ]),
      ))),
    );
  }
}
