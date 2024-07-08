import 'package:widget_marker_google_map/widget_marker_google_map.dart';
class LocationModel {
  String title;
  String address;
  LatLng coordinates;
  LocationModel(this.address, this.coordinates, {this.title = 'Address'});
}
