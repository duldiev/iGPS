import 'dart:async';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:igps/model/MyMarker.dart';
import '../components/navBar.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart';
import 'dart:math';

enum CurrentAction {
  noAction,
  markerAction,
}

double markerPillPosition = Consts.positions.MARKERPILL_INVISIBLE;
double attentionPosition = Consts.positions.ATTENTION_INVISIBLE;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /// PROPERTIES

  CurrentAction currentAction = CurrentAction.noAction;

  bool checkedAttention = false;

  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<LatLng> _points = [];

  double _zoomValue = 14.0;

  bool isMarkerSelected = false;


  /// GOOGLE MAPS METHODS

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  /// GEOLOCATOR METHODS

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


  /// OTHER METHODS

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      if (currentAction == CurrentAction.markerAction &&
          markerPillPosition == Consts.positions.MARKERPILL_INVISIBLE &&
          attentionPosition == Consts.positions.ATTENTION_INVISIBLE) {
        Marker newMarker = Marker(
          markerId: MarkerId("marker-${_markers.length}"),
          position: tappedPoint,
          onTap: () {
            setState(() {
              markerPillPosition = Consts.positions.MARKERPILL_VISIBLE;
              isMarkerSelected = true;
            });
          },
          infoWindow: InfoWindow(title: 'Marker ${_markers.length}'),
          icon: BitmapDescriptor.defaultMarker,
        );
        _markers.add(newMarker);
        _points.add(newMarker.position);
        _updatePolygon();
      }
      markerPillPosition = Consts.positions.MARKERPILL_INVISIBLE;
      isMarkerSelected = false;
    });
  }

  void _updatePolygon() {
    setState(() {
      _polygons = {};
      _polygons.add(
        Polygon(
          polygonId: const PolygonId("myPolygon"),
          points: _points,
          strokeColor: Colors.red,
          strokeWidth: 2,
          fillColor: Colors.transparent,
        ),
      );
    });
  }

  void _changeCurrentAction() {
    setState(() {
      if (currentAction == CurrentAction.markerAction) {
        currentAction = CurrentAction.noAction;
      } else {
        currentAction = CurrentAction.markerAction;
      }
    });
  }

  IconData _isMarkerDone() {
    if (currentAction == CurrentAction.markerAction) {
      return Icons.done;
    } else {
      return Icons.window;
    }
  }


  /// BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iGPS",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          size: 25.0,
          color: Colors.white,
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
        actions: [
          IconButton(
            onPressed: () {
              if (currentAction == CurrentAction.markerAction) {
                setState(() {
                  currentAction = CurrentAction.noAction;
                });
              } else {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  builder: (context) => BottomSheet(
                    markersButtonPressed: () {
                      setState(() {
                        Navigator.pop(context);
                        if (checkedAttention == false) {
                          attentionPosition = MediaQuery.of(context).size.height * 0.3;
                        } else {
                          _changeCurrentAction();
                        }
                      });
                    },
                  ),
                );
              }
            },
            icon: Icon(_isMarkerDone(),),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      body: Stack(
          children: [
            Positioned.fill(child: GoogleMap(
                mapType: MapType.hybrid,
                markers: _markers,
                polygons: _polygons,
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
                    heroTag: "currentLocation",
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightBlue,
                    onPressed: () async {
                      Position position = await _determinePosition();
                      _goToCurrentLocation(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: _zoomValue));
                      setState(() {
                        _markers.add(
                          Marker(
                            markerId: const MarkerId('currentLocation'),
                            position: LatLng(position.latitude, position.longitude),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                          ),
                        );
                      });
                    },
                    child: const Icon(Icons.pin_drop),
                  ),
                )
            ),
            Positioned(
                bottom: MediaQuery.of(context).size.height / 2 - 40,
                right: 10,
                child: Column(
                  children: [
                    Visibility(
                      visible: currentAction == CurrentAction.markerAction ? true : false,
                      child: FloatingActionButton.small(
                        heroTag: "undoAction",
                        onPressed: () {
                          setState(() {
                            if (_points.length > 3) {
                              _markers.removeWhere((element) => (element.position == _points.last));
                              _points.removeLast();
                              _updatePolygon();
                            }
                          });
                        },
                        backgroundColor: _points.length > 3 ? Colors.orange : Colors.grey,
                        child: const Icon(
                          Icons.undo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Visibility(
                      visible: currentAction == CurrentAction.markerAction ? true : false,
                      child: FloatingActionButton.small(
                        heroTag: "deleteMarkers",
                        onPressed: () {
                          setState(() {
                            _markers = {};
                            _points = [];
                            _polygons = {};
                          });
                        },
                        backgroundColor: _points.isNotEmpty ? Colors.red : Colors.grey,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    FloatingActionButton.small(
                      heroTag: "zoomIn",
                      onPressed: () {
                        setState(() {
                          _zoomInAndOut(0.45);
                        });
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 5,),
                    FloatingActionButton.small(
                      heroTag: "zoomOut",
                      onPressed: () {
                        setState(() {
                          _zoomInAndOut(-0.45);
                        });
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.remove),
                    ),
                  ],
                )
            ),
            AnimatedPositioned(
              bottom: markerPillPosition,
              right: 15,
              left: 15,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: const SafeArea(
                child: MarkerPill(),
              ),
            ),
            AnimatedPositioned(
              top: attentionPosition,
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInBack,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset.zero,
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "Attention",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15,),
                        Text(
                          "You can add markers by tapping on the map. \n\nAnd click on a marker to see more details. \n\nTo see list of the markers, tap on button on the top left corner.",
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: checkedAttention,
                                onChanged: (value) {
                                  setState(() {
                                    checkedAttention = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Text("Do not show again",),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              attentionPosition = Consts.positions.ATTENTION_INVISIBLE;
                              _changeCurrentAction();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ]
      ),
    );
  }
}

class MarkerPill extends StatefulWidget {
  const MarkerPill({Key? key}) : super(key: key);

  @override
  State<MarkerPill> createState() => _MarkerPillState();
}

class _MarkerPillState extends State<MarkerPill> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset.zero,
              )
            ]
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 40,
              child: Divider(height: 3, thickness: 3,color: Colors.grey),
            ),
            const SizedBox(height: 25,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: ClipOval(
                    child: Icon(
                      Icons.location_on,
                      size: 70.0,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  flex: 4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Marker",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 30,)
          ],
        )
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({Key? key, required this.markersButtonPressed}) : super(key: key);

  final Function markersButtonPressed;

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
          const SizedBox(height: 10),
          MaterialButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => markersButtonPressed(),
            child: const ListTile(
              leading: Icon(Icons.add_location_rounded),
              title: Text("Markers"),
              enableFeedback: true,
            ),
          ),
          const Divider(height: 1.0, color: Colors.grey, indent: 15.0, endIndent: 15.0,),
          MaterialButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {

            },
            child: const ListTile(
              leading: Icon(Icons.flutter_dash),
              title: Text("Show items"),
              enableFeedback: true,
            ),
          ),
        ],
      ),
    );
  }
}