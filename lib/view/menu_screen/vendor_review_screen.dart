import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
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
  final uType;
  const VendorReviewScreen(
      {super.key,
      required this.profileImage,
      required this.address,
      required this.vType,
      required this.lat,
      required this.lon,
      required this.businessName,
      this.location,
      this.uType});

  @override
  State<VendorReviewScreen> createState() => _VendorReviewScreenState();
}

TextEditingController _commentsController = TextEditingController();

class _VendorReviewScreenState extends State<VendorReviewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: widget.uType == 0
          ? Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: FloatingActionButton(
              
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: AppTheme.appColor,
                          content: Container(
                            width: double.infinity,
                            height: 420,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(
                                    "Tell us, how was our food?",
                                    size: 22,
                                    bold: FontWeight.w700,
                                    color: AppTheme.whiteColor,
                                  ),
                                  Divider(
                                      thickness: 2,
                                      endIndent: 10,
                                      indent: 10,
                                      color: AppTheme.whiteColor),
                                  SizeBoxHeight20(),
                                  CircleAvatar(
                                    backgroundColor: AppTheme.appColor,
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage('assets/images/Mcdonald.png'),
                                  ),
                                  SizeBoxHeight16(),
                                  AppText(
                                    "Ahsan khan",
                                    size: 24,
                                    bold: FontWeight.w700,
                                    color: AppTheme.whiteColor,
                                  ),
                                  SizeBoxHeight20(),
                                  AppText(
                                    "Rate the care provided Tuesday, Feb 28",
                                    size: 16,
                                    bold: FontWeight.w400,
                                    color: AppTheme.whiteColor,
                                  ),
                                  SizeBoxHeight5(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow),
                                      Icon(Icons.star, color: Colors.yellow),
                                      Icon(Icons.star, color: Colors.yellow),
                                      Icon(Icons.star, color: Colors.white),
                                      Icon(Icons.star, color: Colors.white),
                                    ],
                                  ),
                                  SizeBoxHeight16(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: AppField(
                                      hintText: 'Additional Comments...',
                                      textEditingController: _commentsController,
                                      borderSideColor: AppTheme.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      maxLines: 3,
                                    ),
                                  ),
                                  SizeBoxHeight16(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          border: Border.all(
                                            width: 1,
                                            color: AppTheme.whiteColor,
                                          ),
                                        ),
                                        width: 100,
                                        height: 48,
                                        child: Center(
                                          child: AppText(
                                            "Not Now",
                                            size: 14,
                                            bold: FontWeight.w700,
                                            color: AppTheme.whiteColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.whiteColor,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                        width: 100,
                                        height: 48,
                                        child: Center(
                                          child: AppText(
                                            "Submit Review",
                                            size: 14,
                                            bold: FontWeight.w700,
                                            color: AppTheme.appColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Icon(Icons.edit_sharp),
              ),
          )
          : null,
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
                                  left: 10, right: 10, top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        "Monika",
                                        size: 16,
                                        bold: FontWeight.w700,
                                        color: AppTheme.appColor,
                                      ),
                                      AppText(
                                        "1 day ago",
                                        size: 12,
                                        bold: FontWeight.w400,
                                        color: AppTheme.appColor,
                                      ),
                                    ],
                                  ),
                                  SizeBoxHeight5(),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ],
                                  ),
                                  SizeBoxHeight10(),
                                  SizeBoxHeight10(),
                                  Row(
                                    children: [
                                      AppText(
                                        "Excellent...!",
                                        size: 14,
                                        bold: FontWeight.bold,
                                        color: AppTheme.appColor,
                                      ),
                                      Spacer(),
                                      widget.uType == 1
                                          ? GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                width: 100,
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppTheme.appColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: AppText(
                                                    "Reply",
                                                    size: 14,
                                                    bold: FontWeight.w800,
                                                    color: AppTheme.appColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                  SizeBoxHeight10(),
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
