import 'dart:convert';

import 'package:dialogs/dialogs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/providers/request_timer.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/home_screen/track_system/track_vendor.dart';
import 'package:jingle_street/view/menu_screen/menu_screen.dart';
import 'package:jingle_street/view/menu_screen/vendor_review_screen.dart';
import 'package:provider/provider.dart';
import 'package:req_fun/req_fun.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class NotificationScreen extends StatefulWidget {
  final int? type;
  final String? token;
  final String? vId;
  const NotificationScreen({super.key, this.type, this.token, this.vId});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late AppDio dio;
  bool loading = false;
  var resData;
  String? location;

  List<dynamic> vendorData = [];
  Map<String, dynamic>? desiredVendor;
  var remoteMessage;
  Position? _currentPosition;
  double? distanceInMeters;

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      // if (message.data["actions"] == "Notification") {
      //   Map<String, dynamic> data = json.decode(message.data['Review']);
      //   remoteMessage = data;
      //   location = await getLocation(
      //       remoteMessage["latitude"], remoteMessage["longitude"]);
      //   if (mounted) {
      //     setState(() {
      //       getNOtifications();
      //     });
      //   }
      // }
      if (mounted) {
        setState(() {
          getNOtifications();
        });
      }
    });
  }

  getLocation(double latitude, double longitude) async {
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        geocoding.Placemark placemark = placemarks[0];

        String name = placemark.name ?? '';
        String subThoroughfare = placemark.subThoroughfare ?? '';
        String thoroughfare = placemark.thoroughfare ?? '';
        String subLocality = placemark.subLocality ?? '';
        String locality = placemark.locality ?? '';
        String administrativeArea = placemark.administrativeArea ?? '';
        String country = placemark.country ?? '';

        String address =
            '$name $subThoroughfare $thoroughfare $subLocality $locality $administrativeArea $country';
        if (location == null) {
          setState(() {
            location = address;
          });
        } else {}
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  _getCurrentPosition() async {
    try {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        _currentPosition = value;print("vdvhdhhhdevhf$_currentPosition");
      });
    } catch (e) {
      print("exception ${e.toString()}");
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

  @override
  void initState() {
    dio = AppDio(context);
    getNOtifications();
    _getCurrentPosition();
    // isDestinationReached();
    firebaseInit(context);

    super.initState();
  }

  void isDestinationReached() {
    if (_currentPosition != null) {
      if (distanceInMeters == null) {
        setState(() {
          distanceInMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            remoteMessage['latitude'],
            remoteMessage['longitude'],
            // 31.5435,//latitude
            // 74.3543//longitude
          );
        });
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.appColor,
      appBar: SimpleAppBar1(
        text: "Notifications",
        onTap: () {
          pop(context);
        },
      ),
      body: resData == null
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.whiteColor),
            )
          : ListView.builder(
              itemCount: resData.length,
              itemBuilder: (context, index) {
                if (resData[index]["action"] == "Notification") {
                  final updatedAtInMillis = resData[index]['updatedAt'];

                  findLocation(
                      resData[index]["latitude"], resData[index]["longitude"]);

                  return customerRequest(index);
                } else if (resData[index]["action"] == "None") {
                  return requestCancelledWidget(index);
                } else if (resData[index]["action"] == "Tracking") {
                  return requestAcceptedWidget(index);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          seenNotifications(resData[index]["id"]);
                          String id = resData[index]["vendor_id"];
                          for (var vendor in vendorData) {
                            if (vendor["id"] == id) {
                              desiredVendor = vendor;
                            }
                          }

                          if (resData[index]["action"] == "Review") {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return VendorReviewScreen(
                                    profileImage:
                                        desiredVendor!["profilepic"] ??
                                            "http://3.13.220.3/default.png",
                                    location: desiredVendor!["location"],
                                    address: desiredVendor!["address"] ?? "",
                                    vType: desiredVendor!["type"] ?? "",
                                    uType: widget.type == 1
                                        ? widget.vId ==
                                                desiredVendor!["user_id"]
                                            ? 1
                                            : 0
                                        : 0,
                                    vId: desiredVendor!["id"],
                                    lat: desiredVendor!["latitude"] ?? "",
                                    lon: desiredVendor!["longitude"] ?? "",
                                    businessName:
                                        desiredVendor!["businessname"] ?? "");
                              },
                            ));
                          } else if (resData[index]["action"] == "Home") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VandorScreen(
                                    businessName:
                                        desiredVendor!["businessname"],
                                    bio: desiredVendor!["bio"],
                                    businessHours:
                                        desiredVendor!["businesshours"],
                                    photo: desiredVendor!["profilepic"],
                                    address: desiredVendor!["address"],
                                    lat: desiredVendor!["latitude"],
                                    long: desiredVendor!["longitude"],
                                    vType: desiredVendor!["type"],
                                    id: desiredVendor!["id"],
                                    uType: widget.type,
                                    location: desiredVendor!["location"],
                                    follow: desiredVendor!["is_following"],
                                  ),
                                ));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 14.0,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "${resData[index]["image"]}"),
                                    radius: 22,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.71,
                                            child: Text(
                                              "${resData[index]["message"]}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizeBoxHeight10(),
                                      formatTimestampWidget(
                                          timestamp: resData[index]
                                              ["updatedAt"]),
                                    ],
                                  ),
                                ],
                              ),
                              resData[index]["seen"] != 1
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.yellow,
                                        radius: 5,
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Divider(
                          thickness: 0.6,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  Future<void> getNOtifications() async {
    loading = true;
    var response;

    try {
      response = await dio.get(
        path: AppUrls.getNotify,
      );

      var responseData = response.data;

      if (loading) {
        loading = false;
      }

      if (response.statusCode == StatusCode.OK) {
        resData = responseData["data"];
        // print("object$resData");
        getVendorProfile();
        setState(() {});
      }
    } catch (e, s) {
      print(e);
      print(s);

      MessageDialog(title: e.toString(), message: response["message"])
          .show(context);
    }
  }

  Text formatTimestampWidget({required int timestamp}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('d MMM').format(dateTime);
    var formattedTime = DateFormat('h:mm a').format(dateTime);

    return Text(
      '$formattedDate at $formattedTime',
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppTheme.whiteColor),
    );
  }
////////////////////////////////////////
  ///

  getVendorProfile() async {
    var response;

    try {
      response = await dio.get(
        path: AppUrls.getVendor,
      );
      var responseData = response.data;
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Server Down')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          vendorData = responseData['data']['vendors'];
          if (mounted) {
            setState(() {});
          }
        }
      }
    } catch (e, s) {
      print("_____$e");
      print("_____$s");
    }
  }
  ///////////////////////////////////////////////////////////

  seenNotifications(id) async {
    // print("090$id");
    var response;
    try {
      response = await dio.post(path: AppUrls.seenNotification, data: {
        'noti_id': id,
      });
      var responseData = response.data;

      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Server Down')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          getNOtifications();
        }
      }
    } catch (e, s) {
      print("_____$e");
      print("_____$s");
    }
  }

  Widget customerRequest(int index) {
    print("object123123$location");
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        // 'Monika Hanson',
                        "${resData[index]["message"]}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Consumer<TimerProvider>(
                      builder: (context, timerProvider, child) {
                        final updatedAtInMillis = resData[index]['updatedAt'];
                        timerProvider.startTimer(
                            resData[index]["id"], updatedAtInMillis);
                        final timerText =
                            timerProvider.getTimeString(resData[index]["id"]);
                        // print("134$timerText");
                        return
                            //
                            timerText != "0:00"
                                ? Center(
                                    child: AppText(
                                      timerText,
                                      size: 15,
                                      bold: FontWeight.bold,
                                      color: AppTheme.whiteColor,
                                    ),
                                  )
                                : SizedBox();
                        // denyRequest(index);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Text(
                //   // 'Distance: 1.2 KM',
                //   // 'Distance: ${(distanceInMeters! / 1000).toStringAsFixed(2)} KM',
                //   distanceInMeters == null
                //       ? 'Distance: 1.00 KM'
                //       : 'Distance: ${distanceInMeters! >= 1000 ? (distanceInMeters! / 1000).toStringAsFixed(2) + " km" : distanceInMeters!.toStringAsFixed(2) + " meters"}',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.white,
                //   ),
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.yellow,
                    ),
                    Expanded(
                      child: Text(
                        location == null ? 'Loading...' : ' $location',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          // accept request
                          acceptRequest(index);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackUser(
                                        requestId: resData[index]["req_id"],
                                        type: widget.type,
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 110,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: AppText(
                              "Accept",
                              color: AppTheme.appColor,
                              size: 16,
                              bold: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      InkWell(
                        onTap: () {
                          // deny request
                          denyRequest(index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 110,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: AppText(
                              "Deny",
                              color: AppTheme.whiteColor,
                              size: 16,
                              bold: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              thickness: 0.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget getDirectionsWidget(int index) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage("${resData[index]["image"]}"),
                          radius: 22,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  "${resData[index]["message"]}",
                                  ellipsis: true,
                                  size: 20,
                                  bold: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizeBoxHeight10(),
                            formatTimestampWidget(
                                timestamp: resData[index]["updatedAt"]),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            resData[index]["seen"] != 1
                                ? CircleAvatar(
                                    backgroundColor: Colors.yellow,
                                    radius: 5,
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(top: 40, right: 15),
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AppText(
                    "Get Directions",
                    size: 15,
                    bold: FontWeight.bold,
                    color: AppTheme.appColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(
            thickness: 0.6,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget requestCancelledWidget(int index) {
    return InkWell(
      onTap: (){
        seenNotifications(resData[index]["id"]);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage("${resData[index]["image"]}"),
                            radius: 22,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  // AppText(
                                  //   "${resData[index]["message"]}",
                                  //   ellipsis: true,
                                  //   size: 20,
                                  //   bold: FontWeight.w400,
                                  // ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.71,
                                    child: Text(
                                      "${resData[index]["message"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizeBoxHeight10(),
                              formatTimestampWidget(
                                  timestamp: resData[index]["updatedAt"]),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 33,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              resData[index]["seen"] != 1
                                  ? CircleAvatar(
                                      backgroundColor: Colors.yellow,
                                      radius: 5,
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              thickness: 0.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget requestRejectedWidget(int index) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage("${resData[index]["image"]}"),
                          radius: 22,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  "${resData[index]["message"]}",
                                  ellipsis: true,
                                  size: 20,
                                  bold: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizeBoxHeight10(),
                            formatTimestampWidget(
                                timestamp: resData[index]["updatedAt"]),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            resData[index]["seen"] != 1
                                ? CircleAvatar(
                                    backgroundColor: Colors.yellow,
                                    radius: 5,
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(
            thickness: 0.6,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget requestAcceptedWidget(int index) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage("${resData[index]["image"]}"),
                          radius: 22,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                // AppText(
                                //   "${resData[index]["message"]}",
                                //   ellipsis: true,
                                //   size: 20,
                                //   bold: FontWeight.w400,
                                // ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.71,
                                  child: Text(
                                    "${resData[index]["message"]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizeBoxHeight10(),
                            formatTimestampWidget(
                                timestamp: resData[index]["updatedAt"]),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            resData[index]["seen"] != 1
                                ? CircleAvatar(
                                    backgroundColor: Colors.yellow,
                                    radius: 5,
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  // trackingApi(index);
                  seenNotifications(resData[index]["id"]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackUser(
                                requestId: resData[index]["req_id"],
                                type: widget.type,
                              )));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40, right: 15),
                  width: 110,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: AppText(
                      "Get Directions",
                      size: 15,
                      bold: FontWeight.bold,
                      color: AppTheme.appColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(
            thickness: 0.6,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  //accept request api
  acceptRequest(int index) async {
    var response;

    try {
      response = await dio.post(path: AppUrls.acceptRequest, data: {
        "accept": 1,
        "req_id": resData[index]["req_id"],
      });
      var responseData = response.data;
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server Down. Please try again.')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          setState(() {
            getNOtifications();
          });
        }
      }
    } catch (e) {
      print("Accept Request Exception $e");
    }
  }

  //accept request api
  trackingApi(int index) async {
    var response;

    try {
      response = await dio.post(path: AppUrls.tracking, data: {
        "req_id": resData[index]["req_id"],
      });
      var responseData = response.data;
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server Down. Please try again.')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {}
      }
    } catch (e) {
      print("Tracking Exception $e");
    }
  }

  //deny request api
  denyRequest(int index) async {
    var response;

    try {
      response = await dio.post(path: AppUrls.acceptRequest, data: {
        "accept": 0,
        "req_id": resData[index]["req_id"],
      });
      var responseData = response.data;
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server Down. Please try again.')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          setState(() {
            getNOtifications();
          });
        }
      }
    } catch (e) {
      print("Deny Request Exception $e");
    }
  }

  findLocation(latitude, longitude) {
    getLocation(latitude, longitude);
  }
}
