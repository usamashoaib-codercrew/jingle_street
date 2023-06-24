import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/providers/cart_counter.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/view/buy_screen/cart_confirm_order_screen.dart';
import 'package:jingle_street/view/menu_screen/video_player_screen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCardScreen extends StatefulWidget {
  final catagoryName;
  final catagoryDiscrption;
  final catagoryPrice;
  final catagoryImages;
  final length;
  final itemId;

  const AddToCardScreen(
      {super.key,
        this.catagoryName,
        this.catagoryPrice,
        this.catagoryDiscrption,
        this.catagoryImages,
        this.length,
        this.itemId});

  @override
  State<AddToCardScreen> createState() => _AddToCardScreenState();
}

class _AddToCardScreenState extends State<AddToCardScreen> {
  final _pageIndexNotifier = ValueNotifier<int>(0);

  // final List<dynamic> extraListAdd = [];
  // final List<String> addExtraItems = [
  //   'Extra Cheese',
  //   'Extra Sauce',
  //   'Extra Ketchup',
  //   'Extra Salad',
  // ];
  // bool _isFilled = false;
  // bool _isFilled1 = false;
  // bool _isFilled2 = false;
  // bool _isFilled3 = false;

  bool _alreadyAddedItems = false;

  List<Map<String, dynamic>> itemsList = [];
  // List<Map<String, dynamic>> itemsMergedList = [];

  int counterValue = 1;

  Future<void> addToCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(itemsList);
    await prefs.setString('myItemsList', jsonString);
  }

  void _addItemToList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('myItemsList');
    itemsList = jsonString != null
        ? List<Map<String, dynamic>>.from(jsonDecode(jsonString))
        : [];
    // Add a new map item to the list
    Map<String, dynamic> newItem = {
      'itemPicture': widget.catagoryImages[0]['url'],
      'itemName': widget.catagoryName,
      'itemPrice': widget.catagoryPrice,
      'itemId': widget.itemId,
      'counterValue': counterValue,
    };

    int itemIndex = itemsList
        .indexWhere((element) => element['itemId'] == newItem['itemId']);
    if (itemIndex != -1) {
      setState(() {
        itemsList[itemIndex]['counterValue']++; // Increment the count by 1
        int price = itemsList[itemIndex]['itemPrice'];
        num updatedPrice = price + widget.catagoryPrice;
        itemsList[itemIndex]['itemPrice'] = updatedPrice;
      });
    } else {
      itemsList.add(newItem);
    }
    String updateJsonString = jsonEncode(itemsList);
    await prefs.setString('myItemsList', updateJsonString);

    // List<Map<String, dynamic>> itemsMergedListNew = List<Map<String, dynamic>>.from(itemsMergedList);
    // itemsMergedListNew.add(newItem);

    // itemsList.addAll(itemsMergedListNew);

    // addToCartItems();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("lckbckba ${widget.getData}");
    print("${widget.itemId}bbannnsdfkslldfbsdkbfxkkfbkdxbskbjdfb");
    print("setting_items_pic ${widget.catagoryImages[0]['url']}");
    print("setting_items_name ${widget.catagoryName}");
    print("setting_items_price ${widget.catagoryPrice}");
    var size = MediaQuery.of(context).size;
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
                Navigator.of(context).pop();
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
          title: Align(
            alignment: Alignment.center,
            child: AppText(
              "${widget.catagoryName}",
              color: AppTheme.appColor,
              size: 22,
              bold: FontWeight.bold,
            ),
          )),
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
              // color: WhiteColor,
              decoration: BoxDecoration(color: AppTheme.whiteColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 25),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppTheme.appColor),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.star,
                                        size: 16,
                                        color: AppTheme.yellowColor,
                                      )),
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
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 25),
                        child: AppText(
                          "\$${widget.catagoryPrice}",
                          color: AppTheme.yellowColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: AppText(
                      "${widget.catagoryName}".toCapitalize(),
                      size: 25,
                      bold: FontWeight.bold,
                      color: AppTheme.appColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // SizedBox(height: 7,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: AppText(
                      "${widget.catagoryDiscrption}",
                      size: 16,
                      color: AppTheme.appColor,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
