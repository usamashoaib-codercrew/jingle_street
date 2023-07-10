import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackUser extends StatefulWidget {
  const TrackUser({Key? key}) : super(key: key);

  @override
  State<TrackUser> createState() => _TrackUserState();
}

class _TrackUserState extends State<TrackUser> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  double destinationLatitude = 31.5043;
  double destinationLongitude = 74.3319;
  List<LatLng> polylineCoordinates = [];

  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU", // Replace with your Google Maps API key
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      PointLatLng(destinationLatitude, destinationLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  _getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      getPolyPoints();
      Geolocator.getPositionStream().listen((newLoc) {
        setState(() {
          _currentPosition = newLoc;
        });
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("The location service on the device is disabled"),
          );
        },
      );
    }
  }

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : GoogleMap(
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        mapType: MapType.normal,
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
          ),
          Marker(
            markerId: MarkerId("source"),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: LatLng(destinationLatitude, destinationLongitude),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0xFF7B61FF),
            width: 6,
          ),
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 20,
        ),
      ),
    );
  }
}
