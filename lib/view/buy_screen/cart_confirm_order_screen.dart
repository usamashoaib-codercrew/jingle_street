import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jingle_street/config/functions/navigator_functions.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartConfirmOrderScreen extends StatefulWidget {
  @override
  State<CartConfirmOrderScreen> createState() => _CartConfirmOrderScreenState();
}

class _CartConfirmOrderScreenState extends State<CartConfirmOrderScreen> {
  TextEditingController _orderController = TextEditingController();
  List getSaveData = [];
  int addCount = 1;
  int minusCount = 1;
  num totalPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.appColor,
        appBar: SimpleAppBar(
            text: "Cart",
            onTap: () {
              pop(context);
            }),
        body: Center(
          child: Container(
            height: size.height * 0.82,
            width: size.width * 0.92,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.whiteColor),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "${getSaveData.length} items in cart",
                      bold: FontWeight.bold,
                      size: 20,
                      color: AppTheme.appColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: getSaveData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 90,
                                        width: size.width * 0.21,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5,
                                              color: AppTheme.appColor),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: Image(
                                            image: NetworkImage(
                                                "${getSaveData[index]["image"]}"),
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.scaleDown)),
                                    SizeBoxWidth16(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          "${getSaveData[index]["category"]}",
                                          size: 18,
                                          color: AppTheme.appColor,
                                          bold: FontWeight.w700,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AppText(
                                          "${getSaveData[index]["price"]}",
                                          size: 14,
                                          color: AppTheme.yellowColor,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: AppTheme.appColor),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                    color: AppTheme.appColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            AppText(
                                              "${addCount}",
                                              color: AppTheme.appColor,
                                            ),
                                            SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: AppTheme.appColor),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 15,
                                                    color: AppTheme.appColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      totalPrice = totalPrice -
                                          getSaveData[index]["price"];
                                      print("ii$index");
                                      clearData(index);
                                      getSaveData.removeAt(index);

                                      print("ii${getSaveData}");
                                      setState(() {});
                                    },
                                    icon: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                              width: 2,
                                              color: AppTheme.appColor,
                                            )),
                                        child: Icon(
                                          Icons.close,
                                          color: AppTheme.appColor,
                                          size: 15,
                                        ))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AppText(
                      "Order Instruction",
                      color: AppTheme.appColor,
                      size: 20,
                      bold: FontWeight.w700,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 250,
                      child: AppField(
                        textEditingController: _orderController,
                        borderRadius: BorderRadius.circular(10),
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RowText(
                        text: "Total",
                        color: AppTheme.appColor,
                        fontsize: 20.0,
                        fontweight: FontWeight.bold,
                        text1: "${totalPrice}",
                        color1: AppTheme.appColor,
                        fontsize1: 20.0),
                    SizedBox(
                      height: 5,
                    ),
                    RowText(
                        text: "Delivary Charges",
                        color: AppTheme.appColor,
                        fontsize: 17.0,
                        text1: "\$5",
                        color1: AppTheme.appColor,
                        fontsize1: 20.0),
                    SizedBox(
                      height: 5,
                    ),
                    RowText(
                        text: "Sales Tax",
                        color: AppTheme.appColor,
                        fontsize: 17.0,
                        text1: "\$4",
                        color1: AppTheme.appColor,
                        fontsize1: 20.0),
                    SizedBox(
                      height: 5,
                    ),
                    RowText(
                        text: "Grand Total",
                        color: AppTheme.appColor,
                        fontsize: 20.0,
                        fontweight: FontWeight.bold,
                        text1: "\$50",
                        color1: AppTheme.appColor,
                        fontsize1: 20.0),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: AppButton(
                      text: "Confirm order",
                      textSize: 17,
                      width: size.width * 0.35,
                      height: 45,
                      onPressed: () {},
                      btnColor: AppTheme.appColor,
                      textColor: AppTheme.whiteColor,
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///////////////////////// clear data //////////////////////

  clearData(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final jsonString = preferences.getString("setData");
    List<Map<String, dynamic>> savedData = jsonString != null
        ? List<Map<String, dynamic>>.from(jsonDecode(jsonString))
        : [];

    // Remove the category at the specified index
    if (index >= 0 && index < savedData.length) {
      savedData.removeAt(index);
    }
    final updatedJsonString = jsonEncode(savedData);
    await preferences.setString("setData", updatedJsonString);

    // print("Data saved: $updatedJsonString");
  }

///////////////////////////////////   getting data ///////////////////////////
  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final data = preferences.getString("setData");

    if (data != null) {
      final decodedData = jsonDecode(data);
      getSaveData = decodedData;
      // print("null ${getSaveData}");

      setState(() {});
    } else {}
  }

  getTotal() {
    //  print("145${getSaveData}");

    for (var i = 0; i < getSaveData.length; i++) {
      print("145${getSaveData[i]["price"]}");

      num price = getSaveData[i]["price"];
      print("198$price");
      totalPrice += price;
      ;
    }
    print("124$totalPrice");
    setState(() {});
  }

  loadData() async {
    await getData();
    getTotal();
  }

  /////////////////////// add counter ///////////////////
}
