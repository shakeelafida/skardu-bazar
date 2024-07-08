import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceCategoriesModle {
  final String image;
  final String name;
  final String number;
  final String address;
  final String description;
  PlaceCategoriesModle(
      {required this.image,
       required this.name, 
      required this.number,
       required this.address,
       required this.description
      });
}
