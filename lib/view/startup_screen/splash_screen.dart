import 'package:flutter/material.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/resources/res/app_assets.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/view/auth_screen/login_screen.dart';
import 'package:jingle_street/view/auth_screen/otp_screen.dart';
import 'package:jingle_street/view/home_screen/home_nav_screen.dart';
import 'package:jingle_street/view/startup_screen/get_started_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:sizer/sizer.dart';

// import '../../app_properties.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late int type;
  String token = '';
  String? name;

  int? verified;
  String? phone;

  @override
  void initState() {
    getUserData();
    super.initState();
    _navigatorFunction();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(height: 50.h,width: 100.w,),
              Container(
                  height: 38.h,
                  width: 50.w,
                  decoration: BoxDecoration(image: DecorationImage(
                    fit: BoxFit.fill,filterQuality: FilterQuality.high,
                    image: AssetImage(AppAssetsImages.splashCurve),
                  ))
              ),
              Positioned(
                  top: 3.7.h,
                  left: 25.w,
                  child: Container(
                      height: 7.5.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        border: Border.all(
                            color: Color(0xffFFFF00), width: 2),
                      ),
                      child: Center(
                        child: Image(
                            height: size.height * 0.04,
                            width: size.width * 0.07,
                            image:
                            AssetImage(AppAssetsImages.splashIceCreamVector)),
                      ))),
              Positioned(
                  top: 13.h,
                  left: 44.w,
                  child: Container(
                      height: 7.5.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xffFFFF00), width: 2)),
                      child: Center(
                          child: Image(
                              height: size.height * 0.04,
                              width: size.width * 0.07,
                              image: AssetImage(
                                  AppAssetsImages.splashTaco))))),
              Positioned(
                  top: 24.h,
                  left: 21.w,
                  child: Container(
                      height: 7.5.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xffFFFF00), width: 3)),
                      child: Center(
                        child: Image(
                            height: size.height * 0.04,
                            width: size.width * 0.07,
                            image: AssetImage(AppAssetsImages.splashCorn)),
                      ))),
              Positioned(
                  top: 34.h,
                  left: -8,
                  child: Container(
                      height: 7.5.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xffFFFF00), width: 2)),
                      child: Center(
                        child: Image(
                            height: size.height * 0.04,
                            width: size.width * 0.07,
                            image: AssetImage(AppAssetsImages.splashHotDog)),
                      ))),

            ],
          ),
          Center(
            child: Image(
                width: size.width * 0.85,
                image: AssetImage(AppAssetsImages.appLogo)),
          ),
        ],
      ),
    );
  }

  getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      name = prefs.getString(PrefKey.name);

      token = prefs.getString(PrefKey.authorization) ?? "";
      phone = prefs.getString(PrefKey.phone) ?? "";

      verified = prefs.getInt(PrefKey.verified) ?? 0;
      type = prefs.getInt(PrefKey.type) ?? 0;
    });
  }

  void _navigatorFunction() async {
    await Future.delayed(Duration(seconds: 3), () {});
    if (token.isNotEmpty && verified == 1) {
      replace(HomeNavScreen(
        type: type,
        name: name,
      ));
    } else if (token.isNotEmpty && verified == 0 && phone != null) {
      replace(OtpScreen(phoneNumber: "${phone}"));
    } else if (verified == 0 && phone != null && phone!.isNotEmpty) {
      replace(LoginScreen());
    } else {
      replace(GetStartedScreen());
    }
  }
}
