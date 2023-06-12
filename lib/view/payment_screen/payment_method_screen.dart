import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/button/check_box.dart';
import 'package:jingle_street/resources/widgets/button/profile_button.dart';
import 'package:jingle_street/resources/widgets/button/radio_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';

enum SingingCharacter { cashondelivery }

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  TextEditingController _nameOnCard = TextEditingController();
  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _expDate = TextEditingController();
  TextEditingController _cVV = TextEditingController();

  // SingingCharacter _character = SingingCharacter.cashondelivery;
  int? _groupValue;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final textScalingFactor = MediaQuery.of(context).textScaleFactor;
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: CustomAppBar(
          elevation: 0,
          title: Text("Payment Method",
              style: TextStyle(
                  color: AppTheme.appColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: ProfileButton(
              ContainerColor: AppTheme.appColor,
              border: false,
              // child: IconButton(
              //     onPressed: null,
              //     icon: Icon(
              //       Icons.chevron_left,
              //       color: Colors.white,
              //       size: textScalingFactor * 25,
              //     )),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizeBoxHeight32(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            "Cash On Delivery",
                            color: AppTheme.appColor,
                            size: 20,
                            bold: FontWeight.bold,
                          ),
                          AppRadioButton(
                            value: 1,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                              });
                            },
                          )
                        ]),
                    SizeBoxHeight32(),
                    Center(
                      child: AppText(
                        "Or",
                        color: AppTheme.appColor,
                        size: 12,
                      ),
                    ),
                    SizeBoxHeight32(),
                    Image(
                        image: AssetImage(
                            "assets/images/payment_method_logo.png")),
                    SizeBoxHeight32(),
                    Padding(
                      padding: EdgeInsets.only(right: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Name on Card *",
                            color: AppTheme.appColor,
                            size: 12,
                          ),
                          SizeBoxHeight4(),
                          AppField(
                            textStyleColor: AppTheme.appColor,
                            textEditingController: _nameOnCard,
                            fillColor: AppTheme.appColor,
                            borderSideColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          SizeBoxHeight16(),
                          AppText(
                            "Card Number *",
                            color: AppTheme.appColor,
                            size: 12,
                          ),
                          SizeBoxHeight4(),
                          AppField(
                            textStyleColor: AppTheme.appColor,
                            textEditingController: _cardNumber,
                            fillColor: AppTheme.appColor,
                            borderSideColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          SizeBoxHeight16(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizeBoxHeight4(),
                              AppText(
                                "Exp date *",
                                color: AppTheme.appColor,
                                size: 12,
                              ),
                              SizeBoxHeight4(),
                              SizedBox(
                                width: (130 / widthScreen) * widthScreen,
                                child: AppField(
                                  textStyleColor: AppTheme.appColor,
                                  textEditingController: _expDate,
                                  fillColor: AppTheme.appColor,
                                  borderSideColor: AppTheme.appColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizeBoxHeight4(),
                              AppText(
                                "CVV *",
                                color: AppTheme.appColor,
                                size: 12,
                              ),
                              SizeBoxHeight4(),
                              SizedBox(
                                width: (130 / widthScreen) * widthScreen,
                                child: AppField(
                                  textStyleColor: AppTheme.appColor,
                                  textEditingController: _cVV,
                                  fillColor: AppTheme.appColor,
                                  borderSideColor: AppTheme.appColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        AppCheckBox(
                          hoverColor: AppTheme.appColor,
                          activeColor: Colors.white,
                          borderSidewidth: 0.1,
                          borderSideColor: AppTheme.appColor,
                          focusColor: AppTheme.appColor,
                          checkColor: AppTheme.appColor,
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        AppText(
                          "Save this card",
                          size: 12,
                          color: AppTheme.appColor,
                        )
                      ],
                    ),
                    SizeBoxHeight64(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          "Total Price",
                          color: AppTheme.appColor,
                          size: 20,
                        ),
                        AppText(
                          "50",
                          color: AppTheme.appColor,
                          size: 20,
                        ),
                      ],
                    ),
                    SizeBoxHeight64(),
                    Center(
                      child: AppButton(
                          isBorder: false,
                          height: 50,
                          btnColor: AppTheme.appColor,
                          borderRadius: 15,
                          textColor: Colors.white,
                          text: "Checkout",
                          textSize: 18,
                          width: 150),
                    ),
                    SizeBoxHeight32()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
