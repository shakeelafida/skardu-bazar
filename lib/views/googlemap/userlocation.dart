import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class userlocation extends StatefulWidget {
  const userlocation({Key? key}) : super(key: key);

  @override
  _userlocationState createState() => _userlocationState();
}

class _userlocationState extends State<userlocation> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.3247, 75.5510),
    zoom: 14,
  );
  static const LatLng _center = LatLng(33.738045, 73.084488);
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  List<LatLng> latlng = [
    LatLng(35.3247, 75.5510),
    LatLng(35.35873670419323, 75.60628978804324),
    LatLng(35.30483498803142, 75.63104615753312),
    LatLng(35.368682997530236, 75.64505462657966),
    LatLng(35.3008094187224, 75.63260902387388),
    LatLng(36.306829, 74.616709), // Added new location
  ];

  List<Map<String, dynamic>> locations = [
    {'name': 'Location 1', 'latitude': 35.3247, 'longitude': 75.5510},
    {'name': 'Location 2', 'latitude': 35.35873670419323, 'longitude': 75.60628978804324},
    {'name': 'Location 3', 'latitude': 35.30483498803142, 'longitude': 75.63104615753312},
    {'name': 'Location 4', 'latitude': 35.368682997530236, 'longitude': 75.64505462657966},
    {'name': 'Location 5', 'latitude': 35.3008094187224, 'longitude': 75.63260902387388},
    {'name': 'Demo', 'latitude': 36.306829, 'longitude': 74.616709}, // Added new location
  ];

  @override
  void initState() {
    super.initState();
    _initLocationService();
    _addMarkers();
    _drawPolyline(latlng);
  }

  Future<void> _initLocationService() async {
    await _getPermission();
    Position currentPosition = await _getCurrentLocation();
    Map<String, dynamic>? nearestLocation = _findNearestLocation(currentPosition);
    if (nearestLocation != null) {
      _moveCameraToNearestLocation(nearestLocation);
    }
  }

  Future<void> _getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  double _calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Map<String, dynamic>? _findNearestLocation(Position currentPosition) {
    double minDistance = double.infinity;
    Map<String, dynamic>? nearestLocation;

    for (var location in locations) {
      double distance = _calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        location['latitude'],
        location['longitude'],
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestLocation = location;
      }
    }

    return nearestLocation;
  }

  void _moveCameraToNearestLocation(Map<String, dynamic> nearestLocation) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition nearestLocationPosition = CameraPosition(
      target: LatLng(nearestLocation['latitude'], nearestLocation['longitude']),
      zoom: 14,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(nearestLocationPosition));
    _markers.add(Marker(
      markerId: MarkerId('nearestLocation'),
      position: LatLng(nearestLocation['latitude'], nearestLocation['longitude']),
      infoWindow: InfoWindow(
        title: nearestLocation['name'],
        snippet: 'Nearest Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    setState(() {});
  }

  void _addMarkers() {
    for (int i = 0; i < latlng.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: latlng[i],
        infoWindow: InfoWindow(
          title: 'Marker $i',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
  }

  void _drawPolyline(List<LatLng> points) {
    _polylines.add(Polyline(
      polylineId: PolylineId('polyline'),
      points: points,
      color: Colors.blue,
      width: 5,
    ));
  }

  void _onCameraMove(CameraPosition position) {
    // Example: Update the polyline with the new camera position
    List<LatLng> updatedPoints = [
      position.target,
      LatLng(position.target.latitude + 0.01, position.target.longitude + 0.01),
    ];
    setState(() {
      _polylines.clear(); // Clear existing polyline
      _drawPolyline(updatedPoints); // Draw updated polyline
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google Map'),
        ),
        body: GoogleMap(
          polylines: _polylines,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          onCameraMove: _onCameraMove,
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
        ),
      ),
    );
  }
}
