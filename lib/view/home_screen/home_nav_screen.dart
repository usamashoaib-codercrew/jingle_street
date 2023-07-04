import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/resources/widgets/fields/bottom_navigation_bar_field.dart';
import 'package:jingle_street/view/buy_screen/cart_confirm_order_screen.dart';
import 'package:jingle_street/view/home_screen/google_map_screen.dart';
import 'package:jingle_street/view/home_screen/notification_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/setting_screen.dart';
import 'package:jingle_street/view/menu_screen/vendor_review_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNavScreen extends StatefulWidget {
  final int? type;
  final String? token;
  final String? name;
  final String? id;
  const HomeNavScreen({Key? key, this.type, this.token, this.name, this.id}) : super(key: key);

  @override
  State<HomeNavScreen> createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {

  late AppDio dio;
  List<dynamic> vendorData = [];
  Map<String, dynamic>? desiredVendor;

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          // handle interaction when app is active for android
          handleMessage(context, message);
        });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        channel.id.toString(), channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
        sound: channel.sound
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("ajksdlajs${token}");
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("fcm_token", token!);
    return token;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("evernt_is ${event}");
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['actions'] == 'Home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
            builder: (_) =>
                HomeNavScreen(type: widget.type, token: widget.token)
        ),
      );
    } else if(message.data['actions'] == 'Review') {
      Map<String, dynamic> data = json.decode(message.data['Review']);
      for (var vendor in vendorData) {
        if (vendor["id"] == data["vendor_id"]) {
          desiredVendor = vendor;
          if (message.data['actions'] == 'Review') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) =>
                    VendorReviewScreen(
                      businessName: desiredVendor!["businessname"],
                      profileImage: desiredVendor!["profilepic"],
                      address: desiredVendor!["address"],
                      vType: desiredVendor!["type"],
                      uType: widget.type == 1 ? 1 : 0,
                      lat: desiredVendor!["latitude"],
                      lon: desiredVendor!["longitude"],
                      vId: desiredVendor!["id"],
                      location: desiredVendor!["location"],
                    ),
              ),
            );
          } else {
            print("not navigated");
          }
        }
      }
    }
  }


  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  void initState() {
    dio = AppDio(context);
    requestNotificationPermission();
    forgroundMessage();
    firebaseInit(context);
    setupInteractMessage(context);
    getVendorProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarField(
      bodyList: [
        GoogleMapScreen(type: widget.type,token: widget.token),
        NotificationScreen(type: widget.type, token: widget.token, vId: widget.id,),
        SettingScreen(type: widget.type,name: widget.name, ),
      ],
      iconData: [
        Icons.home,
        Icons.notifications_none,
        Icons.settings,
      ],
    );
  }

  //getting all the vendors api
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
//ends

}

// var _androidAppRetain = MethodChannel("android_app_retain");

// @override
// Widget build(BuildContext context) {
//   return WillPopScope(
//     onWillPop: () {
//       if (Platform.isAndroid) {
//         if (Navigator.of(context).canPop()) {
//           return Future.value(true);
//         } else {
//           _androidAppRetain.invokeMethod("sendToBackground");
//           return Future.value(false);
//         }
//       } else {
//         return Future.value(true);
//       }
//     },
//     child: Scaffold(
//     ...
//     ),
//   );
// }
