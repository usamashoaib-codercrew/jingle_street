import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/global_variables.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/view/home_screen/home_nav_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:sizer/sizer.dart';

class TrackUser extends StatefulWidget {
  final requestId;
  final type;
  final CustomerId;
  final VendorId;

  const TrackUser(
      {Key? key, this.requestId, this.type, this.CustomerId, this.VendorId})
      : super(key: key);

  @override
  State<TrackUser> createState() => _TrackUserState();
}

class _TrackUserState extends State<TrackUser> {
  late AppDio dio;
  late int type;
  String token = '';
  String? name;
  String? id;
  var remoteMessage;

  //initialvalues
  //googleMapController to create googlemap's displayView
  Completer<GoogleMapController> _controller = Completer();

  //from Geolocator package that will use to set the value of Lat and long from  the device currentLocation
  Position? _currentPosition;

  //destinationLat and Long their values will be call from the menuscreen
  //these destination latlong will be the values of current location of Customer Not the Vendor
  double? destinationLatitude;
  double? destinationLongitude;

  //this initvalues are for usersource tracking where user can see vendor tracking
  double? sourceLatfromTrackAPI;
  double? sourceLongfromTrackAPI;

  //List<LatLng> are the source and destination initial value that will be later on use in Polylines
  //also will use in function called getpolylines() to set the new updated polyline values in it.
  List<LatLng> polylineCoordinates = [];
  Timer? timer;
  AppLogger Logger = AppLogger();

  //bool type function that will inform if the Vendor has reach to the customer location

  getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      name = prefs.getString(PrefKey.name);
      id = prefs.getString(PrefKey.id);
      token = prefs.getString(PrefKey.authorization) ?? "";
      type = prefs.getInt(PrefKey.type) ?? 0;
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print("getdata_cancel ${message.data}");
      if (message.data['actions'] == "Notification") {
        Future.wait([
          Prefs.remove('req_id'),
          Prefs.remove('setUserType'),
        ]).then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeNavScreen(
                type: widget.type,
                token: token,
                name: name,
                id: id,
                index: 1,
              ),
            ),
          );
        });
      }

      // Map<String, dynamic> data = json.decode(message.data['Review']);
      // remoteMessage = data;
      // print("getdata_cancel ${remoteMessage}");
    });
  }

//function that creates polylines between source and destination point
  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU",
      widget.type == 1
          ? PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude)
          : PointLatLng(sourceLatfromTrackAPI!, sourceLongfromTrackAPI!),
      PointLatLng(destinationLatitude!, destinationLongitude!),
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
      if (mounted) {
        setState(() {});
      }
    }
  }

  updateLocationOfVendor() async {
    var response;
    response = await dio.post(path: AppUrls.updateLocation, data: {
      "latitude": _currentPosition!.latitude,
      "longitude": _currentPosition!.longitude,
    });
    print("askdjaklsd${response.data}");
  }

  getvendorLatLongContinously() {
    if (widget.type == 1) {
      Geolocator.getPositionStream().listen((newLoc) {
        _currentPosition = newLoc;
        getPolyPoints();
        if (isDestinationReached()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('You have reached your destination.')));
          }
        }
      });
    }
  }

//getCurrentPosition() that will get location for the first time and update the position after every 2 seconds.
  _getCurrentPosition() async {
    try {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        if (mounted) {
          setState(() {
            _currentPosition = value;
          });
        }
      });

      if (widget.type == 1) {
        timer = Timer.periodic(
          Duration(seconds: 20),
          (timer) {
            updateLocationOfVendor();
          },
        );
      } else {
        timer = Timer.periodic(
          Duration(seconds: 25),
          (timer) {
            getPolyPoints();
            if (isDestinationReached()) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Vendor has reached to your destination')));
            }
          },
        );
      }
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

  bool isDestinationReached() {
    if (_currentPosition != null) {
      if (widget.type == 1) {
        double distanceInMeters = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          destinationLatitude!,
          destinationLongitude!,
        );
        return distanceInMeters <= 10;
      } else {
        double distanceInMeters = Geolocator.distanceBetween(
          sourceLatfromTrackAPI!,
          sourceLongfromTrackAPI!,
          destinationLatitude!,
          destinationLongitude!,
        );
        return distanceInMeters <= 10;
      }
    }
    return false;
  }

  //this will update the track for customer
  updateTrackForCustomer() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      return setState(() {
        StartTracking();
      });
    });
  }

  @override
  void initState() {
    dio = AppDio(context);
    Logger.init();
    StartTracking();
    getUserData();
    _getCurrentPosition();
    getvendorLatLongContinously();
    updateTrackForCustomer();
    firebaseInit(context);
    super.initState();
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    polylineCoordinates.clear();
    Geolocator.getPositionStream().listen((newLoc) {}).cancel();
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null || destinationLatitude == null
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.appColor),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                  mapType: MapType.normal,
                  myLocationEnabled: widget.type == 1 ? true : false,
                  markers: {
                    // Marker(
                    //   markerId: MarkerId("currentLocation"),
                    //   position: LatLng(
                    //     _currentPosition!.latitude,
                    //     _currentPosition!.longitude,
                    //   ),
                    // ),
                    widget.type == 0
                        ? Marker(
                            markerId: MarkerId("source"),
                            infoWindow: InfoWindow(title: "Vendor"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen),
                            position: LatLng(
                              sourceLatfromTrackAPI!,
                              sourceLongfromTrackAPI!,
                            ),
                          )
                        : Marker(
                            visible: false,
                            markerId: MarkerId("source"),
                          ),
                    Marker(
                      markerId: MarkerId("destination"),
                      infoWindow: InfoWindow(title: "Customer"),
                      position:
                          LatLng(destinationLatitude!, destinationLongitude!),
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
                    target: widget.type == 1
                        ? LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          )
                        : LatLng(
                            sourceLatfromTrackAPI!,
                            sourceLongfromTrackAPI!,
                          ),
                    zoom: 15,
                  ),
                ),
                widget.type == 0
                    ? Positioned(
                        top: 6.h,
                        left: 7.w,
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: AppTheme.appColor,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                            icon: Center(
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ))
                    : SizedBox(),
                widget.type == 1
                    ? Positioned(
                        bottom: 8.h,
                        left: 7.w,
                        child: Container(
                          width: 100,
                          color: AppTheme.appColor,
                          child: TextButton(
                            onPressed: () {
                              endTrackingApi();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeNavScreen(
                                            type: widget.type,
                                            token: token,
                                            name: name,
                                            id: id,
                                          )));
                            },
                            child: Text(
                              "EndTrack",
                              style: TextStyle(color: AppTheme.whiteColor),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
    );
  }

  endTrackingApi() async {
    var response;
    try {
      response = await dio.post(path: AppUrls.endTracking, data: {
        "req_id": widget.requestId,
      });
      var responseData = response.data;
      print("tracking response $responseData");
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server Down. Please try again.')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          await Prefs.remove('req_id');
          await Prefs.remove('setUserType');
        }
      }
    } catch (e) {
      print("Tracking Exception $e");
    }
  }

  StartTracking() async {
    print("api is hit");
    var response;
    try {
      response = await dio.post(path: AppUrls.tracking, data: {
        "req_id": widget.requestId,
      });
      var responseData = response.data;

      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server Down. Please try again.')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          print("trackingdata for Customer${resData}");
          if (mounted) {
            setState(() {
              sourceLatfromTrackAPI = resData["data"]["sourceLatitude"];
              sourceLongfromTrackAPI = resData["data"]["sourceLongitude"];
              destinationLatitude = resData["data"]["destinationLatitude"];
              destinationLongitude = resData["data"]["destinationLongitude"];
              Prefs.setString('req_id', widget.requestId);
              Prefs.setInt('setUserType', widget.type);
            });
          }
        }
      }
    } catch (e) {
      print("Tracking Exception $e");
    }
  }
}
