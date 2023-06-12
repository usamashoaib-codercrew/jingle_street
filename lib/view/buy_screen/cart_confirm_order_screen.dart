import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';

class CartConfirmOrderScreen extends StatefulWidget {
  @override
  State<CartConfirmOrderScreen> createState() => _CartConfirmOrderScreenState();
}

class _CartConfirmOrderScreenState extends State<CartConfirmOrderScreen> {
  // const CartScreen({super.key});

  bool cancle = true;
  List pics = [
    "assets/images/burger1.png",
    "assets/images/sandwich.png",
    "assets/images/icecream.png",
  ];

  List text = ["Beef Burger", "Club Sandwitch", "Ice-Cream"];

  List text1 = [
    "\$20",
    "\$15",
    "\$6",
  ];
  List count = List.generate(3, (index) => 0);

  void cancleCase() {
    setState(() {
      cancle = !cancle;
    });
  }

  // int _counter = 0;
  // int _counter1= 0;
  // int _counter2 = 0;

//   void incrementCounter(){
//     setState(() {
//       _counter++;
//       _counter1++;
//       _counter2++;
//     });
//   }
// void decrementCounter(){
//   setState(() {
//     _counter--;
//     _counter1--;
//     _counter2--;
//   });
// }
  TextEditingController _orderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.appColor,
        appBar: SimpleAppBar(text: "Cart", onTap: () {}),
        body: Center(
          child: Container(
            height: size.height * 0.82,
            width: size.width * 0.92,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.whiteColor),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22, top: 10),
                    child: AppText(
                      "3 items in cart",
                      bold: FontWeight.bold,
                      size: 20,
                      color: AppTheme.appColor,
                    ),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: text.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: ListTile(
                          leading: Container(
                              height: size.height,
                              width: size.width * 0.21,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.appColor,
                              ),
                              child: Image(
                                image: AssetImage(pics[index]),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.fill,
                              )),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text[index],
                                size: 16,
                                color: AppTheme.appColor,
                              ),
                              // SizedBox(height: 5,),
                              AppText(
                                text1[index],
                                size: 12,
                                color: AppTheme.yellowColor,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              // AppText(text1[index],size: 12,color: YellowColor,),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        count[index]--;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        AppText(
                                          "-",
                                          color: AppTheme.appColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        AppText(
                                          "${count[index]}",
                                          color: AppTheme.appColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  // AppText("$_counter",color: PrimaryColor,),
                                  // SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        count[index]++;
                                      });
                                    },
                                    child: AppText(
                                      "+",
                                      color: AppTheme.appColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                cancleCase();
                              },
                              icon: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppTheme.appColor,
                                      )),
                                  child: cancle
                                      ? Icon(
                                          Icons.close,
                                          color: AppTheme.appColor,
                                          size: 15,
                                        )
                                      : null)),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: AppText(
                      "order instruction",
                      color: AppTheme.appColor,
                    ),
                  ),
                  AppField(textEditingController: _orderController),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      height: size.height * 0.12,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.appColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RowText(
                      text: "Total",
                      color: AppTheme.appColor,
                      fontsize: 20.0,
                      fontweight: FontWeight.bold,
                      text1: "\$40",
                      color1: AppTheme.appColor,
                      fontsize1: 20.0),
                  RowText(
                      text: "Delivary Charges",
                      color: AppTheme.appColor,
                      fontsize: 17.0,
                      text1: "\$5",
                      color1: AppTheme.appColor,
                      fontsize1: 20.0),
                  RowText(
                      text: "Sales Tax",
                      color: AppTheme.appColor,
                      fontsize: 17.0,
                      text1: "\$4",
                      color1: AppTheme.appColor,
                      fontsize1: 20.0),
                  RowText(
                      text: "Grand Total",
                      color: AppTheme.appColor,
                      fontsize: 20.0,
                      fontweight: FontWeight.bold,
                      text1: "\$50",
                      color1: AppTheme.appColor,
                      fontsize1: 20.0),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Center(
                        child: AppButton(
                      text: "Confirm order",
                      textSize: 17,
                      width: size.width * 0.35,
                      height: 45,
                      onPressed: () {},
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
