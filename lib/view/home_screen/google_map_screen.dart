import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:jingle_street/Admob/ad_helper.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/profile_button.dart';
import 'package:jingle_street/resources/widgets/fields/search_field.dart';
import 'package:jingle_street/resources/widgets/googlemap/custom_info_window.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:http/http.dart' as http;
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/hashtag_search.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/menu_screen/menu_screen.dart';
import 'package:jingle_street/view/vendor_screen/vendor_profile_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

//Model class which is used on Drawer() function and inside Drawer() ListView.builder an gesturedetector is being used and sending data to VandorScreen.
class Vendor {
  final String businessName;
  final String address;
  final String profilepic;
  final String businesshours;
  final String location;
  final String hashtags;
  final double latitude;
  final double longitude;
  final String bio;
  final int type;
  final int statusCode;
  final id;
  final user_id;
  final following;
  final busy;
  final requested;
  final reqType;
  final customerLat;
  final customerLong;

  Vendor({
    required this.id,
    required this.location,
    required this.type,
    required this.statusCode,
    required this.bio,
    required this.businessName,
    required this.address,
    required this.profilepic,
    required this.businesshours,
    required this.hashtags,
    required this.latitude,
    required this.longitude,
    required this.user_id,
    this.following,
    this.busy,
    this.requested,
    this.reqType,
    this.customerLat,
    this.customerLong,
  });
}

class GoogleMapScreen extends StatefulWidget {
  final int? type;
  final String? token;

  const GoogleMapScreen({
    Key? key,
    this.type,
    this.token,
  }) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  //_controller for SearchField.
  TextEditingController _searchController = TextEditingController();

  //CustomInfoWindowController used in Function _onMapCreated to deploy InfoWindow on Map.
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  //Controller for GoogleMapController to initialize the Map.
  Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//function that create infoWindow and _customInfowindow on Map.
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
  }

//this method check internet connection. if the internet is available or not.
  void checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          hasInternet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        hasInternet = false;
      });
    }
  }

//getting user_id from sharedPreference
  String? user_id;

  //trigger time to setstate so that marker and update location Method can be trigger again
  Timer? timer;

  //check the type of Vendor
  int? _vendorType;

  //to check if internet is avaliable or not
  bool hasInternet = false;

  //bool value to check if the infoWindow is hidden or not
  bool checkIfHideWindowIsPressed = false;

  //to trigger visibility widget
  bool _hashtagVisible = false;

  //initializing DIO and App logger
  late AppDio dio;
  bool check = false;
  AppLogger Logger = AppLogger();

  //initilizing marker data, hashtag data and ProfilepicData
  late Stream<List<dynamic>> _futureGetpicture;
  late Future<List<dynamic>> _futureSortedNearestVendors;

  // late Stream<Set<Marker>> _futureGetVendor;
  Stream<List<dynamic>>? _searchHashTagFinalResult;
  Marker markers = Marker(markerId: MarkerId("1"), visible: false);

//Latitudes and longitudes of
  var storedLat;
  var storedLong;
  Position? _currentPosition;
  double? _getMobileVendorLocationLat;
  double? _getMobileVendorLocationlong;
  Map<String, dynamic>? gotIt;
  //googleAPIkey us
  //String googleAPiKey = "AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU";

  // getdatafromsharedPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   user_id = prefs.getString(PrefKey.id);
  //   storedLat = prefs.getDouble(PrefKey.lat);
  //   storedLong = prefs.getDouble(PrefKey.long);
  // }

  @override
  void initState() {
    // Load the InterstitialAd
    // _loadInterstitialAd();

    // // Show the InterstitialAd after a certain delay (e.g., 5 seconds)seconds
    // Future.delayed(Duration(seconds: 5), () {
    //   if (_interstitialAd != null) {
    //     _interstitialAd!.show();
    //   }
    // });
    dio = AppDio(context);
    Logger.init();
    //getdatafromsharedPrefs();
    _getLocationStoredInPref();
    _futureSortedNearestVendors = _SortedVendorsTobeShownOnDrawer();

    hasInternet = true;
    _getLocationPermission();
    _getCurrentPosition();
    _getMobileVendorLocationContinously();
    _futureGetpicture = _getVendorProfile();
    timer = Timer.periodic(Duration(seconds: 40), (timer) {
      if (mounted) {
        return setState(() {
          markers;
        });
      }
    });
    super.initState();
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offset = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final circleSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    return hasInternet
        ? Scaffold(
            key: _scaffoldKey,
            endDrawer: FutureBuilder(
                future: _futureSortedNearestVendors,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Drawer(
                      backgroundColor: AppTheme.whiteColor,
                      width: screenWidth,
                      child: Column(
                        children: [
                          AppBar(
                            actions: [],
                            elevation: 5,
                            toolbarHeight: 70,
                            shadowColor: Colors.black,
                            backgroundColor: AppTheme.whiteColor,
                            centerTitle: true,
                            title: AppText("Nearest Vendor",
                                size: 27,
                                color: AppTheme.appColor,
                                bold: FontWeight.bold),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: screenHeight,
                              width: screenWidth,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(2),
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Vendor vendor = snapshot.data![index];
                                    return vendor.statusCode == 1
                                        ? GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  VandorScreen(
                                                location: vendor.location,
                                                businessHours:
                                                    vendor.businesshours,
                                                businessName:
                                                    vendor.businessName,
                                                address: vendor.address,
                                                photo: vendor.profilepic,
                                                vType: vendor.type,
                                                id: vendor.id,
                                                lat: vendor.latitude + 0.0,
                                                long: vendor.longitude + 0.0,
                                                uType: vendor.user_id == user_id
                                                    ? 1
                                                    : 0,
                                                bio: vendor.bio,
                                                follow: vendor.following,
                                                busy: vendor.busy,
                                                requested: vendor.requested,
                                                reqType: vendor.reqType,
                                                customerLat: widget.type == 0
                                                    ? _currentPosition == null
                                                        ? ""
                                                        : _currentPosition!
                                                            .latitude
                                                    : "",
                                                customerlong: widget.type == 0
                                                    ? _currentPosition == null
                                                        ? ""
                                                        : _currentPosition!
                                                            .longitude
                                                    : "",
                                              ),
                                            )),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 2.h,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: vendor.type == 1
                                                          ? Colors.green
                                                          : Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  padding: EdgeInsets.only(
                                                    top: 3.h,
                                                    right: 15,
                                                    left: 20,
                                                  ),
                                                  height: screenHeight * 0.2,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  screenHeight *
                                                                      0.14,
                                                              width:
                                                                  screenWidth *
                                                                      0.29,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: NetworkImage(
                                                                          vendor
                                                                              .profilepic))),
                                                            ),
                                                            SizeBoxWidth16(),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    AppText(
                                                                      vendor
                                                                          .businessName,
                                                                      size:
                                                                          18.sp,
                                                                      bold: FontWeight
                                                                          .bold,
                                                                      color: AppTheme
                                                                          .whiteColor,
                                                                    ),
                                                                    SizeBoxHeight8(),
                                                                    AppText(
                                                                      vendor
                                                                          .hashtags,
                                                                      size:
                                                                          12.sp,
                                                                      bold: FontWeight
                                                                          .bold,
                                                                      color: AppTheme
                                                                          .whiteColor,
                                                                    ),
                                                                    SizeBoxHeight8(),
                                                                    vendor.type ==
                                                                            1
                                                                        ? AppText(
                                                                            "Mobile Vendor",
                                                                            size:
                                                                                12.sp,
                                                                            bold:
                                                                                FontWeight.normal,
                                                                            color:
                                                                                AppTheme.whiteColor,
                                                                          )
                                                                        : AppText(
                                                                            "Stationary Vendor",
                                                                            size:
                                                                                12.sp,
                                                                            bold:
                                                                                FontWeight.normal,
                                                                            color:
                                                                                AppTheme.whiteColor,
                                                                          ),
                                                                  ],
                                                                )),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: AppTheme
                                                                  .whiteColor,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          )
                                        : SizedBox();
                                  }),
                            ),
                          ),
                          Expanded(flex: 1, child: Container())
                        ],
                      ),
                    );
                  }
                }),
            drawerScrimColor: Colors.transparent,
            body: Stack(
              children: [
                StreamBuilder(
                  stream: _getVendor(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: AppTheme.appColor),
                      );
                    } else {
                      return _currentPosition == null && storedLat == null
                          ? Center(
                              child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.500,
                                ),
                                Text(
                                    "You have not Enable Location from \nApp settings, Please goto App settings\nto enable it, restart App. \nto use service for first time",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),
                              ],
                            ))
                          : GoogleMap(
                              onTap: (position) {
                                _customInfoWindowController.hideInfoWindow!();
                              },
                              onCameraMove: (position) {
                                _customInfoWindowController.onCameraMove!();
                              },
                              zoomControlsEnabled: false,
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              buildingsEnabled: true,
                              markers: snapshot.data,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    _currentPosition == null
                                        ? storedLat! + 0.0
                                        : _currentPosition!.latitude + 0.0,
                                    _currentPosition == null
                                        ? storedLong! + 0.0
                                        : _currentPosition!.longitude + 0.0),
                                zoom: 18.0,
                              ),
                            );
                    }
                  },
                ),
                //this is used to create custom window in google map screen
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 31.h,
                  width: 50.w,
                  offset: (40 / offset.height) * offset.height,
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40.0, left: 24, right: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SearchField(
                              onSubmitted: (value) async {
                                if (value.contains("#")) {
                                  setState(() {
                                    _hashtagVisible = true;
                                  });
                                  _searchHashTagFinalResult =
                                      _searchHasTags(searchValue: value);
                                } else if (value.contains("")) {
                                  setState(() {
                                    _hashtagVisible = false;
                                  });
                                }
                                if (value.contains(value)) {
                                  await _searchVendorsLocation(
                                      searchText: value);
                                  //here this Code Search the location of the Shop when we provide Address in SearchField
                                  GoogleMapController mapController =
                                      await _controller.future;

                                  mapController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        target: LatLng(
                                            gotIt!['lat'], gotIt!['lng']),
                                        zoom: 15.0),
                                  ));
                                }
                              },
                              borderRadius: BorderRadius.circular(50),
                              widthSearchBar: 200,
                              hintText: "Let's find local vendors!",
                              textEditingController: _searchController,
                              hintColor: Color.fromRGBO(247, 0, 0, 0.5),
                              fontSize: 15,
                            ),

                            // isLoadingImage? const CircularProgressIndicator():
                            widget.type == 1
                                ? StreamBuilder(
                                    stream: _futureGetpicture,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return Container(
                                          height: (155 / circleSize) * 100,
                                          width: (155 / circleSize) * 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppTheme.appColor)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    "assets/images/default.png")),
                                          ),
                                        );
                                      } else if (snapshot.hasData &&
                                          snapshot.data != null &&
                                          snapshot.data!.isNotEmpty) {
                                        var data = snapshot.data?[0] ?? "";
                                        return data != null
                                            ? ProfileButton(
                                                height: 125,
                                                width: 125,
                                                pic: data != null && data != ""
                                                    ? data["profilepic"] ?? ""
                                                    : "http://3.13.220.3/default.png",
                                                border: true,
                                                onTap: () async {
                                                  if (data == "") {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                        return VandorScreen(
                                                          businessHours: "",
                                                          businessName: "",
                                                          address: "",
                                                          location: "",
                                                          photo:
                                                              "http://3.13.220.3/default.png",
                                                          // vType: 1,
                                                          id: "",
                                                          lat: 0.0,
                                                          long: 0.0,
                                                          uType: 1,
                                                          bio:
                                                              "bio is Not mentioned",
                                                          customerLat: widget
                                                                      .type ==
                                                                  0
                                                              ? _currentPosition ==
                                                                      null
                                                                  ? ""
                                                                  : _currentPosition!
                                                                      .latitude
                                                              : "",
                                                          customerlong: widget
                                                                      .type ==
                                                                  0
                                                              ? _currentPosition ==
                                                                      null
                                                                  ? ""
                                                                  : _currentPosition!
                                                                      .longitude
                                                              : "",
                                                        );
                                                      }),
                                                    );
                                                  } else {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                        return VandorScreen(
                                                          businessHours: data[
                                                                  "businesshours"] ??
                                                              "",
                                                          businessName: data[
                                                                  "businessname"] ??
                                                              "",
                                                          address:
                                                              data["address"] ??
                                                                  "",
                                                          location: data[
                                                                  "location"] ??
                                                              "",
                                                          photo: data[
                                                                  "profilepic"] ??
                                                              "",
                                                          vType: data['type'],
                                                          id: data["id"],
                                                          lat:
                                                              data["latitude"] +
                                                                  0.0,
                                                          long: data[
                                                                  "longitude"] +
                                                              0.0,
                                                          uType:
                                                              data["user_id"] ==
                                                                      user_id
                                                                  ? 1
                                                                  : 0,
                                                          bio: data["bio"] ??
                                                              "bio is Not mentioned",
                                                          busy: data["busy"],
                                                          requested:
                                                              data["requested"],
                                                          reqType: widget.type,
                                                          customerLat: widget
                                                                      .type ==
                                                                  0
                                                              ? _currentPosition ==
                                                                      null
                                                                  ? ""
                                                                  : _currentPosition!
                                                                      .latitude
                                                              : "",
                                                          customerlong: widget
                                                                      .type ==
                                                                  0
                                                              ? _currentPosition ==
                                                                      null
                                                                  ? ""
                                                                  : _currentPosition!
                                                                      .longitude
                                                              : "",
                                                        );
                                                      }),
                                                    );
                                                  }
                                                },
                                              )
                                            : ProfileButton(
                                                height: 125,
                                                width: 125,
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        VendorProfile(),
                                                  ));
                                                });
                                      }
                                      return Container(
                                        height: (155 / circleSize) * 100,
                                        width: (155 / circleSize) * 100,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1,
                                                color: AppTheme.appColor)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/images/default.png")),
                                        ),
                                      );
                                    },
                                  )
                                : StreamBuilder(
                                    stream: _futureGetpicture,
                                    builder: (context, snapshot) {
                                      return SizedBox();
                                    },
                                  ),
                          ],
                        ),
                        Stack(
                          children: [
                            Visibility(
                                visible: _hashtagVisible,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _hashtagVisible = false;
                                      _searchController.text = "";
                                    });
                                  },
                                  child: Container(
                                      color: Colors.transparent,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      width: MediaQuery.of(context).size.width),
                                )),
                            SearchHashTag(
                              type: widget.type,
                              hashtagVisible: _hashtagVisible,
                              stream: _searchHashTagFinalResult,
                              customerLat: widget.type == 0
                                  ? _currentPosition == null
                                      ? ""
                                      : _currentPosition!.latitude
                                  : "",
                              customerLong: widget.type == 0
                                  ? _currentPosition == null
                                      ? ""
                                      : _currentPosition!.longitude
                                  : "",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 35.h,
                  child: Container(
                      decoration: BoxDecoration(
                          color: AppTheme.appColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30))),
                      height: 60,
                      width: 50,
                      child: GestureDetector(
                          onHorizontalDragEnd: (DragEndDetails details) {
                            if (details.primaryVelocity! < 0) {
                              _scaffoldKey.currentState!.openEndDrawer();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  scale: 0.04 * screenWidth,
                                  image: AssetImage(
                                      "assets/images/slideLeftToShowVendorsIcon.png")),
                            ),
                            width: 50,
                            height: 50,
                          ))),
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 95.0),
              child: FloatingActionButton(
                backgroundColor: AppTheme.appColor,
                child: Icon(Icons.my_location),
                onPressed: () async {
                  try {
                    Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high)
                        .then(
                      (Position result) async {
                        GoogleMapController mapController =
                            await _controller.future;
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(result.latitude + 0.0,
                                    result.longitude + 0.0),
                                zoom: 18.0),
                          ),
                        );
                      },
                    );
                  } catch (e) {
                    print("_________$e");
                  }
                },
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Internet Connection Weak'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        initState();
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
  }

  //function that get user_id from shared preferences
  Future<void> getuserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    user_id = _prefs.getString(PrefKey.id);
  }

  // function that gets mobile Vendor Location Continously
  _getMobileVendorLocationContinously() async {
    var response;

    try {
      response = await dio.get(
        path: AppUrls.getVendorProfile,
      );

      var responseData = response.data;

      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          var data = responseData['data']['vendorprofile'] ?? [];
          setState(() {
            _vendorType = data["type"];
          });
        }
      }
    } catch (e, s) {
      print(e);

      print(s);
    }
    if (_vendorType == 1) {
      timer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
        return Geolocator.getCurrentPosition().then((event) async {
          _getMobileVendorLocationLat = event.latitude + 0.0;
          _getMobileVendorLocationlong = event.longitude + 0.0;

          response = await dio.post(path: AppUrls.updateLocation, data: {
            "latitude": _getMobileVendorLocationLat,
            "longitude": _getMobileVendorLocationlong
          });
        });
      });
    } else {}
  }

//asks permission if the Permission is avaliable or not
  Future<bool> _getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openLocationSettings();
        await ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      }
      if (permission == LocationPermission.always) {
        return true;
      }

      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

//Function that generate lat long for first time to use it on google map.
  _getCurrentPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        prefs.setDouble(PrefKey.lat, value.latitude + 0.0);
        prefs.setDouble(PrefKey.long, value.longitude + 0.0);
        _currentPosition = value;
      });

      setState(() {
        check = true;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text("The location service on the device is disabled"),
              ),
              SizedBox(height: 50)
            ],
          );
        },
      );
    }
  }

//this function gets stored lat long in shared preferences. which was saved in _getCurrentPosition.
  _getLocationStoredInPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble(PrefKey.lat);
    double? longitude = prefs.getDouble(PrefKey.long);
    setState(() {
      storedLat = latitude;
      storedLong = longitude;
      user_id = prefs.getString(PrefKey.id);
    });
  }

//method to create _searchHashTags
  Stream<List<dynamic>> _searchHasTags({String? searchValue}) async* {
    var response;
    List<dynamic> _list2 = [];
    try {
      response = await dio.post(path: AppUrls.searchHasTag, data: {
        "hashtags": searchValue,
      });
      var responseData = response.data;
      if (response.statusCode == StatusCode.OK) {
        var vendorList = List.from(responseData['data']);

        _list2.addAll(vendorList);
      }
    } catch (e) {
      print(e);
    }
    yield _list2;
  }

//this function sorts data of Vendor Nearst along with the current position of the person. and shows Nearest Vendors List Details on Drawer()
  Future<List<dynamic>> _SortedVendorsTobeShownOnDrawer() async {
    var response;
    List<dynamic> sortedVendors = [];
    try {
      response = await dio.get(
        path: AppUrls.getVendor,
      );
      var responseData = response.data;
      if (response.statusCode == StatusCode.OK) {
        var data = responseData['data']['vendors'];
        for (var vendorData in data) {
          sortedVendors.addAll([
            Vendor(
              id: vendorData["id"] ?? "",
              location: vendorData["location"] ?? "",
              type: vendorData["type"],
              bio: vendorData["bio"] ?? "Bio Missing",
              businessName: vendorData["businessname"],
              address: vendorData["address"],
              profilepic: vendorData["profilepic"],
              businesshours: vendorData["businesshours"] ??
                  "Vendor Did Not Mentioned Business Hours",
              hashtags: vendorData["hashtags"],
              user_id: vendorData["user_id"],
              latitude: vendorData["latitude"] + 0.0,
              longitude: vendorData["longitude"] + 0.0,
              statusCode: vendorData["status"],
              following: vendorData["is_following"],
              busy: vendorData["busy"],
              requested: vendorData["requested"],
              reqType: widget.type,
            )
          ]);

          sortedVendors.sort((a, b) {
            double distanceToA = calculateDistance(
              storedLat ?? 0.0,
              storedLong ?? 0.0,
              a.latitude + 0.0,
              a.longitude + 0.0,
            );

            double distanceToB = calculateDistance(
              storedLat ?? 0.0,
              storedLong ?? 0.0,
              b.latitude,
              b.longitude,
            );
            return distanceToA.compareTo(distanceToB);
          });
        }
      }
    } catch (e, s) {
      print("dyufgewbfhegf${e}");
    }
    ;
    return sortedVendors;
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double lat1 = degreesToRadians(startLatitude);
    double lon1 = degreesToRadians(startLongitude);
    double lat2 = degreesToRadians(endLatitude);
    double lon2 = degreesToRadians(endLongitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

//this method get Vendors Data from API to Set it on GoogleMaps
  Stream<Set<Marker>> _getVendor() async* {
    if (check) {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString(PrefKey.email);
      var response;

      double markerSize(BuildContext context) {
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;

        // Specify a size in logical pixels
        final logicalSize = 35;

        // Convert the size to physical pixels
        final physicalSize = logicalSize * pixelRatio;
        return physicalSize;

        //  // Adjust this value to adjust the size of the marker
      }

      Set<Marker> _list = {};
      try {
        response = await dio.get(
            path: AppUrls.getVendor,
            options: Options(responseType: ResponseType.json));
        var responseData = response.data;
        if (response.statusCode == StatusCode.OK) {
          var data = responseData['data']['vendors'];

          for (var marker in data) {
            final imageData = marker["profilepic"];
            if (marker["status"] == 1) {
              markers = Marker(
                onTap: () {
                  if (marker["type"] == 0) {
                    _customInfoWindowController.addInfoWindow!(
                        infoWindow(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VandorScreen(
                                  businessName: marker["businessname"] ?? "",
                                  address: marker["address"] ?? "",
                                  location: marker["location"] ?? "",
                                  photo: marker["profilepic"] ?? "",
                                  vType: marker['type'],
                                  id: marker["id"],
                                  lat: marker["latitude"] + 0.0,
                                  long: marker["longitude"] + 0.0,
                                  uType: marker["user_id"] == user_id ? 1 : 0,
                                  businessHours: marker["businesshours"] ??
                                      "business hours Not Mentioned",
                                  bio: marker["bio"] ?? "Bio is not mentioned",
                                  follow: marker['is_following'],
                                  busy: marker["busy"],
                                  requested: marker["requested"],
                                  reqType: widget.type,
                                  customerLat: widget.type == 0
                                      ? _currentPosition == null
                                          ? ""
                                          : _currentPosition!.latitude
                                      : "",
                                  customerlong: widget.type == 0
                                      ? _currentPosition == null
                                          ? ""
                                          : _currentPosition!.longitude
                                      : "",
                                ),
                              ));
                            },
                            type: 0,
                            businessName: marker["businessname"],
                            address: marker["address"],
                            businessHours: marker["businesshours"] ??
                                "Business Hours Not mentioned",
                            hashTags: marker["hashtags"],
                            imageUrl: imageData),
                        LatLng(marker["latitude"] + 0.0,
                            marker["longitude"] + 0.0));
                  } else {
                    _customInfoWindowController.addInfoWindow!(
                        infoWindow(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VandorScreen(
                                  businessName: marker["businessname"] ?? "",
                                  address: marker["address"] ?? "",
                                  location: marker["location"] ?? "",
                                  photo: marker["profilepic"] ?? "",
                                  vType: marker['type'],
                                  id: marker["id"],
                                  lat: marker["latitude"] + 0.0,
                                  long: marker["longitude"] + 0.0,
                                  uType: marker["user_id"] == user_id ? 1 : 0,
                                  businessHours: marker["businesshours"] ??
                                      "business hours not mentioned",
                                  bio: marker["bio"] ?? "Bio is not mentioned",
                                  follow: marker['is_following'],
                                  reqType: widget.type,
                                  customerLat: widget.type == 0
                                      ? _currentPosition == null
                                          ? ""
                                          : _currentPosition!.latitude
                                      : "",
                                  customerlong: widget.type == 0
                                      ? _currentPosition == null
                                          ? ""
                                          : _currentPosition!.longitude
                                      : "",
                                ),
                              ));
                            },
                            type: 1,
                            businessName: marker["businessname"],
                            businessHours: marker["businesshours"] ??
                                "Business Hours Not mentioned",
                            address: marker["address"],
                            hashTags: marker["hashtags"],
                            imageUrl: imageData),
                        LatLng(marker["latitude"] + 0.0,
                            marker["longitude"] + 0.0));
                  }
                },
                icon: await MarkerIcon.downloadResizePictureCircle(imageData,
                    addBorder: true,
                    borderColor:
                        marker["type"] == 0 ? Colors.blue : Colors.green,
                    borderSize: 5,
                    size: markerSize(context).toInt()),
                markerId: MarkerId("${marker["id"]}"),
                position: marker["type"] == 1
                    ? LatLng(
                        marker["latitude"] + 0.0, marker["longitude"] + 0.0)
                    : LatLng(
                        marker["latitude"] + 0.0, marker["longitude"] + 0.0),
              );
            } else {
              markers = Marker(markerId: MarkerId("1"), visible: false);
            }
            _list.add(markers);
          }
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
      yield _list;
    }
  }

  Stream<List<dynamic>> _getVendorProfile() async* {
    var response;
    List<dynamic> _profile = [];
    try {
      response = await dio.get(
        path: AppUrls.getVendorProfile,
      );
      var responseData = response.data;
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Server Down')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          var data = responseData['data']['vendorprofile'];

          int notifyCount = resData["data"]["user"]["noti_count"];
          _profile.add(data);
          Prefs.getPrefs().then((value) {
            print("nnfnrefjrnfnnjgjb$notifyCount");
            value.setInt(PrefKey.nottifyCount, notifyCount);
          });
        }
      }
    } catch (e, s) {
      print("_____$e");
      print("_____$s");
    }
    yield _profile;
  }

//this method search address inserted in Searchfield to locate position where the marker or the AREA is
  _searchVendorsLocation({String? searchText}) async {
    String apiKey = 'AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$searchText&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        Map<String, dynamic> location =
            data['results'][0]['geometry']['location'];
        setState(() {
          gotIt = location;
        });
      } else {
        throw Exception('Failed to geocode address: $searchText');
      }
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }
}
