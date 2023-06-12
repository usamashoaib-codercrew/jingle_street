import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:req_fun/req_fun.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VendorReviewScreen extends StatefulWidget {
  final String profileImage;
  final String address;
  final String businessName;
  final int vType;
  final double lat;
  final double lon;
  final location;
  const VendorReviewScreen(
      {super.key,
      required this.profileImage,
      required this.address,
      required this.vType,
      required this.lat,
      required this.lon,
         required this.businessName,
        this.location
      });

  @override
  State<VendorReviewScreen> createState() => _VendorReviewScreenState();
}

class _VendorReviewScreenState extends State<VendorReviewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.whiteColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                pop(context);
              },
              child: CircleAvatar(
                radius: 17,
                backgroundColor: AppTheme.appColor,
                child: Center(
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          title: AppText(
            "Reviews & Info",
            color: AppTheme.appColor,
            size: 24,
            bold: FontWeight.bold,
          )),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              height: 200,
              width: size.width,
              child: Image(
                image: NetworkImage(widget.profileImage),
                fit: BoxFit.cover,
              )),
          SizeBoxHeight20(),
          Container(
            width: size.width * 0.90,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 13,
                left: 13,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Address",
                    size: 16,
                    color: AppTheme.appColor,
                    bold: FontWeight.bold,
                  ),
                  SizeBoxHeight5(),
                  AppText(widget.address,
                      size: 14,
                      ellipsis: true,
                      bold: FontWeight.w700,
                      color: AppTheme.appColor),
                  SizedBox(height: 7),
                  AppText(
                    "Location",
                    size: 16,
                    color: AppTheme.appColor,
                    bold: FontWeight.bold,
                  ),
                  SizeBoxHeight5(),
                  widget.vType == 1
                      ? InkWell(
                          onTap: () => GetDirectionToVendor(
                              lat: widget.lat,
                              long: widget.lon,
                              businessname: widget.businessName),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 5,
                            ),
                            height: size.height * 0.1,
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: AssetImage("assets/images/map.png"),
                                    fit: BoxFit.fill)),
                          ),
                        )
                      : InkWell(
                          onTap: () => GetDirectionToVendor(
                              lat: widget.lat,
                              long: widget.lon,
                              businessname: widget.businessName),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 5,
                            ),
                            height: size.height * 0.1,
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: NetworkImage(widget.location),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppTheme.ratingYellowColor,
                      ),
                      SizeBoxWidth8(),
                      AppText(
                        "3.8",
                        color: AppTheme.appColor,
                        bold: FontWeight.w700,
                        size: 20,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: AppText(
                      "100+ people rated",
                      size: 14,
                      color: AppTheme.appColor,
                      bold: FontWeight.w400,
                    ),
                  ),
                  SizeBoxHeight12(),
                ],
              ),
            ),
          ),
          SizeBoxHeight12(),
          Container(

              // height: size.height * 0.35,
              width: size.width * 0.90,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.only(
                    // top: 13,
                    // left: 20,
                    // right: 0
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              "All ratings (100+)",
                              size: 20,
                              color: AppTheme.appColor,
                              bold: FontWeight.w700,
                            ),
                            Spacer(),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppTheme.ratingYellowColor,
                            ),
                            SizeBoxWidth4(),
                            AppText(
                              "3.8",
                              color: AppTheme.appColor,
                              size: 20,
                              bold: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      SizeBoxHeight5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            "5",
                            size: 20,
                            color: AppTheme.appColor,
                            bold: FontWeight.w700,
                          ),
                          SizeBoxWidth8(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.ratingYellowColor,
                          ),
                          SizeBoxWidth4(),
                          LinearPercentIndicator(
                            barRadius: Radius.circular(20),
                            width: 230.0,
                            lineHeight: 5.0,
                            percent: 0.40,
                            backgroundColor: Colors.grey,
                            progressColor: AppTheme.appColor,
                          ),
                          AppText(
                            "49%",
                            size: 16,
                            bold: FontWeight.w700,
                            color: AppTheme.appColor,
                          )
                        ],
                      ),
                      SizeBoxHeight5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            "4",
                            size: 20,
                            color: AppTheme.appColor,
                            bold: FontWeight.w700,
                          ),
                          SizeBoxWidth8(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.ratingYellowColor,
                          ),
                          SizeBoxWidth4(),
                          LinearPercentIndicator(
                            barRadius: Radius.circular(20),
                            width: 230.0,
                            lineHeight: 5.0,
                            percent: 0.30,
                            backgroundColor: Colors.grey,
                            progressColor: AppTheme.appColor,
                          ),
                          AppText(
                            "30%",
                            bold: FontWeight.w700,
                            size: 16,
                            color: AppTheme.appColor,
                          )
                        ],
                      ),
                      SizeBoxHeight5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            "3",
                            size: 20,
                            color: AppTheme.appColor,
                            bold: FontWeight.w700,
                          ),
                          SizeBoxWidth8(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.ratingYellowColor,
                          ),
                          SizeBoxWidth4(),
                          LinearPercentIndicator(
                            barRadius: Radius.circular(20),
                            width: 230.0,
                            lineHeight: 5.0,
                            percent: 0.20,
                            backgroundColor: Colors.grey,
                            progressColor: AppTheme.appColor,
                          ),
                          AppText(
                            "20%",
                            size: 16,
                            bold: FontWeight.w700,
                            color: AppTheme.appColor,
                          )
                        ],
                      ),
                      SizeBoxHeight5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            "2",
                            size: 20,
                            color: AppTheme.appColor,
                            bold: FontWeight.w700,
                          ),
                          SizeBoxWidth8(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.ratingYellowColor,
                          ),
                          SizeBoxWidth4(),
                          LinearPercentIndicator(
                            barRadius: Radius.circular(20),
                            width: 230.0,
                            lineHeight: 5.0,
                            percent: 0.10,
                            backgroundColor: Colors.grey,
                            progressColor: AppTheme.appColor,
                          ),
                          AppText(
                            "10%",
                            size: 16,
                            bold: FontWeight.w700,
                            color: AppTheme.appColor,
                          )
                        ],
                      ),
                      SizeBoxHeight5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            "1",
                            size: 20,
                            color: AppTheme.appColor,
                            bold: FontWeight.w700,
                          ),
                          SizeBoxWidth8(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.ratingYellowColor,
                          ),
                          SizeBoxWidth4(),
                          LinearPercentIndicator(
                            barRadius: Radius.circular(20),
                            width: 230.0,
                            lineHeight: 5.0,
                            percent: 0.20,
                            backgroundColor: Colors.grey,
                            progressColor: AppTheme.appColor,
                          ),
                          AppText(
                            "15%",
                            size: 16,
                            bold: FontWeight.w700,
                            color: AppTheme.appColor,
                          )
                        ],
                      ),
                      SizeBoxHeight5()
                    ],
                  ),
                ),
              )),
          SizeBoxHeight10(),
          Padding(
            padding: const EdgeInsets.only(right: 18.0, left: 18.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.only(top: 13, left: 13, right: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText(
                            "Reviews ",
                            size: 20,
                            bold: FontWeight.w700,
                            color: AppTheme.appColor,
                          ),
                        ],
                      ),
                    ),
                    SizeBoxHeight10(),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.appColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    "Monika",
                                    size: 16,
                                    bold: FontWeight.w700,
                                    color: AppTheme.appColor,
                                  ),
                                  SizeBoxHeight5(),
                                  AppText(
                                    "1 day ago",
                                    size: 10,
                                    bold: FontWeight.w300,
                                    color: AppTheme.appColor,
                                  ),
                                  SizeBoxHeight10(),
                                  AppText(
                                    "Excellent...!",
                                    size: 14,
                                    bold: FontWeight.w400,
                                    color: AppTheme.appColor,
                                  ),
                                  SizeBoxHeight10(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppTheme.appColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: AppText(
                                          "Helpful",
                                          size: 14,
                                          bold: FontWeight.w500,
                                          color: AppTheme.appColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizeBoxHeight10()
                                ],
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              ),
            ),
          ),
          SizeBoxHeight12(),
        ]),
      ),
    );
  }

  GetDirectionToVendor(
      {required double lat,
      required double long,
      required String businessname}) async {
    try {
      if (Platform.isIOS) {
        final url = 'https://maps.google.com/?q=$lat,$long';
        if (await launchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch Google Maps.';
        }
      } else {
        MapsLauncher.launchCoordinates(
          lat,
          long,
          '${businessname}',
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Install Google Map to use Direction"),
            children: [Text("${e}")],
          );
        },
      );
    }
  }
}
