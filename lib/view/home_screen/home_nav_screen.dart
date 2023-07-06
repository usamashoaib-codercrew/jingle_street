import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/resources/widgets/fields/bottom_navigation_bar_field.dart';
import 'package:jingle_street/view/buy_screen/cart_confirm_order_screen.dart';
import 'package:jingle_street/view/home_screen/google_map_screen.dart';
import 'package:jingle_street/view/home_screen/notification_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/setting_screen.dart';
import 'package:jingle_street/view/menu_screen/menu_screen.dart';
import 'package:jingle_street/view/menu_screen/vendor_review_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNavScreen extends StatefulWidget {
  final int? type;
  final String? token;
  final String? name;
  final String? id;
  const HomeNavScreen({Key? key, this.type, this.token, this.name, this.id})
      : super(key: key);

  @override
  State<HomeNavScreen> createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  late AppDio dio;
  List<dynamic> vendorData = [];
  Map<String, dynamic>? desiredVendor;

  //this global Instance is for getcount of Notify from sharedPrefs inside the getProfileAPI which is called in GoogleMApScreen
  int _notifyCount = 0;
  int _currentState = 0;

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
    var iosInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(context, message);
    });
  }

  void initLocalNotificationsForIOs() async {
    var iosInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSetting =
        InitializationSettings(iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting);
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
        // initLocalNotificationsForIOs(context, message);
        // showNotificationForIos(message);
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }

      setState(() {
        print("checking");
        _notifyCount++;
        print("checking" + _notifyCount.toString());
      });
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

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            // badgeNumber: _notifyCount,
            presentAlert: true,
            presentBadge: true,
            presentSound: true);

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

  Future<void> showNotificationForIos(RemoteMessage message) async {
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails =
        NotificationDetails(iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
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
      for (var vendor in vendorData) {
        if (vendor["id"] == message.data["vendor_id"]) {
          desiredVendor = vendor;
          print("desired$desiredVendor");
          _notifyCount = _notifyCount - 1;
          setState(() {});
          handleAction2(message);
        }
      }
    } else if (message.data['actions'] == 'Review') {
      Map<String, dynamic> data = json.decode(message.data['Review']);
      print("100$data");
      for (var vendor in vendorData) {
        if (vendor["id"] == data["vendor_id"]) {
          desiredVendor = vendor;
          print("desired$desiredVendor");
          _notifyCount = _notifyCount - 1;
          print("12121$_notifyCount");
          setState(() {});
          handleAction(message);
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

  notfiyCountFunction() {
    Prefs.getPrefs().then((value) {
      int value1 = value.getInt(PrefKey.notifyCount)!;
      _notifyCount = value1;
    });
  }

  @override
  void initState() {
    dio = AppDio(context);
    notfiyCountFunction();
    requestNotificationPermission();
    forgroundMessage();
    firebaseInit(context);
    initLocalNotificationsForIOs();
    setupInteractMessage(context);
    getVendorProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarField(
      currentState: _currentState,
      onTap: (index) {
        setState(() {
          _currentState = index;
          print("123451$_notifyCount");
          _currentState == 1 ? _notifyCount = 0 : _notifyCount;
        });
        //  navigateToScreen(index);
      },
      notifyCount: _notifyCount,
      bodyList: [
        GoogleMapScreen(type: widget.type, token: widget.token),
        Stack(
          children: [
            NotificationScreen(
              type: widget.type,
              token: widget.token,
              vId: widget.id,
            ),
          ],
        ),
        SettingScreen(
          type: widget.type,
          name: widget.name,
        ),
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
  seenNotifications(id) async {
    print("091$id");
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
          print("1456");
        }
      }
    } catch (e, s) {
      print("_____$e");
      print("_____$s");
    }
  }

  Future<void> handleAction(message) async {
    print("1272${message.data["noti_id"]}");
    await seenNotifications(message.data["noti_id"]);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => VendorReviewScreen(
          businessName: desiredVendor!["businessname"],
          profileImage: desiredVendor!["profilepic"],
          address: desiredVendor!["address"],
          vType: desiredVendor!["type"],
          uType: widget.type == 1
              ? (widget.id == desiredVendor!["user_id"] ? 1 : 0)
              : 0,
          lat: desiredVendor!["latitude"],
          lon: desiredVendor!["longitude"],
          vId: desiredVendor!["id"],
          location: desiredVendor!["location"],
        ),
      ),
    );
  }

  Future<void> handleAction2(message) async {
    await seenNotifications(message.data['noti_id']);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VandorScreen(
            businessName: desiredVendor!["businessname"],
            bio: desiredVendor!["bio"],
            businessHours: desiredVendor!["businesshours"],
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
}
