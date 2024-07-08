// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:uuid/uuid.dart';
// import '../../models/location_model.dart';
// import 'location_service.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class LocationSelectScreen extends StatefulWidget {
//   final LocationModel? currentLocation;
//   final BuildContext parentContext;
//   final bool createAddress;
//   final bool isBusy;
//   final void Function(BuildContext context, LocationModel selectedLocation)
//       onLocationSelection;

//   LocationSelectScreen(
//     this.parentContext,
//     this.onLocationSelection, {
//     this.currentLocation,
//     this.createAddress = false,
//     this.isBusy = false,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<LocationSelectScreen> createState() => _LocationSelectScreenState();
// }

// class _LocationSelectScreenState extends State<LocationSelectScreen> {
//   final TextEditingController _searchTextController = TextEditingController();
//   final LocationService _locationService = LocationService();
//   LatLng? startLocation;
//   LatLng? selectedLocation;
//   GoogleMapController? mapController;
//   CameraPosition? cameraPosition;
//   List<Marker> shopMarkers = [];
//   Set<Polyline> polylines = Set<Polyline>();
//   double? distance;

//   final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'YOUR_GOOGLE_MAPS_API_KEY'); // Replace with your API key

//   var uuid = Uuid();
//   String _sessionToken = '1234567890';
//   List<dynamic> _placeList = [];
//   TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       _onChanged();
//     });
//     _setupInitialLocation();
//   }

//   void _onChanged() {
//     if (_sessionToken.isEmpty) {
//       setState(() {
//         _sessionToken = uuid.v4();
//       });
//     }
//     getSuggestion(_controller.text);
//   }

//   void getSuggestion(String input) async {
//     const String PLACES_API_KEY = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key

//     String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';

//     var response = await http.get(Uri.parse(request));
//     if (response.statusCode == 200) {
//       setState(() {
//         _placeList = json.decode(response.body)['predictions'];
//       });
//     } else {
//       throw Exception('Failed to load predictions');
//     }
//   }

//   void _setupInitialLocation() async {
//     if (widget.currentLocation != null) {
//       startLocation = LatLng(
//         widget.currentLocation!.coordinates.latitude,
//         widget.currentLocation!.coordinates.longitude,
//       );
//       _searchTextController.text = widget.currentLocation!.address;
//     } else {
//       var currentLoc = await _locationService.getCurrentLocation();
//       setState(() {
//         startLocation = LatLng(
//           currentLoc.coordinates.latitude,
//           currentLoc.coordinates.longitude,
//         );
//         _searchTextController.text = currentLoc.address;
//       });
//     }
//     _fetchNearbyShops();
//   }

//   void _fetchNearbyShops() async {
//     var shops = await _locationService.getNearbyShops();
//     setState(() {
//       shopMarkers = shops.map((shop) {
//         return Marker(
//           markerId: MarkerId(shop.address),
//           position: shop.coordinates,
//           infoWindow: InfoWindow(title: shop.address, snippet: 'Click for details'),
//           icon: _getMarkerIconForShopType(shop.address),
//           onTap: () => _navigateToShop(shop),
//         );
//       }).toList();
//     });
//   }

//   BitmapDescriptor _getMarkerIconForShopType(String shopType) {
//     switch (shopType) {
//       case 'Pharmacy Shop':
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
//       case 'General Store':
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
//       case 'Garment Shop':
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//       case 'Stationary Shop':
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
//       default:
//         return BitmapDescriptor.defaultMarker;
//     }
//   }

//   void _navigateToShop(LocationModel shop) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(shop.address),
//         content: Text('Would you like to navigate to this shop?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Add actual navigation logic here
//             },
//             child: const Text('Yes'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('No'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onPlaceSelected(Prediction prediction) async {
//     PlacesDetailsResponse details = await _places.getDetailsByPlaceId(prediction.placeId!);
//     setState(() {
//       selectedLocation = LatLng(
//         details.result.geometry!.location.lat,
//         details.result.geometry!.location.lng,
//       );
//       _searchTextController.text = details.result.formattedAddress ?? '';

//       // Add a marker for the selected place
//       shopMarkers.add(
//         Marker(
//           markerId: MarkerId(details.result.placeId),
//           position: selectedLocation!,
//           infoWindow: InfoWindow(title: details.result.name),
//         ),
//       );

//       // Move the camera to the selected place
//       mapController?.animateCamera(
//         CameraUpdate.newLatLngZoom(selectedLocation!, 14.0),
//       );

//       // Calculate distance
//       if (startLocation != null && selectedLocation != null) {
//         distance = _locationService.getDistance(startLocation!, selectedLocation!);
//       }

//       // Draw polyline
//       _drawPolyline(startLocation!, selectedLocation!);
//     });
//   }

//   Future<void> _drawPolyline(LatLng from, LatLng to) async {
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyDIVIR1pR0UXt5oLbJtJhQIPoJ9jCdefLc', // Replace with your API key
//       PointLatLng(from.latitude, from.longitude),
//       PointLatLng(to.latitude, to.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }

//       setState(() {
//         polylines.add(
//           Polyline(
//             polylineId: PolylineId('polyline'),
//             color: Colors.blue,
//             width: 5,
//             points: polylineCoordinates,
//           ),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           if (startLocation != null)
//             GoogleMap(
//               myLocationButtonEnabled: true,
//               zoomGesturesEnabled: true,
//               zoomControlsEnabled: false,
//               initialCameraPosition: CameraPosition(
//                 target: startLocation!,
//                 zoom: 14.0,
//               ),
//               mapType: MapType.normal,
//               onMapCreated: (controller) {
//                 setState(() {
//                   mapController = controller;
//                 });
//               },
//               markers: {
//                 if (startLocation != null)
//                   Marker(
//                     markerId: const MarkerId('currentLocation'),
//                     position: startLocation!,
//                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//                     infoWindow: const InfoWindow(title: 'Current Location'),
//                   ),
//                 ...shopMarkers
//               }.toSet(),
//               polylines: polylines,
//               onCameraMove: (CameraPosition tempCameraPosition) {
//                 cameraPosition = tempCameraPosition;
//               },
//               onCameraIdle: () async {
//                 if (cameraPosition != null) {
//                   var address = await _locationService.getAddressFromCoordinates(
//                     LatLng(
//                       cameraPosition!.target.latitude,
//                       cameraPosition!.target.longitude,
//                     ),
//                   );
//                   setState(() {
//                     _searchTextController.text = address;
//                   });
//                 }
//               },
//             ),
//           Positioned(
//             top: 20,
//             left: 10,
//             right: 10,
//             child: Container(
//               color: Colors.white.withOpacity(0.8),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _controller,
//                     readOnly: false,
//                     onTap: () async {
//                       Prediction? prediction = await PlacesAutocomplete.show(
//                         context: context,
//                         apiKey: 'AIzaSyDIVIR1pR0UXt5oLbJtJhQIPoJ9jCdefLc', // Replace with your API key
//                         mode: Mode.overlay,
//                         language: "en",
//                         components: [Component(Component.country, "us")],
//                       );
//                       if (prediction != null) {
//                         _onPlaceSelected(prediction);
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       hintText: 'Search location...',
//                       prefixIcon: Icon(Icons.search),
//                     ),
//                   ),
//                   if (distance != null)
//                     Text(
//                       'Distance: $distance km',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 60,
//             left: 10,
//             right: 10,
//             child: Container(
//               color: Colors.white.withOpacity(0.8),
//               child: _placeList.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: _placeList.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(_placeList[index]['description']),
//                           onTap: () {
//                             _onPlaceSelected(
//                               Prediction(
//                                 placeId: _placeList[index]['place_id'],
//                                 description: _placeList[index]['description'],
//                               ),
//                             );
//                             setState(() {
//                               _placeList = [];
//                             });
//                           },
//                         );
//                       },
//                     )
//                   : Container(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // class LocationModel {
// //   final String address;
// //   final LatLng coordinates;

// //   LocationModel(this.address, this.coordinates);
// // }

// // class LocationService {
// //   LocationModel _currentLocation = LocationModel('address', const LatLng(0, 0));

// //   Future<LocationModel> getCurrentLocation({bool isExact = false}) async {
// //     if (_currentLocation.coordinates.latitude != 0 &&
// //         _currentLocation.coordinates.longitude != 0 &&
// //         !isExact) {
// //       return _currentLocation;
// //     }
// //     var hasPermission = await Geolocator.checkPermission();
// //     if (hasPermission == LocationPermission.denied) {
// //       await Geolocator.requestPermission();
// //     }
// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);
// //     double lat = position.latitude;
// //     double long = position.longitude;
// //     String addressText = await getAddressFromCoordinates(LatLng(lat, long));
// //     _currentLocation = LocationModel(addressText, LatLng(lat, long));
// //     return _currentLocation;
// //   }

// //   Future<void> updateCurrentLocation(LocationModel location) async {
// //     _currentLocation = location;
// //   }

// //   Future<String> getAddressFromCoordinates(LatLng coordinates) async {
// //     List<Placemark> placemarks = await placemarkFromCoordinates(
// //         coordinates.latitude, coordinates.longitude);

// //     if (placemarks.isNotEmpty) {
// //       Placemark firstPlacemark = placemarks.first;

// //       String street = firstPlacemark.street ?? '';
// //       String subLocality = firstPlacemark.subLocality ?? '';
// //       String locality = firstPlacemark.locality ?? '';
// //       String postalCode = firstPlacemark.postalCode ?? '';
// //       String administrativeArea = firstPlacemark.administrativeArea ?? '';
// //       String country = firstPlacemark.country ?? '';

// //       var addressText =
// //           "${street.isNotEmpty ? '$street,' : ''} ${subLocality.isNotEmpty ? '$subLocality,' : ''} ${locality.isNotEmpty ? '$locality,' : ''} ${postalCode.isNotEmpty ? '$postalCode,' : ''} ${administrativeArea.isNotEmpty ? '$administrativeArea,' : ''} ${country.isNotEmpty ? '$country,' : ''}";
// //       var firstSection = '${addressText.split(',')[0]},';
// //       if (firstSection.contains('+')) {
// //         addressText = addressText.replaceAll(firstSection, '');
// //       }
// //       return addressText;
// //     }
// //     return "";
// //   }

// //   double getDistance(LatLng location1, LatLng location2) {
// //     var p = 0.017453292519943295;
// //     var c = cos;
// //     var a = 0.5 -
// //         c((location1.latitude - location2.latitude) * p) / 2 +
// //         c(location2.latitude * p) *
// //             c(location1.latitude * p) *
// //             (1 - c((location1.longitude - location2.longitude) * p)) /
// //             2;

// //     return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
// //   }

// //   Future<List<LocationModel>> getNearbyShops() async {
// //     // Mock data; replace with real API or database query
// //     return [
// //       LocationModel('Pharmacy Shop', LatLng(37.7749, -122.4194)),
// //       LocationModel('General Store', LatLng(37.7750, -122.4195)),
// //       LocationModel('Garment Shop', LatLng(37.7751, -122.4196)),
// //       LocationModel('Stationary Shop', LatLng(37.7752, -122.4197)),
// //     ];
// //   }
// // }

// // class LocationSelectScreen extends StatefulWidget {
// //   final LocationModel? currentLocation;
// //   final BuildContext parentContext;
// //   final bool createAddress;
// //   final bool isBusy;

// //   final void Function(BuildContext context, LocationModel selectedLocation)
// //       onLocationSelection;

// //   LocationSelectScreen(this.parentContext, this.onLocationSelection,
// //       {this.currentLocation, this.createAddress = false, this.isBusy = false, Key? key})
// //       : super(key: key);

// //   @override
// //   State<LocationSelectScreen> createState() => _LocationSelectScreenState();
// // }

// // class _LocationSelectScreenState extends State<LocationSelectScreen> {
// //   final _searchTextController = TextEditingController();
// //   final _locationService = LocationService();
// //   LatLng? startLocation;
// //   LatLng? selectedLocation;
// //   GoogleMapController? mapController;
// //   CameraPosition? cameraPosition;
// //   List<Marker> shopMarkers = [];
// //   Set<Polyline> polylines = Set<Polyline>();
// //   double? distance;
   
// //    final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyDIVIR1pR0UXt5oLbJtJhQIPoJ9jCdefLc'); // Replace with your API key

// //   @override
// //   void initState() {
// //     super.initState();
// //     _setupInitialLocation();
// //   }

// //   void _setupInitialLocation() async {
// //     if (widget.currentLocation != null) {
// //       startLocation = LatLng(
// //         widget.currentLocation!.coordinates.latitude,
// //         widget.currentLocation!.coordinates.longitude,
// //       );
// //       _searchTextController.text = widget.currentLocation!.address;
// //     } else {
// //       var currentLoc = await _locationService.getCurrentLocation();
// //       setState(() {
// //         startLocation = LatLng(
// //           currentLoc.coordinates.latitude,
// //           currentLoc.coordinates.longitude,
// //         );
// //         _searchTextController.text = currentLoc.address;
// //       });
// //     }
// //     _fetchNearbyShops();
// //   }

// //   void _fetchNearbyShops() async {
// //     var shops = await _locationService.getNearbyShops();
// //     setState(() {
// //       shopMarkers = shops.map((shop) {
// //         return Marker(
// //           markerId: MarkerId(shop.address),
// //           position: shop.coordinates,
// //           infoWindow: InfoWindow(title: shop.address, snippet: 'Click for details'),
// //           icon: _getMarkerIconForShopType(shop.address),
// //           onTap: () => _navigateToShop(shop),
// //         );
// //       }).toList();
// //     });
// //   }

// //   BitmapDescriptor _getMarkerIconForShopType(String shopType) {
// //     switch (shopType) {
// //       case 'Pharmacy Shop':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
// //       case 'General Store':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
// //       case 'Garment Shop':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
// //       case 'Stationary Shop':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
// //       default:
// //         return BitmapDescriptor.defaultMarker;
// //     }
// //   }

// //   void _navigateToShop(LocationModel shop) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text(shop.address),
// //         content: Text('Would you like to navigate to this shop?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //               // Add actual navigation logic here
// //             },
// //             child: const Text('Yes'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: const Text('No'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _onPlaceSelected(Prediction prediction) async {
// //     PlacesDetailsResponse details = await _places.getDetailsByPlaceId(prediction.placeId!);
// //     setState(() {
// //       selectedLocation = LatLng(
// //         details.result.geometry!.location.lat,
// //         details.result.geometry!.location.lng,
// //       );
// //       _searchTextController.text = details.result.formattedAddress ?? '';

// //       // Add a marker for the selected place
// //       shopMarkers.add(
// //         Marker(
// //           markerId: MarkerId(details.result.placeId),
// //           position: selectedLocation!,
// //           infoWindow: InfoWindow(title: details.result.name),
// //         ),
// //       );

// //       // Move the camera to the selected place
// //       mapController?.animateCamera(
// //         CameraUpdate.newLatLngZoom(selectedLocation!, 14.0),
// //       );

// //       // Calculate distance
// //       if (startLocation != null && selectedLocation != null) {
// //         distance = _locationService.getDistance(startLocation!, selectedLocation!);
// //       }

// //       // Draw polyline
// //       _drawPolyline(startLocation!, selectedLocation!);
// //     });
// //   }

// //   Future<void> _drawPolyline(LatLng from, LatLng to) async {
// //     List<LatLng> polylineCoordinates = [];
// //     PolylinePoints polylinePoints = PolylinePoints();
// //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
// //       'AIzaSyDIVIR1pR0UXt5oLbJtJhQIPoJ9jCdefLc', // Replace with your API key
// //       PointLatLng(from.latitude, from.longitude),
// //       PointLatLng(to.latitude, to.longitude),
// //     );

// //     if (result.points.isNotEmpty) {
// //       result.points.forEach((PointLatLng point) {
// //         polylineCoordinates.add(
// //           LatLng(point.latitude, point.longitude),
// //         );
// //       });

// //       setState(() {
// //         polylines.add(
// //           Polyline(
// //             polylineId: PolylineId('polyline'),
// //             color: Colors.blue,
// //             width: 5,
// //             points: polylineCoordinates,
// //           ),
// //         );
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true,
// //       body: Stack(
// //         children: [
// //           if (startLocation != null)
// //             GoogleMap(
// //               myLocationButtonEnabled: true,
// //               zoomGesturesEnabled: true,
// //               zoomControlsEnabled: false,
// //               initialCameraPosition: CameraPosition(
// //                 target: startLocation!,
// //                 zoom: 14.0,
// //               ),
// //               mapType: MapType.normal,
// //               onMapCreated: (controller) {
// //                 setState(() {
// //                   mapController = controller;
// //                 });
// //               },
// //               markers: {
// //                 if (startLocation != null)
// //                   Marker(
// //                     markerId: const MarkerId('currentLocation'),
// //                     position: startLocation!,
// //                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
// //                     infoWindow: const InfoWindow(title: 'Current Location'),
// //                   ),
// //                 ...shopMarkers
// //               }.toSet(),
// //               polylines: polylines,
// //               onCameraMove: (CameraPosition tempCameraPosition) {
// //                 cameraPosition = tempCameraPosition;
// //               },
// //               onCameraIdle: () async {
// //                 if (cameraPosition != null) {
// //                   var address = await _locationService.getAddressFromCoordinates(
// //                     LatLng(
// //                       cameraPosition!.target.latitude,
// //                       cameraPosition!.target.longitude,
// //                     ),
// //                   );
// //                   setState(() {
// //                     _searchTextController.text = address;
// //                   });
// //                 }
// //               },
// //             ),
// //           Positioned(
// //             top: 20,
// //             left: 10,
// //             right: 10,
// //             child: Container(
// //               color: Colors.white.withOpacity(0.8),
// //               child: Column(
// //                 children: [
// //                   TextField(
// //                     controller: _searchTextController,
// //                     readOnly: true,
// //                     onTap: () async {
// //                       Prediction? prediction = await PlacesAutocomplete.show(
// //                         context: context,
// //                         apiKey: 'YOUR_GOOGLE_MAPS_API_KEY', // Replace with your API key
// //                         mode: Mode.overlay,
// //                         language: "en",
// //                         components: [Component(Component.country, "us")],
// //                       );
// //                       if (prediction != null) {
// //                         _onPlaceSelected(prediction);
// //                       }
// //                     },
// //                     decoration: const InputDecoration(
// //                       hintText: 'Search location...',
// //                       prefixIcon: Icon(Icons.search),
// //                     ),
// //                   ),
// //                   if (distance != null)
// //                     Text(
// //                       'Distance: $distance km',
// //                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                     ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // class LocationSelectScreen extends StatefulWidget {
// //   final LocationModel? currentLocation;
// //   final BuildContext parentContext;
// //   final bool createAddress;
// //   final bool isBusy;
// //   final void Function(BuildContext context, LocationModel selectedLocation) onLocationSelection;

// //   LocationSelectScreen(this.parentContext, this.onLocationSelection,
// //       {this.currentLocation, this.createAddress = false, this.isBusy = false, Key? key})
// //       : super(key: key);

// //   @override
// //   State<LocationSelectScreen> createState() => _LocationSelectScreenState();
// // }

// // class _LocationSelectScreenState extends State<LocationSelectScreen> {
// //   final _searchTextController = TextEditingController();
// //   final _locationService = LocationService();
// //   LatLng? startLocation;
// //   GoogleMapController? mapController;
// //   CameraPosition? cameraPosition;
// //   List<Marker> shopMarkers = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _setupInitialLocation();
// //   }

// //   void _setupInitialLocation() async {
// //     if (widget.currentLocation != null) {
// //       startLocation = LatLng(
// //         widget.currentLocation!.coordinates.latitude,
// //         widget.currentLocation!.coordinates.longitude,
// //       );
// //       _searchTextController.text = widget.currentLocation!.address;
// //     } else {
// //       var currentLoc = await _locationService.getCurrentLocation();
// //       setState(() {
// //         startLocation = LatLng(
// //           currentLoc.coordinates.latitude,
// //           currentLoc.coordinates.longitude,
// //         );
// //         _searchTextController.text = currentLoc.address;
// //       });
// //     }
// //     _fetchNearbyShops();
// //   }

// //   void _fetchNearbyShops() async {
// //     var shops = await _locationService.getNearbyShops();
// //     setState(() {
// //       shopMarkers = shops.map((shop) {
// //         return Marker(
// //           markerId: MarkerId(shop.address),
// //           position: shop.coordinates,
// //           infoWindow: InfoWindow(title: shop.address, snippet: 'Click for details'),
// //           icon: _getMarkerIconForShopType(shop.address),
// //           onTap: () => _navigateToShop(shop),
// //         );
// //       }).toList();
// //     });
// //   }

// //   BitmapDescriptor _getMarkerIconForShopType(String shopType) {
// //     switch (shopType) {
// //       case 'Pharmacy Shop':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
// //       case 'General Store':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
// //       case 'Garment Shop':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
// //       case 'Stationary Shop':
// //         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
// //       default:
// //         return BitmapDescriptor.defaultMarker;
// //     }
// //   }

// //   void _navigateToShop(LocationModel shop) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text(shop.address),
// //         content: Text('Would you like to navigate to this shop?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //               // Add actual navigation logic here
// //             },
// //             child: const Text('Yes'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: const Text('No'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true,
// //       body: Stack(
// //         children: [
// //           if (startLocation != null)
// //             GoogleMap(
// //               myLocationButtonEnabled: true,
// //               zoomGesturesEnabled: true,
// //               zoomControlsEnabled: false,
// //               initialCameraPosition: CameraPosition(
// //                 target: startLocation!,
// //                 zoom: 14.0,
// //               ),
// //               mapType: MapType.normal,
// //               onMapCreated: (controller) {
// //                 setState(() {
// //                   mapController = controller;
// //                 });
// //               },
// //               markers: {
// //                 if (startLocation != null)
// //                   Marker(
// //                     markerId: const MarkerId('currentLocation'),
// //                     position: startLocation!,
// //                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
// //                     infoWindow: const InfoWindow(title: 'Current Location'),
// //                   ),
// //                 ...shopMarkers
// //               }.toSet(),
// //               onCameraMove: (CameraPosition tempCameraPosition) {
// //                 cameraPosition = tempCameraPosition;
// //               },
// //               onCameraIdle: () async {
// //                 if (cameraPosition != null) {
// //                   var address = await _locationService.getAddressFromCoordinates(
// //                     LatLng(
// //                       cameraPosition!.target.latitude,
// //                       cameraPosition!.target.longitude,
// //                     ),
// //                   );
// //                   setState(() {
// //                     _searchTextController.text = address;
// //                   });
// //                 }
// //               },
// //             ),
// //           Positioned(
// //             top: 20,
// //             left: 10,
// //             right: 10,
// //             child: Container(
// //               color: Colors.white.withOpacity(0.8),
// //               child: TextField(
// //                 controller: _searchTextController,
// //                 decoration: const InputDecoration(
// //                   hintText: 'Search location...',
// //                   prefixIcon: Icon(Icons.search),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:skardubazar/views/googlemap/location_service.dart';
// // import 'package:skardubazar/widgets/round_button.dart';

// // import 'package:widget_marker_google_map/widget_marker_google_map.dart';

// // import '../../models/location_model.dart';
// // import '../../utils/cus_navigator.dart';


// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // class LocationSelectScreen extends StatefulWidget {
// //   final LocationModel? currentLocation;
// //   final BuildContext parentContext;
// //   final bool createAddress;
// //   final bool isBusy;
// //   final void Function(BuildContext context, LocationModel selectedLocation)
// //       onLocationSelection;

// //   LocationSelectScreen(this.parentContext, this.onLocationSelection,
// //       {this.currentLocation,
// //       this.createAddress = false,
// //       this.isBusy = false,
// //       Key? key})
// //       : super(key: key);

// //   @override
// //   State<LocationSelectScreen> createState() => _LocationSelectScreenState();
// // }

// // class _LocationSelectScreenState extends State<LocationSelectScreen> {
// //   final _searchTextController = TextEditingController();
// //   //final _navigationService = CusNavigator();
// //   final _locationService = LocationService();
 
// //   LatLng? startLocation;
// //   GoogleMapController? mapController;
// //   CameraPosition? cameraPosition;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _setupInitialLocation();
// //   }

// //   void _setupInitialLocation() async {
// //     if (widget.currentLocation != null) {
// //       startLocation = LatLng(
// //         widget.currentLocation!.coordinates.latitude,
// //         widget.currentLocation!.coordinates.longitude,
// //       );
// //       _searchTextController.text = widget.currentLocation!.address;
// //     } else {
// //       var currentLoc = await _locationService.getCurrentLocation();
// //       setState(() {
// //         startLocation = LatLng(
// //           currentLoc.coordinates.latitude,
// //           currentLoc.coordinates.longitude,
// //         );
// //         _searchTextController.text = currentLoc.address;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true,
// //      // appBar:AppBar(title: Text('Select Address'),),
      
// //       body: Stack(
// //         children: [
// //           if (startLocation != null)
// //             GoogleMap(
// //               myLocationButtonEnabled: false,
// //               zoomGesturesEnabled: true,
// //               zoomControlsEnabled: false,
// //               initialCameraPosition: CameraPosition(
// //                 target: startLocation!,
// //                 zoom: 14.0,
// //               ),
// //               mapType: MapType.normal,
// //               onMapCreated: (controller) {
// //                 setState(() {
// //                   mapController = controller;
// //                 });
// //               },
// //               markers: startLocation != null
// //                   ? Set<Marker>.from([
// //                       Marker(
// //                         markerId: const MarkerId('currentLocation'),
// //                         position: startLocation!,
// //                         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
// //                             .hueAzure), 
// //                         infoWindow: const InfoWindow(title: 'Current Location'),
// //                       ),
// //                     ])
// //                   : Set<
// //                       Marker>(), 
// //               onCameraMove: (CameraPosition tempCameraPosition) {
// //                 cameraPosition = tempCameraPosition;
// //               },
// //               onCameraIdle: () async {
// //                 var address = await _locationService.getAddressFromCoordinates(
// //                   LatLng(
// //                     cameraPosition!.target.latitude,
// //                     cameraPosition!.target.longitude,
// //                   ),
// //                 );
// //                 setState(() {
// //                   _searchTextController.text = address;
// //                 });
// //               },
// //             ),
          
          

          
// //         ],
// //       ),
// //     );
// //   }
// // }
