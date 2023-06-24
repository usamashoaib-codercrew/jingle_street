import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/functions/provider.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/model/notifications.dart';
import 'package:jingle_street/providers/cart_counter.dart';
import 'package:jingle_street/providers/total_counter_provider.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'view/startup_screen/splash_screen.dart';
import 'package:http/http.dart' as http;

//notifications
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}
AndroidNotificationChannel? channel;
late FirebaseMessaging messaging;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppTheme.appColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      mapRenderer = await mapsImplementation
          .initializeWithRenderer(AndroidMapRenderer.latest);
    } on PlatformException catch (e) {
      print('Error initializing renderer: ${e.message}');
      // Handle the error here
    }
  }

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    //notifications code
    messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fcmToken = await messaging.getToken();
    print("FCM token is ${fcmToken}");
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("fcm_token", fcmToken!);

    messaging.onTokenRefresh.listen((event) {
      print("klsdlkfjl$event");
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
      _prefs.setString("fcm_token", event);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'flutter_notification', // id
          'flutter_notification_title', // title
          importance: Importance.high,
          enableLights: true,
          enableVibration: true,
          showBadge: true,
          playSound: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iOS = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: android, iOS: iOS);

      await flutterLocalNotificationsPlugin!.initialize(initSettings,
          onDidReceiveNotificationResponse: notificationTapBackground,
          onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

      await messaging
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    //end notifications code
  } on FirebaseException catch (e) {
    print('Error initializing Firebase: ${e.message}');
    // Handle the error here
  }
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider<BoolProvider>(create: (_) => BoolProvider()),
      ChangeNotifierProvider<CartCounter>(create: (_) => CartCounter()),
      ChangeNotifierProvider<TotalCounterProvider>(create: (_) => TotalCounterProvider()),
      // ChangeNotifierProvider<GetVendorProductsProvider>(create: (_) => GetVendorProductsProvider()),
    ],
    child: MyApp(),
  ),
);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  PushNotification? _notificationInfo;

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _notificationInfo = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        _showNotificationPopUp(message.notification!);
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        _notificationInfo = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      });
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        setState(() {
          _notificationInfo = PushNotification(
            title: initialMessage.notification?.title,
            body: initialMessage.notification?.body,
          );
        });
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _configureLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _localNotifications.initialize(initializationSettings);
  }

  Future<void> _showNotificationPopUp(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotifications.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    final notificationData = message.notification?.body?.split(',');
    if (notificationData != null && notificationData.length >= 2) {
      setState(() {
        _showNotificationPopUp(message.notification!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _configureLocalNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context,orientation,deviceType) {
        return MaterialApp(
            title: 'Jingle Street',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: SplashScreen());
      }
    );
  }
}
