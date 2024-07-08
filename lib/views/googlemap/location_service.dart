 import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:widget_marker_google_map/widget_marker_google_map.dart';
import 'package:geocoding/geocoding.dart';

import '../../models/location_model.dart';
import 'app_config.dart';

class LocationService {
  LocationModel _currentLocation = LocationModel('address', const LatLng(0, 0));
  Future<LocationModel> getCurrentLocation({bool isExact = false}) async {
    if (_currentLocation.coordinates.latitude != 0 &&
        _currentLocation.coordinates.longitude != 0 &&
        !isExact) {
      return _currentLocation;
    }
    var hasPermission = await Geolocator.checkPermission();
    if (hasPermission.name == 'denied') {
      await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    String addressText = await getAddressFromCoordinates(LatLng(lat, long));
    _currentLocation = LocationModel(addressText, LatLng(lat, long));
    return _currentLocation;
  }
  Future<void> updateCurrentLocation(LocationModel location) async {
    AppConfig.currentLocation = location;
    _currentLocation = location;
  }

  Future<String> getAddressFromCoordinates(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;

      String street = firstPlacemark.street ?? '';
      String subLocality = firstPlacemark.subLocality ?? '';
      String locality = firstPlacemark.locality ?? '';
      String postalCode = firstPlacemark.postalCode ?? '';
      String administrativeArea = firstPlacemark.administrativeArea ?? '';
      String country = firstPlacemark.country ?? '';

      var addressText =
          "${street.isNotEmpty ? '$street,' : ''} ${subLocality.isNotEmpty ? '$subLocality,' : ''} ${locality.isNotEmpty ? '$locality,' : ''} ${postalCode.isNotEmpty ? '$postalCode,' : ''} ${administrativeArea.isNotEmpty ? '$administrativeArea,' : ''} ${country.isNotEmpty ? '$country,' : ''}";
      var firstSection = '${addressText.split(',')[0]},';
      if (firstSection.contains('+')) {
        addressText = addressText.replaceAll(firstSection, '');
      }
      return addressText;
    }
    // return "${placemarks.first.administrativeArea}, ${placemarks.first.street}";
    return "";
  }

  double getDistance(LatLng location1, LatLng location2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((location1.latitude - location2.latitude) * p) / 2 +
        c(location2.latitude * p) *
            c(location1.latitude * p) *
            (1 - c((location1.longitude - location2.longitude) * p)) /
            2;

    return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
  }
}
// import 'dart:math';

// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// class LocationModel {
//   final String address;
//   final LatLng coordinates;

//   LocationModel(this.address, this.coordinates);
// }

// class LocationService {
//   LocationModel _currentLocation = LocationModel('address', const LatLng(0, 0));

//   Future<LocationModel> getCurrentLocation({bool isExact = false}) async {
//     if (_currentLocation.coordinates.latitude != 0 &&
//         _currentLocation.coordinates.longitude != 0 &&
//         !isExact) {
//       return _currentLocation;
//     }
//     var hasPermission = await Geolocator.checkPermission();
//     if (hasPermission == LocationPermission.denied) {
//       await Geolocator.requestPermission();
//     }
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     double lat = position.latitude;
//     double long = position.longitude;
//     String addressText = await getAddressFromCoordinates(LatLng(lat, long));
//     _currentLocation = LocationModel(addressText, LatLng(lat, long));
//     return _currentLocation;
//   }

//   Future<void> updateCurrentLocation(LocationModel location) async {
//     _currentLocation = location;
//   }

//   Future<String> getAddressFromCoordinates(LatLng coordinates) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         coordinates.latitude, coordinates.longitude);

//     if (placemarks.isNotEmpty) {
//       Placemark firstPlacemark = placemarks.first;

//       String street = firstPlacemark.street ?? '';
//       String subLocality = firstPlacemark.subLocality ?? '';
//       String locality = firstPlacemark.locality ?? '';
//       String postalCode = firstPlacemark.postalCode ?? '';
//       String administrativeArea = firstPlacemark.administrativeArea ?? '';
//       String country = firstPlacemark.country ?? '';

//       var addressText =
//           "${street.isNotEmpty ? '$street,' : ''} ${subLocality.isNotEmpty ? '$subLocality,' : ''} ${locality.isNotEmpty ? '$locality,' : ''} ${postalCode.isNotEmpty ? '$postalCode,' : ''} ${administrativeArea.isNotEmpty ? '$administrativeArea,' : ''} ${country.isNotEmpty ? '$country,' : ''}";
//       var firstSection = '${addressText.split(',')[0]},';
//       if (firstSection.contains('+')) {
//         addressText = addressText.replaceAll(firstSection, '');
//       }
//       return addressText;
//     }
//     return "";
//   }

//   double getDistance(LatLng location1, LatLng location2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((location1.latitude - location2.latitude) * p) / 2 +
//         c(location2.latitude * p) *
//             c(location1.latitude * p) *
//             (1 - c((location1.longitude - location2.longitude) * p)) /
//             2;

//     return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
//   }

//   Future<List<LocationModel>> getNearbyShops() async {
//     // Mock data; replace with real API or database query
//     return [
//       LocationModel('Pharmacy Shop', LatLng(37.7749, -122.4194)),
//       LocationModel('General Store', LatLng(37.7750, -122.4195)),
//       LocationModel('Garment Shop', LatLng(37.7751, -122.4196)),
//       LocationModel('Stationary Shop', LatLng(37.7752, -122.4197)),
//     ];
//   }
// }
// class LocationModel {
//   final String address;
//   final LatLng coordinates;

//   LocationModel(this.address, this.coordinates);
// }

// class LocationService {
//   LocationModel _currentLocation = LocationModel('address', const LatLng(0, 0));

//   Future<LocationModel> getCurrentLocation({bool isExact = false}) async {
//     if (_currentLocation.coordinates.latitude != 0 &&
//         _currentLocation.coordinates.longitude != 0 &&
//         !isExact) {
//       return _currentLocation;
//     }
//     var hasPermission = await Geolocator.checkPermission();
//     if (hasPermission == LocationPermission.denied) {
//       await Geolocator.requestPermission();
//     }
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     double lat = position.latitude;
//     double long = position.longitude;
//     String addressText = await getAddressFromCoordinates(LatLng(lat, long));
//     _currentLocation = LocationModel(addressText, LatLng(lat, long));
//     return _currentLocation;
//   }

//   Future<void> updateCurrentLocation(LocationModel location) async {
//     _currentLocation = location;
//   }

//   Future<String> getAddressFromCoordinates(LatLng coordinates) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         coordinates.latitude, coordinates.longitude);

//     if (placemarks.isNotEmpty) {
//       Placemark firstPlacemark = placemarks.first;

//       String street = firstPlacemark.street ?? '';
//       String subLocality = firstPlacemark.subLocality ?? '';
//       String locality = firstPlacemark.locality ?? '';
//       String postalCode = firstPlacemark.postalCode ?? '';
//       String administrativeArea = firstPlacemark.administrativeArea ?? '';
//       String country = firstPlacemark.country ?? '';

//       var addressText =
//           "${street.isNotEmpty ? '$street,' : ''} ${subLocality.isNotEmpty ? '$subLocality,' : ''} ${locality.isNotEmpty ? '$locality,' : ''} ${postalCode.isNotEmpty ? '$postalCode,' : ''} ${administrativeArea.isNotEmpty ? '$administrativeArea,' : ''} ${country.isNotEmpty ? '$country,' : ''}";
//       var firstSection = '${addressText.split(',')[0]},';
//       if (firstSection.contains('+')) {
//         addressText = addressText.replaceAll(firstSection, '');
//       }
//       return addressText;
//     }
//     return "";
//   }

//   double getDistance(LatLng location1, LatLng location2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((location1.latitude - location2.latitude) * p) / 2 +
//         c(location2.latitude * p) *
//             c(location1.latitude * p) *
//             (1 - c((location1.longitude - location2.longitude) * p)) /
//             2;

//     return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
//   }

//   Future<List<LocationModel>> getNearbyShops() async {
//     // Mock data; replace with real API or database query
//     return [
//       LocationModel('Pharmacy Shop', LatLng(37.7749, -122.4194)),
//       LocationModel('General Store', LatLng(37.7750, -122.4195)),
//       LocationModel('Garment Shop', LatLng(37.7751, -122.4196)),
//       LocationModel('Stationary Shop', LatLng(37.7752, -122.4197)),
//     ];
//   }
// }