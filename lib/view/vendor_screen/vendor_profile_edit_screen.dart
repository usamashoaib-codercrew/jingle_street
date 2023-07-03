import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jingle_street/resources/widgets/validator/validator.dart';

class VendorProfileEdit extends StatefulWidget {
  @override
  State<VendorProfileEdit> createState() => _VendorProfileEditState();
}

class _VendorProfileEditState extends State<VendorProfileEdit> {
  // const SignUp({Key? key}) : super(key: key);

  GlobalKey<FormState> globalKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _countryNameController = TextEditingController();
  TextEditingController _countryInitialController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF70000),
        appBar:SimpleAppBar(text: "Edit Profile",onTap: (){}),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                              Form(
                  key: globalKey,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Name*",
                            size: 16,
                            color: AppTheme.appColor,
                          ),
                          SizeBoxHeight3(),
                          AppField(
                            validator: (value) =>
                                ValidatorScreen.nameValidation(value!),
                            textEditingController: _nameController,
                            hintText: "Enter full name",

                            hintTextColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                            borderSideColor: AppTheme.appColor,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          AppText(
                            "Email*",
                            size: 16,
                            color: Color(0xffF70000),
                          ),
                          SizeBoxHeight3(),
                          AppField(
                            validator: (value) =>
                                ValidatorScreen.emailValidation(value!),
                            textEditingController: _emailController,
                            hintText: "Enter your email",
                            hintTextColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                            borderSideColor: AppTheme.appColor,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                           AppText(
                            "Address*",
                            size: 16,
                            color: Color(0xffF70000),
                          ),
                          SizeBoxHeight3(),
                          AppField(
                            validator: (value) =>
                                ValidatorScreen.emailValidation(value!),
                            textEditingController: _addressController,
                            hintTextColor: AppTheme.appColor,
                            hintText: "Enter your address",
                            borderRadius: BorderRadius.circular(10),
                            borderSideColor: AppTheme.appColor,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          AppText(
                            "Country*",
                            size: 16,
                            color: Color(0xffF70000),
                          ),
                          SizeBoxHeight3(),
                          Container(
                            height: 45,
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
                                    _countryNameController.text =
                                        countryCode?.name ?? '';
                                    _countryInitialController.text =
                                        countryCode?.code ?? '';
                                  },
                                  theme: CountryTheme(
                                    isShowFlag: true,
                                    showEnglishName: true,
                                    isShowCode: false,
                                    isShowTitle: true,
                                    isDownIcon: false,
                                  ),
                                  initialSelection: "US",
                                  useUiOverlay: false,
                                  useSafeArea: false,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          AppText(
                            "Phone No.*",
                            size: 16,
                            color: Color(0xffF70000),
                          ),
                          SizeBoxHeight3(),
                          InternationalPhoneNumberInput(
                            keyboardType: TextInputType.number,
                            onInputChanged: (PhoneNumber number) {
                            
                            },
                            inputDecoration: const InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder( borderSide: BorderSide(width: 1,color:Color(0xffF70000)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10),
                                      ),),
                                      disabledBorder:OutlineInputBorder( borderSide: BorderSide(width: 1,color:Color(0xffF70000)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10),
                                      ),), 
                                      enabledBorder: OutlineInputBorder( borderSide: BorderSide(width: 1,color:Color(0xffF70000)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10),
                                      ),),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color:Color(0xffF70000)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10),
                                      ),
                                   
                                      ),
                                      
                                    
                              hintText: 'Phone Number',
                              
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
                            ),
                          ),
                        SizeBoxHeight15(),  
                          Center(
                            child: AppButton(
                              onPressed: () {
                                if (globalKey.currentState!.validate()) {
                                  final snackBar =
                                      SnackBar(content: Text("hello"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              text: "Save Changes",
                              textSize: 16,
                              width: size.width * 0.32,
                              height: 45,
                              textColor: Colors.white,
                              btnColor: AppTheme.appColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              
              ],
            ),
          ),
        ),
   
      ),
    );
  }
}
