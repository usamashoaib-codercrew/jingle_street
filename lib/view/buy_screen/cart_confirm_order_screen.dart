import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jingle_street/providers/total_counter_provider.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartConfirmOrderScreen extends StatefulWidget {
  final int? price;
  const CartConfirmOrderScreen({
    super.key,
     this.price,
  });
  @override
  State<CartConfirmOrderScreen> createState() => _CartConfirmOrderScreenState();
}

class _CartConfirmOrderScreenState extends State<CartConfirmOrderScreen> {
  List<Map<String, dynamic>> itemsListGet = [];
  TextEditingController _orderController = TextEditingController();

  @override
  void initState() {
    _loadItemsData();
    super.initState();
  }

  Future<void> _loadItemsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('myItemsList');
    if (jsonString != null) {
      List<dynamic> decodedList = jsonDecode(jsonString);
      itemsListGet = decodedList.cast<Map<String, dynamic>>();
    }
    setState(() {});
  }

  void removeItemFromSharedPreferences(int listIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> decodedList = [];
    String? jsonString = prefs.getString('myItemsList');
    if (jsonString != null) {
      decodedList = jsonDecode(jsonString);
      if (listIndex >= 0 && listIndex < decodedList.length) {
        decodedList.removeAt(listIndex);
        jsonString = jsonEncode(decodedList);
        await prefs.setString('myItemsList', jsonString);
        setState(() {});
      }
    }
  }

  //testing code for increment
  Future<void> addToCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(itemsListGet);
    await prefs.setString('myItemsList', jsonString);
  }
  //end

  @override
  Widget build(BuildContext context) {
    final totalCounterProvider =
        Provider.of<TotalCounterProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.appColor,
        appBar: AppBar(
          leadingWidth: 50,
    title: AppText(
      "Cart",
      bold: FontWeight.bold,
      color: AppTheme.appColor,
      size: 24,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
        ),
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
                      "${itemsListGet.length} items in cart",
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
                      itemCount: itemsListGet.length,
                      itemBuilder: (context, index) {
                        int totalCount = 0;
                        for (int i = 0; i < itemsListGet.length; i++) {
                          int price = itemsListGet[i]['itemPrice'];
                          totalCount += price;
                        }

                        print("Total count: $totalCount");
                        totalCounterProvider.updateTotalCount(totalCount);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
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
                                                "${itemsListGet[index]["itemPicture"]}"),
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
                                          "${itemsListGet[index]["itemName"]}",
                                          size: 18,
                                          color: AppTheme.appColor,
                                          bold: FontWeight.w700,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AppText(
                                          "${itemsListGet[index]["itemPrice"]}",
                                          size: 14,
                                          color: AppTheme.yellowColor,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (itemsListGet[index]
                                                        ['counterValue'] ==
                                                    1) {
                                                  return;
                                                }
                                                setState(() {
                                                  itemsListGet[index]
                                                      ['counterValue']--;
                                                  int price =
                                                      itemsListGet[index]
                                                          ['itemPrice'];
                                                  int updatedPrice =
                                                      price - widget.price!;
                                                  itemsListGet[index]
                                                          ['itemPrice'] =
                                                      updatedPrice;
                                                  print(
                                                      "calculating_price minus ${itemsListGet[index]['itemPrice']}");
                                                  addToCartItems();
                                                  // _loadItemsData();
                                                });
                                              },
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
                                              "${itemsListGet[index]["counterValue"]}",
                                              color: AppTheme.appColor,
                                            ),
                                            SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  itemsListGet[index]
                                                      ['counterValue']++;
                                                  int price =
                                                      itemsListGet[index]
                                                          ['itemPrice'];
                                                  int updatedPrice =
                                                      price + widget.price!;
                                                  itemsListGet[index]
                                                          ['itemPrice'] =
                                                      updatedPrice;
                                                  print(
                                                      "calculating_price ${itemsListGet[index]['itemPrice']}");

                                                  addToCartItems();
                                                  // _loadItemsData();
                                                });
                                              },
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
                                Container(
                                  // color: Colors.black,
                                  height: 75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            itemsListGet.removeAt(index);
                                            removeItemFromSharedPreferences(
                                                index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          size: 25,
                                          color: AppTheme.appColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                    Consumer<TotalCounterProvider>(
                        builder: (context, totalCounterProvider, _) {
                      return RowText(
                          text: "Total",
                          color: AppTheme.appColor,
                          fontsize: 20.0,
                          fontweight: FontWeight.bold,
                          text1: itemsListGet.length == 0
                              ? '0'
                              : "\$${totalCounterProvider.totalCount.toStringAsFixed(1)}",
                          color1: AppTheme.appColor,
                          fontsize1: 20.0);
                    }),
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<TotalCounterProvider>(
                        builder: (context, totalCounterProvider, _) {
                      return RowText(
                          text: "Sales Tax",
                          color: AppTheme.appColor,
                          fontsize: 20.0,
                          fontweight: FontWeight.bold,
                          text1: itemsListGet.length == 0
                              ? '0'
                              : "\$${((totalCounterProvider.totalCount * 0.16)).toStringAsFixed(1)} ",
                          color1: AppTheme.appColor,
                          fontsize1: 20.0);
                    }),
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<TotalCounterProvider>(
                        builder: (context, totalCounterProvider, _) {
                      return RowText(
                          text: "Grand Total",
                          color: AppTheme.appColor,
                          fontsize: 20.0,
                          fontweight: FontWeight.bold,
                          text1: itemsListGet.length == 0
                              ? '0'
                              : "\$${((totalCounterProvider.totalCount) + ((totalCounterProvider.totalCount) * 0.16)).toStringAsFixed(1)}",
                          color1: AppTheme.appColor,
                          fontsize1: 20.0);
                    }),
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
}
