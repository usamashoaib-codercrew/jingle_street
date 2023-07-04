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
  final int price;
  final extraList;
  const CartConfirmOrderScreen({
    super.key,
    required this.price,
    this.extraList,
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
        appBar: SimpleAppBar(
            text: "Cart",
            onTap: () {
              Navigator.pop(context);
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
                                                      price - widget.price;
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
                                                      price + widget.price;
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
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        itemsListGet.removeAt(index);
                                        removeItemFromSharedPreferences(index);
                                      });
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
                    Consumer<TotalCounterProvider>(
                        builder: (context, totalCounterProvider, _) {
                          return RowText(
                              text: "Total",
                              color: AppTheme.appColor,
                              fontsize: 20.0,
                              fontweight: FontWeight.bold,
                              text1: itemsListGet.length == 0
                                  ? '\$0'
                                  : "\$${totalCounterProvider.totalCount}",
                              color1: AppTheme.appColor,
                              fontsize1: 20.0);
                        }),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // RowText(
                    //     text: "Delivary Charges",
                    //     color: AppTheme.appColor,
                    //     fontsize: 17.0,
                    //     text1: "\$5",
                    //     color1: AppTheme.appColor,
                    //     fontsize1: 20.0),
                    SizedBox(
                      height: 5,
                    ),
                    RowText(
                        text: "Sales Tax",
                        color: AppTheme.appColor,
                        fontsize: 17.0,
                        // text1: "\$${totalCounterProvider.totalCount *100 /totalCounterProvider.totalCount}",
                        text1: itemsListGet.length == 0
                            ? '\$0'
                            : "\$${totalCounterProvider.totalCount * 0.16}",
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
                        text1: itemsListGet.length == 0
                            ? '\$0'
                            : "\$${totalCounterProvider.totalCount + (totalCounterProvider.totalCount * 0.16)}",
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
                        )),
                    SizedBox(height: 20),
                    Center(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.extraList.length,
                          itemBuilder: (context, index){
                            return Text('${index.toString()+" "+widget.extraList[index]}',textAlign: TextAlign.center,);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // body: Center(
        //   child: Container(
        //     height: size.height * 0.82,
        //     width: size.width * 0.92,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         color: AppTheme.whiteColor),
        //     child: SingleChildScrollView(
        //       scrollDirection: Axis.vertical,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.only(left: 22, top: 10),
        //             child: AppText(
        //               "${itemsListGet.length} items in cart",
        //               bold: FontWeight.bold,
        //               size: 20,
        //               color: AppTheme.appColor,
        //             ),
        //           ),
        //           ListView.builder(
        //             physics: NeverScrollableScrollPhysics(),
        //             shrinkWrap: true,
        //             itemCount: itemsListGet.length,
        //             itemBuilder: (context, index) {
        //               int totalCount = 0;
        //               for (int i = 0; i < itemsListGet.length; i++) {
        //                 int price = itemsListGet[i]['itemPrice'];
        //                 totalCount += price;
        //               }
        //
        //               print("Total count: $totalCount");
        //               totalCounterProvider.updateTotalCount(totalCount);
        //
        //               print("myTotal count: $totalCount");
        //
        //               print(
        //                   "counter_initial $index index ${itemsListGet[index]['itemPrice']}");
        //
        //               print(
        //                   "getting_items_pic ${itemsListGet[index]['itemPicture']}");
        //               print(
        //                   "getting_items_name ${itemsListGet[index]['itemName']}");
        //               print(
        //                   "getting_items_price ${itemsListGet[index]['itemPrice']}");
        //               return Container(
        //                 child: ListTile(
        //                   leading: Container(
        //                     height: size.height,
        //                     width: size.width * 0.21,
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(10),
        //                       color: AppTheme.appColor,
        //                     ),
        //                     child: Image(
        //                       // image: AssetImage(pics[index]),
        //                       image: NetworkImage(itemsListGet[index]
        //                               ['itemPicture']
        //                           .toString()),
        //                       filterQuality: FilterQuality.high,
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                   title: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       AppText(
        //                         // text[index],
        //                         itemsListGet[index]['itemName'],
        //                         size: 16,
        //                         color: AppTheme.appColor,
        //                       ),
        //                       // SizedBox(height: 5,),
        //                       AppText(
        //                         // text1[index],
        //                         "\$${itemsListGet[index]['itemPrice']}",
        //                         size: 12,
        //                         color: AppTheme.yellowColor,
        //                       ),
        //                       SizedBox(
        //                         height: 1,
        //                       ),
        //                       Row(
        //                         children: [
        //                           InkWell(
        //                             onTap: () {
        //                               if (itemsListGet[index]['counterValue'] ==
        //                                   1) {
        //                                 return;
        //                               }
        //                               setState(() {
        //                                 itemsListGet[index]['counterValue']--;
        //                                 int price =
        //                                     itemsListGet[index]['itemPrice'];
        //                                 int updatedPrice = price - widget.price;
        //                                 itemsListGet[index]['itemPrice'] =
        //                                     updatedPrice;
        //                                 print(
        //                                     "calculating_price minus ${itemsListGet[index]['itemPrice']}");
        //                                 addToCartItems();
        //                                 // _loadItemsData();
        //                               });
        //                             },
        //                             child: Row(
        //                               children: [
        //                                 AppText(
        //                                   "-",
        //                                   color: AppTheme.appColor,
        //                                 ),
        //                                 SizedBox(
        //                                   width: 10,
        //                                 ),
        //                                 AppText(
        //                                   "${itemsListGet[index]['counterValue']}",
        //                                   color: AppTheme.appColor,
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                           SizedBox(width: 10),
        //                           InkWell(
        //                             onTap: () {
        //                               setState(() {
        //                                 itemsListGet[index]['counterValue']++;
        //                                 int price =
        //                                     itemsListGet[index]['itemPrice'];
        //                                 int updatedPrice = price + widget.price;
        //                                 itemsListGet[index]['itemPrice'] =
        //                                     updatedPrice;
        //                                 print(
        //                                     "calculating_price ${itemsListGet[index]['itemPrice']}");
        //
        //                                 addToCartItems();
        //                                 // _loadItemsData();
        //                               });
        //                             },
        //                             child: AppText(
        //                               "+",
        //                               color: AppTheme.appColor,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                       SizedBox(width: 10),
        //                     ],
        //                   ),
        //                   trailing: IconButton(
        //                     onPressed: () {
        //                       setState(() {
        //                         itemsListGet.removeAt(index);
        //                         removeItemFromSharedPreferences(index);
        //                       });
        //                     },
        //                     icon: Container(
        //                       height: 25,
        //                       width: 25,
        //                       decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.circular(100),
        //                           border: Border.all(
        //                             color: AppTheme.appColor,
        //                           )),
        //                       child: Icon(
        //                         Icons.close,
        //                         color: AppTheme.appColor,
        //                         size: 15,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //           SizedBox(
        //             height: 5,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(left: 16),
        //             child: AppText(
        //               "order instruction",
        //               color: AppTheme.appColor,
        //             ),
        //           ),
        //           SizedBox(
        //             height: 5,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(left: 16),
        //             child: Container(
        //               height: size.height * 0.12,
        //               width: size.width * 0.7,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 border: Border.all(
        //                   color: AppTheme.appColor,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             height: 5,
        //           ),
        //           Consumer<TotalCounterProvider>(
        //               builder: (context, totalCounterProvider, _) {
        //             return RowText(
        //                 text: "Total",
        //                 color: AppTheme.appColor,
        //                 fontsize: 20.0,
        //                 fontweight: FontWeight.bold,
        //                 text1: itemsListGet.length == 0 ? '0' : "\$${totalCounterProvider.totalCount}",
        //                 color1: AppTheme.appColor,
        //                 fontsize1: 20.0);
        //           }),
        //           RowText(
        //               text: "Delivary Charges",
        //               color: AppTheme.appColor,
        //               fontsize: 17.0,
        //               text1: "\$5",
        //               color1: AppTheme.appColor,
        //               fontsize1: 20.0),
        //           RowText(
        //               text: "Sales Tax",
        //               color: AppTheme.appColor,
        //               fontsize: 17.0,
        //               text1: "\$4",
        //               color1: AppTheme.appColor,
        //               fontsize1: 20.0),
        //           RowText(
        //               text: "Grand Total",
        //               color: AppTheme.appColor,
        //               fontsize: 20.0,
        //               fontweight: FontWeight.bold,
        //               text1: "\$50",
        //               color1: AppTheme.appColor,
        //               fontsize1: 20.0),
        //           SizedBox(
        //             height: 12,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(bottom: 15),
        //             child: Center(
        //                 child: AppButton(
        //               text: "Confirm order",
        //               textSize: 17,
        //               width: size.width * 0.35,
        //               height: 45,
        //               onPressed: () {},
        //             )),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
