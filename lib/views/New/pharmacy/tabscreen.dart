import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skardubazar/models/location_model.dart'
    as model; // Use prefix 'model'
import 'package:skardubazar/views/googlemap/location_service.dart' as service;
import 'package:skardubazar/views/googlemap/location_service.dart';

import '../../../models/location_model.dart';
import '../../googlemap/location_select.dart';
import '../../googlemap/userlocation.dart';
import '../search_screen.dart';
import 'product_deatils.dart'; // Use prefix 'service'

class Pharmacytab extends StatefulWidget {
  final String? Id;
  final String? title;
  final String? imagePath;

  Pharmacytab({
    Key? key,
    this.title,
    this.Id,
    this.imagePath,
  }) : super(key: key);

  @override
  State<Pharmacytab> createState() => _PharmacytabState();
}

class _PharmacytabState extends State<Pharmacytab> {
  final _locationService = service.LocationService();
  LocationModel? selectedLocation; // Use consistent LocationModel
  final _addressController = TextEditingController();

  void onLocationSelection(BuildContext context, LocationModel location) {
    // Ensure consistent parameter type
    setState(() {
      selectedLocation = location;
      _addressController.text = location.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'Pharmacy'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacySearchScreen()));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
          bottom: const TabBar(
            tabs: [
              // Tab(text: "Details"),
              Tab(text: "Map"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ProductsDetails(
            //   Id: widget.Id,
            //   title: widget.title,
            //   imagePath: widget.imagePath,
            // ),
            userlocation()
          ],
        ),
      ),
    );
  }
}
