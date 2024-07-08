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
import 'garment_product_details.dart';

class Garmenttab extends StatefulWidget {
  final String? Id;
  final String? title;
  final String? imagePath;

  Garmenttab({
    Key? key,
    this.title,
    this.Id,
    this.imagePath,
  }) : super(key: key);

  @override
  State<Garmenttab> createState() => _GarmenttabState();
}

class _GarmenttabState extends State<Garmenttab> {
  final _locationService = service.LocationService();
  LocationModel? selectedLocation; // Use consistent LocationModel
  final _addressController = TextEditingController();

  void onLocationSelection(BuildContext context, LocationModel location) { // Ensure consistent parameter type
    setState(() {
      selectedLocation = location;
      _addressController.text = location.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
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
              Tab(text: "Details"),
              Tab(text: "Map"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GarmentProductDetails(
              Id: widget.Id,
              title: widget.title,
              imagePath: widget.imagePath,
            ),
            userlocation()
            // LocationSelectScreen(
            //   // context,
            //   // onLocationSelection,
            // ),
          ],
        ),
      ),
    );
  }
}

// class Garmenttab extends StatefulWidget {
//   final String? Id;
//   final String? title;
//   final String? imagePath;

//   Garmenttab({
//     Key? key,
//     this.title,
//     this.Id,
//     this.imagePath,
//   }) : super(key: key);

//   @override
//   State<Garmenttab> createState() => _GarmenttabState();
// }

// class _GarmenttabState extends State<Garmenttab> {
//   final _locationService = service.LocationService();
//   service.LocationModel?
//       selectedLocation; // Use service prefix for LocationModel
//   final _addressController = TextEditingController();

//   onLocationSelection(BuildContext context, service.LocationModel location) {
//     // Use service prefix here too
//     setState(() {
//       selectedLocation = location;
//       _addressController.text = location.address;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title ?? 'Pharmacy'),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PharmacySearchScreen()));
//                 },
//                 icon: const Icon(
//                   Icons.search,
//                   color: Colors.white,
//                 ))
//           ],
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Details"),
//               Tab(text: "Map"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             GarmentProductDetails(
//               Id: widget.Id,
//               title: widget.title,
//               imagePath: widget.imagePath,
//             ),
//             LocationSelectScreen(
//               context,
//               onLocationSelection as void Function(BuildContext context, LocationModel selectedLocation),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
