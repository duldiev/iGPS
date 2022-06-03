import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../components/navBar.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /// Google Maps Methods

  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static const Marker _kGooglePlaxMarker = Marker(
  //   markerId: MarkerId('_kGooglePlexMarker'),
  //   infoWindow: InfoWindow(title: 'Google Plex'),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(37.42796133580664, -122.085749655962),
  // );

  // static final Polygon _kPolygon = Polygon(
  //   polygonId: PolygonId('_kPolygon'),
  //   points: [
  //     LatLng(37.42796133580664, -122.085749655962),
  //     LatLng(37.43296265331129, -122.08832357078792),
  //     LatLng(37.18, -121.0),
  //   ],
  //   strokeColor: Colors.red,
  //   strokeWidth: 2,
  //   fillColor: Colors.transparent,
  // );

  Set<Marker> _markers = {};

  /// Geolocator Methods

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _goToCurrentLocation(CameraPosition newPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  /// Other methods

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragStart: (dragStartPosition) {
          },
          onDragEnd: (dragEndPosition) {
          },
          infoWindow: InfoWindow(title: 'Marker'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // More buttons in app bar
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.holiday_village),
        //   ),
        // ],
      ),
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: _markers,
        polygons: const {},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationButtonEnabled: false,
        onTap: _handleTap,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.pin_drop),
        onPressed: () async {
          Position position = await _determinePosition();
          
          _goToCurrentLocation(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14));

          _markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(position.latitude, position.longitude)));
        },
      ),
    );
  }
}
