import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outdo_app/provider/abc.dart';
import 'package:outdo_app/util/colors.dart';
import 'package:location/location.dart' as l;

import '../model/meeting_model.dart';
import '../widgets/common_functions.dart';
import '../widgets/common_views.dart';

class LocationProvider with ChangeNotifier {
  Position? currentPosition;
  String? currentAddress;
  String? locality = '';
  String? city = '';
  String? adddress1 = '';
  String? adddress2 = '';
  String? area = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCurrentLocation = false;
  bool get isCurrentLocation => _isCurrentLocation;
  void setIsCurrentLocation(bool check) => _isCurrentLocation = check;

  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  Future<void> getMeetingLocation(Upcoming upcomingMeet, BuildContext context,
      {bool isFromGoogleMap = false}) async {
    // // _isLoading = true;
    // // notifyListeners();
    // CommonViews.showProgressDialog(context);
    // final permission = await _handleLocationPermission();
    // if (!permission) {
    //   Get.back();
    //   // _isLoading = false;
    //   // notifyListeners();
    //   return;
    // }
    CommonViews.showProgressDialog(context);

    l.Location location = l.Location();

    bool _serviceEnabled;
    l.PermissionStatus _permissionGranted;
    l.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Get.back();
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != l.PermissionStatus.granted) {
        Get.back();
        return;
      }
    }
    try {
      _locationData = await location.getLocation();
      if (!isFromGoogleMap) {
        upcomingMeet.latitude = _locationData.latitude.toString();
        upcomingMeet.longitude = _locationData.longitude.toString();
        upcomingMeet.locationPosition = Position(
          latitude: _locationData.latitude!,
          longitude: _locationData.longitude!,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          heading: 1,
          speed: 1,
          speedAccuracy: 1,
        );
        currentPosition = Position(
          latitude: _locationData.latitude!,
          longitude: _locationData.longitude!,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          heading: 1,
          speed: 1,
          speedAccuracy: 1,
        );
        await _getMeetingAddress(upcomingMeet);
        // await Geolocator.getCurrentPosition(
        //         forceAndroidLocationManager: true,
        //         desiredAccuracy: LocationAccuracy.high)
        //     .then((Position position) async {
        //   upcomingMeet.locationPosition = position;

        //   await _getMeetingAddress(upcomingMeet);
        // }).catchError((e) {
        //   Get.back();
        //   log('errors hai gelocator me : ${e.toString()}');
        // });
      } else {
        log('from google map else called');
        await _getMeetingAddress(upcomingMeet);
      }
    } catch (e) {
      log('errors in getting location is : ${e.toString()}');
    }
  }

  Future<void> _getMeetingAddress(Upcoming upcomingMeet) async {
    // await placemarkFromCoordinates(51.5298, 0.1722)
    await placemarkFromCoordinates(double.parse(upcomingMeet.latitude!),
            double.parse(upcomingMeet.longitude!))
        // await placemarkFromCoordinates(upcomingMeet.locationPosition!.latitude,
        //         upcomingMeet.locationPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      log('place is : ${place.toJson()}');
      upcomingMeet.address1 = place.street;
      upcomingMeet.address2 = '${place.locality} ${place.subLocality}';
      upcomingMeet.locality = place.subAdministrativeArea;
      upcomingMeet.city = place.subAdministrativeArea;

      adddress1 = place.street;
      adddress2 = '${place.locality} ${place.subLocality}';
      area = '${place.street} ${place.locality} ${place.subLocality}';
      locality = place.subAdministrativeArea;
      city = place.subAdministrativeArea;
      currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      log('upcoming meet city : ${upcomingMeet.city}');
      log('Area sending to api is : $area');
      // _isLoading = false;
      Get.back();
      CommonFunctions.showSuccessToast('Location Picked');
      notifyListeners();
      log('date time of location on loc provider : ${DateTime.now()}');
    }).catchError((e) {
      Get.back();
      CommonFunctions.showErrorToast('Try again location not picked');
      log('place coordinates error : ${e.toString()}');
    });
  }

  Future<void> getCurrentPosition() async {
    _isLoading = true;
    notifyListeners();
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (_isCurrentLocation) {
      log('iscurrent location lat : ${currentPosition!.latitude}');
      log('iscurrent location long : ${currentPosition!.longitude}');
      await _getAddressFromLatLng(currentPosition!);
      _isCurrentLocation = false;
    } else {
      await Geolocator.getCurrentPosition(
              forceAndroidLocationManager: false,
              desiredAccuracy: LocationAccuracy.low)
          .then((Position position) {
        currentPosition = position;
        CommonFunctions.showSuccessToast('Location Picked');
        _getAddressFromLatLng(currentPosition!);
      }).catchError((e) {
        log('errors in geo locator ${e.toString()}');

        if (e.toString() == 'The location service on the device is disabled.') {
          Get.snackbar("Location", "please turn on Location on your device",
              colorText: Appcolors.white,
              backgroundColor: Appcolors.blue,
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.to(() => ABC(e.toString()));
        }
        debugPrint(e);
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      log('place is : ${place.toJson()}');
      adddress1 = place.name;
      adddress2 = place.street;
      locality = place.locality;
      city = place.subAdministrativeArea;
      currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      // debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission? permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location services are disabled. Please enable the services')));
      // return false;
      permission = await Geolocator.checkPermission();
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
