import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jingle_street/resources/res/app_theme.dart';

class TrackUser extends StatefulWidget {
  const TrackUser({Key? key}) : super(key: key);

  @override
  State<TrackUser> createState() => _TrackUserState();
}

class _TrackUserState extends State<TrackUser> {
  //initialvalues
  //googleMapController to create googlemap's displayView
  Completer<GoogleMapController> _controller = Completer();
  //from Geolocator package that will use to set the value of Lat and long from  the device currentLocation
  Position? _currentPosition;
  //destinationLat and Long their values will be call from the menuscreen
  //these destination latlong will be the values of current location of Customer Not the Vendor
  double destinationLatitude = 31.5043;
  double destinationLongitude = 74.3319;
  //List<LatLng> are the source and destination initial value that will be later on use in Polylines
  //also will use in function called getpolylines() to set the new updated polyline values in it.
  List<LatLng> polylineCoordinates = [];

  //bool type function that will inform if the Vendor has reach to the customer location
  bool isDestinationReached() {
    if (_currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        destinationLatitude,
        destinationLongitude,
      );
      return distanceInMeters <= 10;
    }
    return false;
  }
//function that creates polylines between source and destination point
  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU",
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      PointLatLng(destinationLatitude, destinationLongitude),
    );
    if (result.points.isNotEmpty) {
      List<PointLatLng> results = result.points;
      if (polylineCoordinates.isEmpty) {
        for (var point in results) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        polylineCoordinates.clear(); // Clear previous coordinates
        polylineCoordinates.addAll(results.map(
          (point) => LatLng(point.latitude, point.longitude),
        ));
      }
      if(mounted){
        setState(() {

        });
      }

    }
    // if (result.points.isNotEmpty) {
    //   List<PointLatLng> results =  result.points;
    //   for(var point in results){
    //     polylineCoordinates.add(
    //         LatLng(point.latitude, point.longitude));
    //   }
    //
    //
    //
    //   setState(() {});
    // }
  }
//getCurrentPosition() that will get location for the first time and update the position after every 2 seconds.
  _getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if(mounted){
        setState(() {
          _currentPosition = position;
        });
      }


      Geolocator.getPositionStream().listen((newLoc) {
          _currentPosition = newLoc;
          getPolyPoints();
          if (isDestinationReached()) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Destination Reached"),
                  content: Text("You have reached your destination."),
                );
              },
            );
          }
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
    if(mounted){
      _getCurrentPosition();
    }
    super.initState();
  }
  @override
  void dispose() {
    polylineCoordinates.clear();
    Geolocator.getPositionStream().listen((newLoc){}).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.appColor),
            )
          : GoogleMap(
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              mapType: MapType.normal,
        myLocationEnabled: true,
              markers: {
                // Marker(
                //   markerId: MarkerId("currentLocation"),
                //   position: LatLng(
                //     _currentPosition!.latitude,
                //     _currentPosition!.longitude,
                //   ),
                // ),
                // Marker(
                //   markerId: MarkerId("source"),
                //   position: LatLng(
                //     _currentPosition!.latitude,
                //     _currentPosition!.longitude,
                //   ),
                // ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: LatLng(destinationLatitude, destinationLongitude),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
              },
              initialCameraPosition: CameraPosition(
                 target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 15,
              ),
            ),
    );
  }
}
