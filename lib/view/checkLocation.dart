import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:outdo_app/util/colors.dart';
import 'package:location/location.dart';

class CheckLocation extends StatelessWidget {
  const CheckLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('location'),
      ),
      body: Column(
        children: [
          MaterialButton(
            color: Appcolors.grey,
            child: Text("Location"),
            onPressed: () async {
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }

              _locationData = await location.getLocation();
              log('latitude is : ${_locationData.latitude}');
              log('longitude is : ${_locationData.longitude}');
            },
          )
        ],
      ),
    );
  }
}
