import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:req_fun/req_fun.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VendorReviewScreen extends StatefulWidget {
  final String profileImage;
  final String address;
  final String businessName;
  final int vType;
  final int uType;
  final double lat;
  final double lon;
  final location;
  final vId;
  const VendorReviewScreen(
      {super.key,
        required this.profileImage,
        required this.address,
        required this.vType,
        required this.uType,
        required this.lat,
        required this.lon,
        required this.businessName,
        this.location,
        this.vId});

  @override
  State<VendorReviewScreen> createState() => _VendorReviewScreenState();
}

class _VendorReviewScreenState extends State<VendorReviewScreen> {
  TextEditingController _commentsController = TextEditingController();

  int _rating = 0;
  bool loading = false;
  late AppDio dio;
  var reviewData;
  int visibleItemCount = 5;
  double normalizedRating = 0.0;

  // bool replyVisibility = false;
  Widget _buildStar(int index, StateSetter stateSetter) {
    IconData iconData = index <= _rating ? Icons.star : Icons.star;
    Color color = index <= _rating ? Colors.yellow : Colors.white;
    return GestureDetector(
      onTap: () {
        stateSetter(() {
          _rating = index;
        });
      },
      child: Icon(
        iconData,
        color: color,
      ),
    );
  }

  List<TextEditingController>? _replyFromVendor;
  List<bool>? replyVisibility;

  @override
  void initState() {
    dio = AppDio(context);
    getVenderReviews();

    super.initState();
  }

  void showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.appColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration:
                Duration(seconds: 1), // Customize the animation duration
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.whiteColor,
                ),
                child: Icon(
                  Icons.check,
                  color: AppTheme.appColor,
                  size: 40,
                ),
              ),
              SizedBox(height: 16),
              AppText(
                "Thanks for the review!",
                color: AppTheme.whiteColor,
                size: 18,
                bold: FontWeight.bold,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: AppText(
                "OK",
                color: AppTheme.whiteColor,
                size: 16,
                bold: FontWeight.bold,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  normalizedRating != 0
                      ? Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.yellow,
                      ),
                      SizeBoxWidth4(),
                      AppText(
                        "$normalizedRating".substring(0, 3),
                        color: AppTheme.appColor,
                        bold: FontWeight.w700,
                        size: 20,
                      )
                    ],
                  )
                      : SizedBox(),
                  reviewData != null
                      ? Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: AppText(
                      _getRatingCountText(reviewData.length),
                      size: 14,
                      color: AppTheme.appColor,
                      bold: FontWeight.w400,
                    ),
                  )
                      : SizedBox(),
                  SizeBoxHeight12(),
                ],
              ),
            ),
          ),
          SizeBoxHeight10(),
          reviewData == null
              ? Center(
            child: CircularProgressIndicator(color: AppTheme.whiteColor),
          )
              : Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 18.0, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding:
                const EdgeInsets.only(top: 13, left: 13, right: 13),
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
                        itemCount: reviewData.length < 5
                            ? reviewData.length
                            : visibleItemCount,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          int reversedIndex =
                              reviewData.length - 1 - index;
                          Map<String, dynamic> review =
                          reviewData[reversedIndex];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                replyVisibility![reversedIndex] = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppTheme.appColor),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          "${review["name"]}"
                                              .toCapitalize(),
                                          size: 16,
                                          bold: FontWeight.w700,
                                          color: AppTheme.appColor,
                                        ),
                                        buildTimeAgoTextWidget(
                                            reviewData[reversedIndex]
                                            ["updatedAt"]),
                                      ],
                                    ),
                                    SizeBoxHeight5(),
                                    Row(
                                      children: [
                                        for (int i = 0;
                                        i < review["rating"];
                                        i++)
                                          Icon(Icons.star,
                                              color: Colors.yellow),
                                        for (int i = review["rating"];
                                        i < 5;
                                        i++)
                                          Icon(Icons.star,
                                              color: Colors.grey),
                                      ],
                                    ),
                                    SizeBoxHeight10(),
                                    widget.uType == 1
                                        ? review["comment"] == null
                                        ? Row(
                                      children: [
                                        Container(
                                          width: 45.w,
                                          child: AppText(
                                            "${review["review"]}",
                                            size: 14,
                                            bold:
                                            FontWeight.w400,
                                            color: AppTheme
                                                .appColor,
                                          ),
                                        ),
                                        Spacer(),
                                        Visibility(
                                          visible:
                                          !replyVisibility![
                                          reversedIndex],
                                          child:
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                replyVisibility![
                                                reversedIndex] =
                                                !replyVisibility![
                                                reversedIndex];
                                              });
                                            },
                                            child: Container(
                                              width: 24.w,
                                              height: 5.h,
                                              alignment:
                                              Alignment
                                                  .center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppTheme
                                                          .appColor),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      20)),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    right:
                                                    5),
                                                child: AppText(
                                                  "Reply",
                                                  size: 14,
                                                  bold:
                                                  FontWeight
                                                      .w800,
                                                  color: AppTheme
                                                      .appColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                        : Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        AppText(
                                          "${review["review"]}"
                                              .toCapitalize(),
                                          size: 14,
                                          bold: FontWeight.w400,
                                          color:
                                          AppTheme.appColor,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              left: 20.0,
                                              top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              AppText(
                                                "${widget.businessName.toCapitalize()}",
                                                size: 16,
                                                bold: FontWeight
                                                    .bold,
                                                color: AppTheme
                                                    .appColor,
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              AppText(
                                                "${review["comment"]}"
                                                    .toCapitalize(),
                                                size: 14,
                                                bold: FontWeight
                                                    .w400,
                                                color: AppTheme
                                                    .appColor,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                        : Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          "${review["review"]}"
                                              .toCapitalize(),
                                          size: 14,
                                          bold: FontWeight.w400,
                                          color: AppTheme.appColor,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        review["comment"] == null
                                            ? SizedBox()
                                            : Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              left: 20.0,
                                              top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              AppText(
                                                "${widget.businessName.toCapitalize()}",
                                                size: 16,
                                                bold:
                                                FontWeight
                                                    .bold,
                                                color: AppTheme
                                                    .appColor,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              AppText(
                                                "${review["comment"]}"
                                                    .toCapitalize(),
                                                size: 14,
                                                bold:
                                                FontWeight
                                                    .w400,
                                                color: AppTheme
                                                    .appColor,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizeBoxHeight16(),
                                    Visibility(
                                      visible: replyVisibility![reversedIndex],
                                      child: Container(
                                        height: 13.h,
                                        child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 110,
                                                width: 55.w,
                                                color: Colors.white,
                                                child: AppField(
                                                  hintText: "Reply",
                                                  maxLines: 2,
                                                  hintTextColor:
                                                  Colors.redAccent,
                                                  fontSize: 10.sp,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                                  borderSideColor:
                                                  AppTheme.appColor,
                                                  textEditingController:
                                                  _replyFromVendor![
                                                  reversedIndex],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 3.h),
                                                child: Container(
                                                    height: 6.h,
                                                    width: 12.w,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: AppTheme
                                                          .appColor,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          100),
                                                    ),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          if (_replyFromVendor![
                                                          reversedIndex]
                                                              .text
                                                              .isNotEmpty) {
                                                            commentsReply(
                                                                reversedIndex);
                                                            FocusScope.of(
                                                                context)
                                                                .unfocus();
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                                context)
                                                                .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'The phone number is missing.'),
                                                                ));
                                                            FocusScope.of(
                                                                context)
                                                                .unfocus();
                                                          }

                                                          setState(() {
                                                            replyVisibility![
                                                            reversedIndex] =
                                                            !replyVisibility![
                                                            reversedIndex];
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.send,
                                                          color: AppTheme
                                                              .whiteColor,
                                                        ))),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                    if (reviewData.length > visibleItemCount)
                      GestureDetector(
                          onTap: () {
                            int remainigItems =
                                reviewData.length - visibleItemCount;
                            if (remainigItems >= 5) {
                              setState(() {
                                visibleItemCount += remainigItems;
                              });
                            }
                            // else {
                            //   setState(() {
                            //     visibleItemCount += remainigItems;
                            //   });
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'See More',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppTheme
                                        .appColor, // Customize the button color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ))
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: widget.uType == 0
          ? Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: FloatingActionButton(
          backgroundColor: AppTheme.appColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: AppTheme.appColor,
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          // height: 500,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                                NetworkImage(widget.profileImage),
                              ),
                              SizeBoxHeight16(),
                              AppText(
                                widget.businessName,
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
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: List.generate(
                                    5,
                                        (index) =>
                                        _buildStar(index + 1, setState)),
                              ),
                              SizeBoxHeight16(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AppField(
                                  hintText: 'Additional Comments...',
                                  textEditingController:
                                  _commentsController,
                                  borderRadius: BorderRadius.circular(10),
                                  maxLines: 3,
                                  borderSideColor: AppTheme.whiteColor,
                                ),
                              ),
                              SizeBoxHeight16(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _commentsController.clear();
                                      _rating = 0;
                                      setState;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        border: Border.all(
                                          width: 1,
                                          color: AppTheme.whiteColor,
                                        ),
                                      ),
                                      width: size.width * 0.28,
                                      height: 40,
                                      child: Center(
                                        child: AppText(
                                          "Not Now",
                                          size: 15,
                                          bold: FontWeight.w700,
                                          color: AppTheme.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_rating == 0) {
                                        FocusScope.of(context).unfocus();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please add ratings first!'),
                                          ),
                                        );
                                      } else if (_commentsController
                                          .text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Please add Some Comments!'),
                                        ));
                                      } else {
                                        sendReview();
                                        FocusScope.of(context).unfocus();

                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.whiteColor,
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      width: size.width * 0.28,
                                      height: 40,
                                      child: Center(
                                        child: AppText(
                                          "Submit Review",
                                          size: 15,
                                          bold: FontWeight.w700,
                                          color: AppTheme.appColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }).then((value) {
              _commentsController.clear();
              _rating = 0;
              setState;
            });
          },
          child: Icon(Icons.edit_outlined),
        ),
      )
          : null,
    );
  }

//////////////////////////////////////
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

  ///////////////////////////////////  vendor reviews api ///////////////////////////////////

  sendReview() async {


    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;

    try {
      final response = await dio.post(
        path: AppUrls.addReview,
        data: {
          'vendor_id': widget.vId,
          'rating': _rating,
          'review': _commentsController.getText()
        },
      );


      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        showReviewDialog(context);
        getVenderReviews();
        setState(() {
          // Perform any necessary state updates
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  /////////////////////////////////// get vendor reviews ///////////////////////////////
  ///

  Future<void> getVenderReviews() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await dio.get(
          path: AppUrls.getVenderreviews,
          queryParameters: {"vendor_id": widget.vId});

      if (response.statusCode == StatusCode.OK) {
        var data = response.data;
        var totalRating = data["data"];
        setState(() {
          reviewData = data["data"];
          loading = false;
        });
        int sumOfRatings = 0;

        for (var totalR in totalRating) {
          int totalRR = totalR["rating"];
          sumOfRatings += totalRR;
        }
        double averageRating = sumOfRatings / reviewData.length;

        normalizedRating = (averageRating / 5) * 5;

      } else {
        loading = false;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ));
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
    stateChangeFuntion();
  }
  ///////////////////////////////////////////////

  Widget buildTimeAgoTextWidget(int timestamp) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return AppText(
        '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago',
        size: 12,
        color: AppTheme.appColor,
      );
    } else if (difference.inHours > 0) {
      return AppText(
        '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago',
        size: 12,
        color: AppTheme.appColor,
      );
    } else if (difference.inMinutes > 0) {
      return AppText(
        '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago',
        size: 12,
        color: AppTheme.appColor,
      );
    } else {
      return AppText(
        'just now',
        size: 12,
        color: AppTheme.appColor,
      );
    }
  }

  stateChangeFuntion() {
    _replyFromVendor =
        List.generate(reviewData.length, (index) => TextEditingController());
    replyVisibility = List.generate(reviewData.length, (index) => false);
  }

  ////////////////////////////
  ///
  Future<void> commentsReply(index) async {
    setState(() {
      loading = true;
    });

    try {
      final response = await dio.post(path: AppUrls.replyComments, data: {
        "review_id": reviewData[index]["id"],
        "comment": _replyFromVendor![index].getText()
      });

      if (response.statusCode == StatusCode.OK) {
        var data = response.data;

        getVenderReviews();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ));
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  ///////////////////////////////
  String _getRatingCountText(int count) {
    if (count >= 1000) {
      int thousands = (count ~/ 1000);
      return "${thousands}k+ people rated";
    } else if (count >= 100) {
      int hundreds = (count ~/ 100);
      return "${hundreds}00+ people rated";
    } else {
      return "${count} people rated";
    }
  }
}
