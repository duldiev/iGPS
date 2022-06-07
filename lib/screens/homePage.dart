import 'dart:async';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  final Set<Marker> _markers = {};
  double _zoomValue = 14.0;

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

  Future<void> _zoomInAndOut(double zoomingValue) async {
    final GoogleMapController controller = await _controller.future;
    _zoomValue += zoomingValue;
    controller.animateCamera(CameraUpdate.zoomTo(_zoomValue));
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
          infoWindow: const InfoWindow(title: 'Marker'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iGPS",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(
          size: 26.0,
          color: Colors.white,
        ),
        backgroundColor: Colors.black.withOpacity(0.3),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                builder: (context) => const BuildSheet(),
              );
            },
            icon: const Icon(
              Icons.brunch_dining_rounded,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      body: Stack(
          children: [
            Positioned(
              child: GoogleMap(
                mapType: MapType.hybrid,
                markers: _markers,
                polygons: const {},
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  },
                myLocationButtonEnabled: false,
                onTap: _handleTap,
                // onCameraMove: (CameraPosition cameraPosition) {
                //   _zoomValue = cameraPosition.zoom;
                // },
              ),
            ),
            Positioned(
                bottom: 15,
                right: 15,
                child: SafeArea(
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightBlue,
                    onPressed: () async {
                      Position position = await _determinePosition();
                      _goToCurrentLocation(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: _zoomValue));
                      setState(() {
                        _markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(position.latitude, position.longitude)));
                      });
                    },
                    child: const Icon(Icons.pin_drop),
                  ),
                )
            ),
            Positioned(
                bottom: MediaQuery.of(context).size.height / 2,
                right: 15,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      onPressed: () {
                        setState(() {
                          _zoomInAndOut(0.5);
                        });
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.add),
                    ),
                    FloatingActionButton.small(
                      onPressed: () {
                        setState(() {
                          _zoomInAndOut(-0.5);
                        });
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.remove),
                    ),
                  ],
                )
            ),
        ]
      ),
    );
  }
}

class BuildSheet extends StatelessWidget {
  const BuildSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 40,
            child: Divider(height: 3, thickness: 3,color: Colors.grey),
          ),
          ListTile(
            leading: const Icon(Icons.add_location_rounded),
            title: const Text("Add marker"),
            onTap: () {

            },
          ),
          const Divider(height: 1.0, color: Colors.grey, indent: 15.0, endIndent: 15.0,),
          ListTile(
            leading: const Icon(Icons.flutter_dash),
            title: const Text("Show items"),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}