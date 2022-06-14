import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMarker {
  MarkerId markerId;
  String title;
  String description;
  LatLng position;
  InfoWindow infoWindow;

  MyMarker(this.markerId, this.title, this.description, this.position, this.infoWindow);
}
