import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jingle_street/resources/res/app_assets.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/view/auth_screen/login_screen.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';


class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  Completer<GoogleMapController> _controller = Completer();

@override
  void initState() {
 _getLocationPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppTheme.appColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Image(
                      width: size.width * 0.5,
                      // height: size.height*0.5,
                      image: AssetImage(AppAssetsImages.appLogo)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: size.height * 0.75,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Image(
                            width: size.width * 0.4,
                            image:
                                AssetImage("assets/images/cart_umberella.png")),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      AppText("Support Local",color: AppTheme.appColor,bold: FontWeight.bold),
                      AppText("Vendors",color: AppTheme.appColor,bold: FontWeight.bold),

                      SizedBox(
                        height: 30,
                      ),
                      AppText("Did you lose your appetite?",color: AppTheme.appColor),
                      AppText("I think we found it.",color: AppTheme.appColor),
                      SizedBox(height: size.height * 0.15),
                      AppButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LoginScreen(),));
                        },
                        text: "Get Started",
                        width: 150,
                        btnColor: AppTheme.appColor,
                        textColor: Colors.white,
                        height: 45,
                        textSize: 20,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> _getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
try{
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }

}
catch(e){
  print("_____$e");
}
    return true;
  }
}
