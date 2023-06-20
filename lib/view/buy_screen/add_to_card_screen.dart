import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/view/buy_screen/cart_confirm_order_screen.dart';
import 'package:jingle_street/view/menu_screen/video_player_screen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCardScreen extends StatefulWidget {
  final catagoryName;
  final catagoryDiscrption;
  final catagoryPrice;
  final catagoryImages;
  final length;
  final id;

  const AddToCardScreen(
      {super.key,
      this.catagoryName,
      this.catagoryPrice,
      this.catagoryDiscrption,
      this.catagoryImages,
      this.length, 
      this.id});

  @override
  State<AddToCardScreen> createState() => _AddToCardScreenState();
}

class _AddToCardScreenState extends State<AddToCardScreen> {
  final _pageIndexNotifier = ValueNotifier<int>(0);
  // const BeefScreen({super.key});

  List saveMultiple = [];

  @override
  Widget build(BuildContext context) {
    print("lckbckba ${widget.id}");
    print("${widget.catagoryImages}bbannnsdfkslldfbsdkbfxkkfbkdxbskbjdfb");
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: SimpleAppBar(
          text: "${widget.catagoryName}".toCapitalize(),
          onTap: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.catagoryImages.length,
                    itemBuilder: (context, index) {
                      if (index < widget.catagoryImages.length) {
                        if (widget.catagoryImages[index]['type'] == 0) {
                          return Image.network(
                            widget.catagoryImages[index]['url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ErrorWidget(
                                'Failed to load image. Please reload the page.',
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.appColor,
                                ),
                              );
                            },
                          );
                        } else if (widget.catagoryImages[index]['type'] == 1) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                widget.catagoryImages[index]['thumbnail'],
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                errorBuilder: (context, error, stackTrace) {
                                  return ErrorWidget(
                                    'Failed to load video. Please reload the page.',
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.appColor,
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 80,
                                height: 80,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayScreen(
                                                    videoUrl:
                                                        widget.catagoryImages[
                                                            index]['url'])));
                                  },
                                  icon: Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 40,
                                    color: AppTheme.appColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      return Container();
                    },
                    onPageChanged: (index) {
                      _pageIndexNotifier.value = index;
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CirclePageIndicator(
                        itemCount: widget.catagoryImages.length,
                        currentPageNotifier: _pageIndexNotifier,
                        dotColor: Colors.grey.withOpacity(0.5),
                        selectedDotColor: AppTheme.appColor,
                        size: 8.0,
                        onPageSelected: (int index) {
                          _pageIndexNotifier.value = index;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              height: size.height * 0.65,
              width: size.width,
              decoration: BoxDecoration(color: AppTheme.whiteColor),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppTheme.appColor),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppTheme.yellowColor,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                AppText(
                                  "4.8",
                                  size: 17,
                                )
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        AppText(
                          "\$${widget.catagoryPrice}",
                          color: AppTheme.yellowColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AppText(
                      "${widget.catagoryName}".toCapitalize(),
                      size: 28,
                      bold: FontWeight.bold,
                      color: AppTheme.appColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // SizedBox(height: 7,),
                    AppText(
                      "${widget.catagoryDiscrption}",
                      size: 16,
                      color: AppTheme.appColor,
                    ),
                    SizedBox(
                      height: 155,
                    ),
                    Center(
                        child: AppButton(
                      btnColor: AppTheme.appColor,
                      text: "Add to Cart",
                      textSize: 14,
                      width: size.width * 0.3,
                      textColor: AppTheme.whiteColor,
                      onPressed: () {
                        print("ok");
                        saveData();

                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CartConfirmOrderScreen(),
                            ));
                      },
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
saveData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  // Retrieve existing data from shared preferences
  final jsonString = preferences.getString("setData");
  List<Map<String, dynamic>> savedData = jsonString != null
      ? List<Map<String, dynamic>>.from(jsonDecode(jsonString))
      : [];
  Map<String, dynamic> saveCategoryData = {
    "category": widget.catagoryName,
    "price": widget.catagoryPrice,
    "image": widget.catagoryImages[0]["url"],
  };
  savedData.add(saveCategoryData);

  // Save the updated list to shared preferences
  final updatedJsonString = jsonEncode(savedData);
  await preferences.setString("setData", updatedJsonString);

  print("Data saved: $updatedJsonString");
}
}
