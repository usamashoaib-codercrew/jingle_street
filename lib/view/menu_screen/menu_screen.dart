import 'dart:io';

import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/functions/navigator_functions.dart';
import 'package:jingle_street/config/functions/provider.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/providers/cart_counter.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/menu_screen/burgers_builder_screen.dart';
import 'package:jingle_street/view/menu_screen/dessert_builder_screen.dart';
import 'package:jingle_street/view/menu_screen/drinks_builder.dart';
import 'package:jingle_street/view/menu_screen/fries_builder_screen.dart';
import 'package:jingle_street/view/menu_screen/other_builder.dart';
import 'package:jingle_street/view/menu_screen/pizza_builder_screen.dart';
import 'package:jingle_street/view/menu_screen/sandwich_builder_screen.dart';
import 'package:jingle_street/view/menu_screen/sauces_builder_screen.dart';
import 'package:jingle_street/view/menu_screen/vendor_review_screen.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

List isRated = List.generate(36, (index) => 1, growable: true);

final List<GlobalKey> _globalKeys = List.generate(15, (_) => GlobalKey());
List<bool> isSelectedList = List.generate(10, (index) => false);

List MenuText = [
  "Burger",
  "Pizza",
  "Sandwich",
  "Fries",
  "Sauces",
  "Dessert",
  "Soft Drinks",
  "Others"
];

List MenuImages = [
  "assets/images/burger.png",
  "assets/images/pizza.png",
  "assets/images/sandwich_vector.png",
  "assets/images/menufries.png",
  "assets/images/sauces.png",
  "assets/images/dessert.png",
  "assets/images/drink.png",
  "assets/images/other.png",
];

class VandorScreen extends StatefulWidget {
  final businessName;
  final bio;
  final businessHours;
  final photo;
  final address;
  final lat;
  final long;
  final vType;
  final id;
  final uType;
  final location;

  VandorScreen(
      {super.key,
      this.businessName,
      this.photo,
      this.address,
      this.lat,
      this.long,
      this.vType,
      this.id,
      this.uType,
      this.location,
      this.businessHours,
      this.bio});

  @override
  State<VandorScreen> createState() => _VandorScreenState();
}

class _VandorScreenState extends State<VandorScreen> {
  // bool isRated = true;
  bool isDone = true;
  AppLogger Logger = AppLogger();
  late AppDio dio;
  // var finalData;
  late Stream<List<dynamic>> _futureGetItems;

  @override
  void initState() {
    dio = AppDio(context);

    Logger.init();
    super.initState();
    _futureGetItems = getVendorItems();
  }

  List<bool> isSelectedList =
      List.generate(MenuText.length, (index) => index == 0);

  @override
  Widget build(BuildContext context) {
    print("vtype..${widget.vType}");
    bool myBoolean = Provider.of<BoolProvider>(context).myBoolean;
    final widthScreen = MediaQuery.of(context).size.width;

    final heightScreen = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    if (myBoolean) {
      _futureGetItems = getVendorItems();
      Provider.of<BoolProvider>(context, listen: false).myBoolean = false;
    }

    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: AppBar(
          actions: [
            Consumer<CartCounter>(
              builder: (context, cartCounter, _) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppTheme.appColor,
                      size: 30,
                    ),
                  ),
                  if (cartCounter.itemCount > 0)
                    Positioned(
                      right: 5,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartCounter.itemCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 20),
          ],
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
              "Welcome to ${widget.businessName}",
              color: AppTheme.appColor,
              size: 22,
              bold: FontWeight.bold,
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: size.width,
              child: Image.network(
                "${widget.photo}",
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
              ),
              // child: Image.network(
              //   "${widget.photo}",
              //   fit: BoxFit.cover,
              // ),
            ),
            SizeBoxHeight4(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.vType == null
                      ? SizedBox(
                          height: 20,
                        )
                      : widget.vType == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Stationary Vendor",
                                  color: Colors.white,
                                  size: 16,
                                  bold: FontWeight.bold,
                                ),
                                InkWell(
                                  onTap: () {
                                    push(VendorReviewScreen(
                                      profileImage: widget.photo,
                                      address: widget.address,
                                      vType: widget.vType,
                                      lat: widget.lat,
                                      lon: widget.long,
                                      businessName: widget.businessName,
                                      location: widget.location,
                                    ));
                                  },
                                  child: AppText(
                                    "Reviews & info",
                                    color: Colors.white,
                                    size: 16,
                                    bold: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Mobile Vendor",
                                  color: Colors.white,
                                  size: 16,
                                  bold: FontWeight.bold,
                                ),
                                InkWell(
                                  onTap: () {
                                    push(VendorReviewScreen(
                                      profileImage: widget.photo,
                                      address: widget.address,
                                      vType: widget.vType,
                                      lat: widget.lat,
                                      lon: widget.long,
                                      businessName: widget.businessName,
                                      location: widget.location,
                                    ));
                                  },
                                  child: AppText(
                                    "Reviews & info",
                                    color: Colors.white,
                                    size: 16,
                                    bold: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                  SizeBoxHeight5(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 13,
                        left: 13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Bio",
                            size: 18,
                            color: AppTheme.appColor,
                            bold: FontWeight.bold,
                          ),
                          AppText("${widget.bio}",
                              size: 15, color: AppTheme.appColor),
                          SizedBox(height: 7),
                          AppText(
                            "Address",
                            size: 18,
                            color: AppTheme.appColor,
                            bold: FontWeight.bold,
                          ),
                          // SizeBoxHeight5(),
                          AppText("${widget.address}",
                              size: 15, color: AppTheme.appColor),
                          SizedBox(height: 7),
                          AppText(
                            "business hours",
                            size: 18,
                            color: AppTheme.appColor,
                            bold: FontWeight.bold,
                          ),
                          AppText("${widget.businessHours}",
                              size: 15, color: AppTheme.appColor),
                          SizedBox(height: 7),
                          AppText(
                            "Location",
                            size: 16,
                            color: AppTheme.appColor,
                            bold: FontWeight.bold,
                          ),
                          SizeBoxHeight6(),
                          widget.vType == 1
                              ? InkWell(
                                  onTap: () => GetDirectionToVendor(
                                      lat: widget.lat,
                                      long: widget.long,
                                      businessname: widget.businessName),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    height: size.height * 0.1,
                                    width: size.width * 0.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/map.png"),
                                            fit: BoxFit.fill)),
                                  ),
                                )
                              : InkWell(
                                  onTap: () => GetDirectionToVendor(
                                      lat: widget.lat,
                                      long: widget.long,
                                      businessname: widget.businessName),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    height: size.height * 0.1,
                                    width: size.width * 0.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(widget.location),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                          SizedBox(height: 15),
                          AppText("Choose the",
                              size: 16, color: AppTheme.appColor),
                          AppText(
                            "Food you Love.!",
                            size: 18,
                            color: AppTheme.appColor,
                            bold: FontWeight.bold,
                          ),
                          SizeBoxHeight12(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: MenuText.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          for (int i = 0;
                                              i < isSelectedList.length;
                                              i++) {
                                            isSelectedList[i] = i == index;
                                          }
                                        });

                                        Scrollable.ensureVisible(
                                            _globalKeys[index].currentContext!,
                                            duration: Duration(seconds: 1));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: isSelectedList[index]
                                                  ? AppTheme.appColor
                                                  : AppTheme.appColorLight,
                                              width: isSelectedList[index]
                                                  ? 2
                                                  : 1.0),
                                        ),
                                        width: 110,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              height: 18,
                                              width: 44,
                                              image:
                                                  AssetImage(MenuImages[index]),
                                            ),
                                            SizeBoxHeight3(),
                                            AppText(
                                              MenuText[index],
                                              size: 12,
                                              color: isSelectedList[index]
                                                  ? AppTheme.appColor
                                                  : AppTheme.appColorLight,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizeBoxHeight10(),
                  AppText(
                    "Today's Offer",
                    size: 18,
                    color: Colors.white,
                    bold: FontWeight.w700,
                  ),
                  SizeBoxHeight5(),
                  Container(
                    height: 152,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xffFED3D3), AppTheme.appColor]),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0, right: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, top: 16),
                                child: AppText("Free Box Of Fries",
                                    size: 17,
                                    bold: FontWeight.bold,
                                    color: AppTheme.appColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 10),
                                child: RichText(
                                  text: TextSpan(
                                      text: "On all orders above  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.appColor),
                                      children: [
                                        TextSpan(
                                            text: "150\$",
                                            style: TextStyle(
                                                color: Color(0xffF4DD06))),
                                      ]),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: size.width * 0.4,
                            child: Image(
                              image: AssetImage("assets/images/fries.png"),
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizeBoxHeight10(),
                  // StreamBuilder(
                  //     stream: _futureGetItems,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.data == null) {
                  //         return Container(
                  //           height: 300,
                  //           child: Center(
                  //             child: CircularProgressIndicator(
                  //                 color: AppTheme.whiteColor),
                  //           ),
                  //         );
                  //       }
                  //       var data = snapshot.data![0];
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           if (data["burger"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[0],
                  //                   child: AppText(
                  //                     "Burgers",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 BurgerBuilder(
                  //                   itemData: data["burger"],
                  //                   uType: widget.uType,
                  //                   vType: widget.vType,
                  //                 )
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["pizza"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[1],
                  //                   child: AppText(
                  //                     "Pizza",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 PizzaBuilder(
                  //                     itemData: data["pizza"],
                  //                     uType: widget.uType,
                  //                     vType: widget.vType),
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["sandwich"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[2],
                  //                   child: AppText(
                  //                     "Sandwich",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 SandwichBuilder(
                  //                   itemData: data["sandwich"],
                  //                   uType: widget.uType,
                  //                   vType: widget.vType,
                  //                 ),
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["fries"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[3],
                  //                   child: AppText(
                  //                     "Fries",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 FriesBuilder(
                  //                     itemData: data["fries"],
                  //                     uType: widget.uType,
                  //                     vType: widget.vType)
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["sauce"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[4],
                  //                   child: AppText(
                  //                     "Sauces",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 SaucesBuilder(
                  //                     itemData: data["sauce"],
                  //                     uType: widget.uType,
                  //                     vType: widget.vType),
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["desert"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[5],
                  //                   child: AppText(
                  //                     "Dessert",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 DessertBuilder(
                  //                     itemData: data["desert"],
                  //                     uType: widget.uType,
                  //                     vType: widget.vType),
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["soft drinks"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   // height: 100,
                  //                   // color: Colors.black,
                  //                   key: _globalKeys[6],
                  //                   child: AppText(
                  //                     "Soft Drinks",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 DrinksBuilder(
                  //                     itemData: data["soft drinks"],
                  //                     uType: widget.uType,
                  //                     vType: widget.vType),
                  //               ],
                  //             ),
                  //           SizeBoxHeight8(),
                  //           if (data["others"] != null)
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   key: _globalKeys[7],
                  //                   child: AppText(
                  //                     "Others",
                  //                     size: 18,
                  //                     color: Colors.white,
                  //                     bold: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //                 SizeBoxHeight8(),
                  //                 OthersBuilder(
                  //                     itemData: data["product"],
                  //                     uType: widget.uType,
                  //                     vType: widget.vType),
                  //               ],
                  //             ),
                  //         ],
                  //       );
                  //     }),
                  StreamBuilder<List<dynamic>>(
                    stream: _futureGetItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.whiteColor,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          height: 300,
                          child: Center(
                            child: Text(
                              'Failed to load data. Please check your internet connection.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        var data = snapshot.data![0];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data["burger"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[0],
                                    child: AppText(
                                      "Burgers",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  BurgerBuilder(
                                    itemData: data["burger"],
                                    uType: widget.uType,
                                    vType: widget.vType,
                                  )
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["pizza"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[1],
                                    child: AppText(
                                      "Pizza",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  PizzaBuilder(
                                      itemData: data["pizza"],
                                      uType: widget.uType,
                                      vType: widget.vType),
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["sandwich"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[2],
                                    child: AppText(
                                      "Sandwich",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  SandwichBuilder(
                                    itemData: data["sandwich"],
                                    uType: widget.uType,
                                    vType: widget.vType,
                                  ),
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["fries"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[3],
                                    child: AppText(
                                      "Fries",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  FriesBuilder(
                                      itemData: data["fries"],
                                      uType: widget.uType,
                                      vType: widget.vType)
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["sauce"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[4],
                                    child: AppText(
                                      "Sauces",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  SaucesBuilder(
                                      itemData: data["sauce"],
                                      uType: widget.uType,
                                      vType: widget.vType),
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["desert"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[5],
                                    child: AppText(
                                      "Dessert",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  DessertBuilder(
                                      itemData: data["desert"],
                                      uType: widget.uType,
                                      vType: widget.vType),
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["soft drinks"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: 100,
                                    // color: Colors.black,
                                    key: _globalKeys[6],
                                    child: AppText(
                                      "Soft Drinks",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  DrinksBuilder(
                                      itemData: data["soft drinks"],
                                      uType: widget.uType,
                                      vType: widget.vType),
                                ],
                              ),
                            SizeBoxHeight8(),
                            if (data["product"] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: _globalKeys[7],
                                    child: AppText(
                                      "Others",
                                      size: 18,
                                      color: Colors.white,
                                      bold: FontWeight.w700,
                                    ),
                                  ),
                                  SizeBoxHeight8(),
                                  OthersBuilder(
                                      itemData: data["product"],
                                      uType: widget.uType,
                                      vType: widget.vType),
                                ],
                              ),
                          ],
                        );
                      } else {
                        return Container(
                          height: 300,
                          child: Center(
                            child: Text(
                              'No data available.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Stream<List<dynamic>> getVendorItems() async* {
    var response;
    List<dynamic> _profile = [];

    try {
      response = await dio.post(
        path: AppUrls.getVendorProducts,
        data: {'v_id': '${widget.id}'},
      );
      var responseData = response.data;
      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          var finalData = responseData['data']['products'];
          _profile.add(finalData);
        }
      }
    } catch (e, s) {
      print("_____$e");
      print("_____$s");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Failed to load data. Please check your internet connection.'),
      ));
    }
    yield _profile;
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
