import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../models/location_model.dart';
import '../constant.dart';
import 'location_service.dart';

class mapscreen extends StatefulWidget {
  const mapscreen({Key? key}) : super(key: key);

  @override
  State<mapscreen> createState() => mapscreenState();
}

class mapscreenState extends State<mapscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final _locationService = LocationService();
  LocationModel? selectedLocation;
  final _addressController = TextEditingController();

  onLocationSelection(BuildContext context, LocationModel location) {
    setState(() {
      selectedLocation = location;
      _addressController.text = location.address;
    });
  }

  var currentLoc;
  static const LatLng sourceLocation = LatLng(35.3247, 75.5510);
  static const LatLng destination = LatLng(35.35873670419323, 75.60628978804324);
  static const LatLng demoLocation = LatLng(36.306829, 74.616709);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  List<Map<String, dynamic>> staticLocations = [
    {'name': 'Location 1', 'latitude': 35.3247, 'longitude': 75.5510},
    {'name': 'Location 2', 'latitude': 35.35873670419323, 'longitude': 75.60628978804324},
    {'name': 'Location 3', 'latitude': 35.30483498803142, 'longitude': 75.63104615753312},
    {'name': 'Location 4', 'latitude': 35.368682997530236, 'longitude': 75.64505462657966},
    {'name': 'Location 5', 'latitude': 35.3008094187224, 'longitude': 75.63260902387388},
    {'name': 'Demo', 'latitude': 36.306829, 'longitude': 74.616709}, // Added new location
  ];

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 13.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      setState(() {});
    });
  }

  void getPolyPoints() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        '', // Google API key here
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );

      if (result.status == 'OK' && result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        setState(() {});
      } else {
        throw 'Failed to fetch polyline points: ${result.errorMessage}';
      }
    } catch (e) {
      print('Error getting polyline points: $e');
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icons/Pin_source.png')
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icons/Pin_destination.png')
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icons/Badge.png')
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentLoc = _locationService.getCurrentLocation();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLoc!.latitude!, currentLoc!.longitude!),
          zoom: 13.5,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          ),
        },
        markers: {
          Marker(
            icon: currentLocationIcon,
            markerId: MarkerId('currentLocation'),
            position: LatLng(currentLoc!.latitude!, currentLoc!.longitude!),
          ),
          Marker(
            icon: sourceIcon,
            markerId: MarkerId('source'),
            position: sourceLocation,
          ),
          Marker(
            icon: destinationIcon,
            markerId: MarkerId('destination'),
            position: destination,
          ),
          Marker(
            markerId: MarkerId('demo'),
            position: demoLocation,
            infoWindow: InfoWindow(
              title: 'Demo',
              snippet: 'Newly added location',
            ),
          ),
          ...staticLocations.map((location) => Marker(
            markerId: MarkerId(location['name']),
            position: LatLng(location['latitude'], location['longitude']),
            infoWindow: InfoWindow(
              title: location['name'],
              snippet: 'Static Location',
            ),
          )),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}
