import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:jingle_street/config/functions/provider.dart';
import 'package:jingle_street/providers/cart_counter.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'view/startup_screen/splash_screen.dart';

void main() async {
  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   mapsImplementation.useAndroidViewSurface = true;
  // }
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
      // ChangeNotifierProvider<GetVendorProductsProvider>(create: (_) => GetVendorProductsProvider()),
    ],
    child: MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
