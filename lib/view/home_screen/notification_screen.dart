
import 'package:dialogs/dialogs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:jingle_street/view/menu_screen/menu_screen.dart';
import 'package:jingle_street/view/menu_screen/vendor_review_screen.dart';
import 'package:provider/provider.dart';
import 'package:req_fun/req_fun.dart';

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

  List<dynamic> vendorData = [];
  Map<String, dynamic>? desiredVendor;

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      setState(() {
        getNOtifications();
      });
    });
  }

  @override
  void initState() {
    dio = AppDio(context);
    getNOtifications();
    firebaseInit(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("object${widget.vId}");
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

                if (resData[index]["action"] == "Review") {
                  final updatedAtInMillis = resData[index]['updatedAt'];
                  print("updated_time2 ${updatedAtInMillis}");
                      return customerRequest(index);
                } else if(resData[index]["action"] == "Home"){
                  return getDirectionsWidget(index);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          seenNotifications(resData[index]["id"]);
                          Prefs.getPrefs().then((value) {
                            int value1 = value.getInt(PrefKey.notifyCount)!;
                            if (value1 < 0) {
                              value1--;
                            }
                            Prefs.setInt(PrefKey.notifyCount, value1);
                          });
                          print("object:11");
                          String id = resData[index]["vendor_id"];
                          print("19$id");
                          for (var vendor in vendorData) {
                            if (vendor["id"] == id) {
                              desiredVendor = vendor;
                              print("55${desiredVendor}");
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
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "${resData[index]["image"]}"),
                                      radius: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            timestamp: resData[index]
                                                ["updatedAt"]),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
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
                                )
                              ],
                            ),
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
        print("123$resData");
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
    print("111111");
    var response;

    try {
      response = await dio.get(
        path: AppUrls.getVendor,
      );
      var responseData = response.data;
      print("145{$responseData['data]['vendors]}".length);
      if (response.statusCode == StatusCode.BAD_REQUEST) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Server Down')));
      } else if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          vendorData = responseData['data']['vendors'];
          print("11${vendorData.length}");
          setState(() {});
        }
      }
    } catch (e, s) {
      print("_____$e");
      print("_____$s");
    }
  }
  ///////////////////////////////////////////////////////////

  seenNotifications(id) async {
    print("090$id");
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
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monika Hanson',
                      // '${data['review']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Consumer<TimerProvider>(
                      builder: (context, timerProvider, child) {
                        final updatedAtInMillis = resData[index]['updatedAt'];
                        timerProvider.startTimer(resData[index]["id"], updatedAtInMillis);
                        final timerText = timerProvider.getTimeString(resData[index]["id"]);
                        return Center(
                          child: AppText(
                            timerText,
                            size: 15,
                            bold: FontWeight.bold,
                            color: AppTheme.whiteColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Distance: 1.2 KM',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: 110,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                        //     child: Text(
                        //   "Accept",
                        //   style: TextStyle(color: AppTheme.appColor),
                        // ),
                          child: AppText(
                            "Accept",
                            color: AppTheme.appColor,
                            size: 16,
                            bold: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            // widget.addNotificationsList.removeAt(index);
                          });
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

  Widget getDirectionsWidget(int index){
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
                          backgroundImage: NetworkImage(
                              "${resData[index]["image"]}"),
                          radius: 22,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  "You accepted Monika’s request",
                                  ellipsis: true,
                                  size: 20,
                                  bold: FontWeight.w400,
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
                margin: EdgeInsets.only(top: 40,right: 15),
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
}
