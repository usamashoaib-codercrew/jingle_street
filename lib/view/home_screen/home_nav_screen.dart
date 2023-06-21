import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jingle_street/resources/widgets/fields/bottom_navigation_bar_field.dart';
import 'package:jingle_street/view/buy_screen/cart_confirm_order_screen.dart';
import 'package:jingle_street/view/home_screen/google_map_screen.dart';
import 'package:jingle_street/view/home_screen/notification_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/setting_screen.dart';

class HomeNavScreen extends StatefulWidget {
  final int? type;
  final String? token;
  final String? name;
  const HomeNavScreen({Key? key, this.type, this.token, this.name}) : super(key: key);

  @override
  State<HomeNavScreen> createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarField(
      bodyList: [
        GoogleMapScreen(type: widget.type,token: widget.token),
        NotificationScreen(),
        CartConfirmOrderScreen(),
        SettingScreen(type: widget.type,name: widget.name, ),
      ],
      iconData: [
        Icons.home,
        Icons.notifications_none,
        Icons.shopping_cart_outlined,
        Icons.settings,
      ],
    );
  }
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
