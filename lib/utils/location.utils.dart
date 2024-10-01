import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationUtils {
  LocationUtils._();

  static Future<bool> checkGeolocationPermission() async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.deniedForever && locationEnabled) {
      final permissionRequest = await Geolocator.requestPermission();
      if (permissionRequest != LocationPermission.deniedForever) {
        return true;
      }
    }

    return false;
  }

  static Future<Position?> getLastKnownPosition() async {
    final isAvailable = await geolocationIsAvailable();
    if (isAvailable) {
      return Geolocator.getLastKnownPosition();
    } else {
      final permissionRequest = await Geolocator.requestPermission();
      if (permissionRequest != LocationPermission.deniedForever &&
          permissionRequest != LocationPermission.denied) {
        return Geolocator.getLastKnownPosition();
      }
    }

    return null;
  }

  static Future<Position?> getCurrentLocation() async {
    final isAvailable = await geolocationIsAvailable();
    if (isAvailable) {
      return Geolocator.getCurrentPosition();
    } else {
      final permissionRequest = await Geolocator.requestPermission();
      if (permissionRequest != LocationPermission.deniedForever &&
          permissionRequest != LocationPermission.denied) {
        return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    }

    return null;
  }

  static Future<bool> geolocationIsAvailable() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permissionStatus = await Geolocator.checkPermission();
    final permissionGranted = permissionStatus == LocationPermission.always ||
        permissionStatus == LocationPermission.whileInUse;

    return serviceEnabled && permissionGranted;
  }

  // static LatLng center(LatLng first, LatLng second) {
  //   return LatLng(
  //     (first.latitude + second.latitude) / 2,
  //     (first.longitude + second.longitude) / 2,
  //   );
  // }

  // static double calculateDistance(LatLng first, LatLng second) {
  //   const p = 0.017453292519943295;
  //   const c = cos;
  //   final a = 0.5 -
  //       c((second.latitude - first.latitude) * p) / 2 +
  //       c(first.latitude * p) *
  //           c(second.latitude * p) *
  //           (1 - c((second.longitude - first.longitude) * p)) /
  //           2;

  //   return 12742 * asin(sqrt(a));
  // }

}
