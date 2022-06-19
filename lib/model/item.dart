import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Item {
  String title;
  String description;
  String type;
  LatLng position;

  Item(this.title, this.description, this.type, this.position);
}