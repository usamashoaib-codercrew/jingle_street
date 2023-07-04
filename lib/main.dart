import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:jingle_street/TestNotifications/notification_services.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/functions/provider.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/model/notifications.dart';
import 'package:jingle_street/providers/cart_counter.dart';
import 'package:jingle_street/providers/total_counter_provider.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/view/menu_screen/vendor_review_screen.dart';
import 'package:jingle_street/view/notifications_testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'view/startup_screen/splash_screen.dart';

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
  // NotificationServices notificationServices = NotificationServices();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
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
  @override
  void initState() {
    // TODO: implement initState
    getDeviceToken();
    isTokenRefresh();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context,orientation,deviceType) {
        return MaterialApp(
          // navigatorKey: navigatorKey,
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
