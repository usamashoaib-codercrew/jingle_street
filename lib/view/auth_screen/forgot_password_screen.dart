import 'dart:async';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/auth_screen/otp_screen.dart';
import 'package:jingle_street/view/auth_screen/reset_password_by_email_screen.dart';
import 'package:req_fun/req_fun.dart';

class SetPasswordByPhoneNumber extends StatefulWidget {
  SetPasswordByPhoneNumber({super.key});

  @override
  State<SetPasswordByPhoneNumber> createState() =>
      _SetPasswordByPhoneNumberState();
}

class _SetPasswordByPhoneNumberState extends State<SetPasswordByPhoneNumber> {
  final _resetCountryNameController = TextEditingController();

  final _resetCountryInitialController = TextEditingController();
  String? phone;

  int counter = 0;
  bool enableResend = false;
  StreamController<int>? _events;
  String _initialCountry = 'US';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ReusableAppBar(
        BackButton: true,
        ontap: () => pop(),
      ),
      backgroundColor: AppTheme.appColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                "Forget Password",
                bold: FontWeight.bold,
                size: 24,
              ),
              SizeBoxHeight6(),
              AppText(
                "Set password by phone number.",
                size: 18,
                color: Colors.white,
                bold: FontWeight.w300,
              ),
              SizeBoxHeight8(),
              Container(
                height: 450,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, right: 30, bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText("Country*", size: 15, color: AppTheme.appColor),
                      SizeBoxHeight4(),
                      Container(
                        height: 50,
                        width: size.width * 0.92,
                        margin: const EdgeInsets.only(top: 3, bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.2,
                            color: AppTheme.appColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CountryListPick(
                              onChanged: (CountryCode? countryCode) {
                                _resetCountryNameController.text =
                                    countryCode?.name ?? '';
                                _resetCountryInitialController.text =
                                    countryCode?.code ?? '';
                                setState(() {
                                  _initialCountry = _resetCountryInitialController.text =
                                      countryCode?.code ?? '';
                                });
                              },
                              theme: CountryTheme(
                                isShowFlag: true,
                                showEnglishName: true,
                                isShowCode: false,
                                isShowTitle: true,
                                isDownIcon: false,
                              ),
                              initialSelection: _initialCountry,
                              useUiOverlay: false,
                              useSafeArea: false,
                            ),
                          ],
                        ),
                      ),
                      AppText(
                        "Phone Number*",
                        size: 15,
                        color: Color(0xffF70000),
                      ),
                      SizeBoxHeight4(),
                      InternationalPhoneNumberInput(
                        initialValue: PhoneNumber(isoCode: _initialCountry),

                        keyboardType: TextInputType.number,
                        onInputChanged: (PhoneNumber number) {
                          phone= number.phoneNumber;
                          setState(() {

                          });
                       
                          // e.g. +1234567890
                        },
                        inputDecoration: const InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffF70000)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffF70000)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffF70000)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffF70000)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          hintText: '(425) 123-4567',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(247, 0, 0, 0.5),
                            fontFamily: "Roboto Condensed",
                          ),
                        ),
                        selectorTextStyle: const TextStyle(
                          color: Color.fromRGBO(247, 0, 0, 0.5),
                        ),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          // backgroundColor: Colors.white,
                          showFlags: false,
                          setSelectorButtonAsPrefixIcon: true,
                          trailingSpace: false,
                          useEmoji: false,
                        ),
                        textStyle: const TextStyle(
                            color: Colors.black,
                            letterSpacing: 0.4,
                            fontSize: 14),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                      ),
                      SizeBoxHeight10(),
                      AppText(
                        "Choose another method?",
                        size: 12,
                        bold: FontWeight.w400,
                        color: AppTheme.appColor,
                        onTap: () => push(SetPasswordByEmail()),
                      ),
                      SizeBoxHeight64(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            onPressed: (){

                              push(OtpScreen( phoneNumber: "${phone}"));
                            },
                            text: "Send OTP",
                            width: 150,
                            btnColor: AppTheme.appColor,
                            textColor: Colors.white,
                            height: 48,
                            textSize: 18,
                            fontweight: FontWeight.w400,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
