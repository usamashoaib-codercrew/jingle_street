import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/connectivity/connectivity.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/dio/functions.dart';
import 'package:jingle_street/config/functions/navigator_functions.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jingle_street/resources/widgets/validator/validator.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/keys/pref_keys.dart';

class CustomerProfileEdit extends StatefulWidget {
  const CustomerProfileEdit({Key? key}) : super(key: key);

  @override
  State<CustomerProfileEdit> createState() => _CustomerProfileEditState();
}

class _CustomerProfileEditState extends State<CustomerProfileEdit> {
  GlobalKey<FormState> globalKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  String? phone;
  String? name;
  bool loading = false;
  late AppDio dio;
  AppLogger Logger = AppLogger();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    getUserData();
    dio = AppDio(context);
    Logger.init();
    _getValueFromPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF70000),
      appBar: SimpleAppBar(
        text: "Profile",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Welcome Back!  ${name}",
                        size: 24,
                        bold: FontWeight.w700,
                      ),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     DottedBorder(
                  //         color: Colors.white,
                  //         dashPattern: [10, 5],
                  //         borderType: BorderType.Circle,
                  //         padding: EdgeInsets.all(6),
                  //         child: Container(
                  //           height: 110,
                  //           width: 110,
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(70),
                  //               border: Border.all(
                  //                 color: Colors.white,
                  //                 width: 1,
                  //               )),
                  //         )),
                  //     SizeBoxHeight12(),
                  //     Container(
                  //       height: 30,
                  //       width: 120,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(6),
                  //           color: Colors.white),
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 7.0, right: 7),
                  //         child: InkWell(
                  //           onTap: () async {
                  //             bool isPermissionGranted =
                  //                 await requestPhotosPermission();
                  //             if (isPermissionGranted) {
                  //               print("yes..............");
                  //               AlertDialog(
                  //                 actions: [Icon(Icons.abc)],
                  //               );
                  //             } else {
                  //               print("noo..............");

                  //               AlertDialog(
                  //                 actions: [Icon(Icons.cancel_outlined)],
                  //               );
                  //             }
                  //           },
                  //           //   showDialog(
                  //           //       context: context,
                  //           //       builder: (context) {
                  //           //         return SimpleDialog(
                  //           //           shape: RoundedRectangleBorder(
                  //           //               borderRadius:
                  //           //                   BorderRadius.circular(20)),
                  //           //           contentPadding: EdgeInsets.zero,
                  //           //           backgroundColor: AppTheme.appColor,
                  //           //           children: [
                  //           //             SizeBoxHeight12(),
                  //           //             Column(
                  //           //               children: [
                  //           //                 Row(
                  //           //                   mainAxisAlignment:
                  //           //                       MainAxisAlignment.center,
                  //           //                   children: [
                  //           //                     Container(
                  //           //                       child: Image(
                  //           //                         image: AssetImage(
                  //           //                           "assets/images/Vector9.png",
                  //           //                         ),
                  //           //                         height: 30,
                  //           //                         width: 30,
                  //           //                       ),
                  //           //                     )
                  //           //                   ],
                  //           //                 ),
                  //           //                 SizeBoxHeight16(),
                  //           //                 RichText(
                  //           //                   text: TextSpan(
                  //           //                     children: [
                  //           //                       TextSpan(
                  //           //                           text:
                  //           //                               "Allow Jingle Street to access photos and\n\n           media on your",
                  //           //                           style: TextStyle(
                  //           //                               color: AppTheme
                  //           //                                   .whiteColor)),
                  //           //                       TextSpan(
                  //           //                           text: " device?",
                  //           //                           style: TextStyle(
                  //           //                               fontWeight:
                  //           //                                   FontWeight.bold,
                  //           //                               color: AppTheme
                  //           //                                   .whiteColor))
                  //           //                     ],
                  //           //                   ),
                  //           //                 ),
                  //           //                 SizeBoxHeight32(),
                  //           //                 Container(
                  //           //                   decoration: BoxDecoration(
                  //           //                       border: Border(
                  //           //                     top: BorderSide(
                  //           //                         width: 2,
                  //           //                         color:
                  //           //                             AppTheme.whiteColor),
                  //           //                   )),
                  //           //                   child: Row(
                  //           //                     mainAxisAlignment:
                  //           //                         MainAxisAlignment
                  //           //                             .spaceEvenly,
                  //           //                     children: [
                  //           //                       InkWell(
                  //           //                         onTap: () {
                  //           //                           pop(context);
                  //           //                         },
                  //           //                         child: Container(
                  //           //                           height: 50,
                  //           //                           width: 150 /
                  //           //                               size.width *
                  //           //                               150,
                  //           //                           child: Center(
                  //           //                             child: Text(
                  //           //                               "Don't Allow",
                  //           //                               style: TextStyle(
                  //           //                                   color: AppTheme
                  //           //                                       .whiteColor),
                  //           //                             ),
                  //           //                           ),
                  //           //                         ),
                  //           //                       ),
                  //           //                       Container(
                  //           //                         width: 3,
                  //           //                         height: 50,
                  //           //                         decoration: BoxDecoration(
                  //           //                             border: Border(
                  //           //                           right: BorderSide(
                  //           //                               width: 2,
                  //           //                               color: AppTheme
                  //           //                                   .whiteColor),
                  //           //                         )),
                  //           //                       ),
                  //           //                       InkWell(
                  //           //                         onTap: () {
                  //           //                           pop(context);
                  //           //                         },
                  //           //                         child: Container(
                  //           //                           height: 40,
                  //           //                           width: 150 /
                  //           //                               size.width *
                  //           //                               150,
                  //           //                           child: Center(
                  //           //                             child: Text(
                  //           //                               "Allow",
                  //           //                               style: TextStyle(
                  //           //                                   fontWeight:
                  //           //                                       FontWeight
                  //           //                                           .bold,
                  //           //                                   color: AppTheme
                  //           //                                       .whiteColor),
                  //           //                             ),
                  //           //                           ),
                  //           //                         ),
                  //           //                       ),
                  //           //                     ],
                  //           //                   ),
                  //           //                 )
                  //           //               ],
                  //           //             ),
                  //           //           ],
                  //           //         );
                  //           //       });
                  //           // },
                  //           child: Row(
                  //             children: [
                  //               AppText(
                  //                 "Change Image",
                  //                 color: AppTheme.appColor,
                  //                 size: 14,
                  //                 bold: FontWeight.w400,
                  //               ),
                  //               SizeBoxWidth8(),
                  //               Icon(
                  //                 Icons.camera_alt,
                  //                 size: 18,
                  //                 color: AppTheme.appColor,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Form(
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
                          SizeBoxHeight4(),
                          AppField(
                            validator: (value) =>
                                ValidatorScreen.nameValidation(value!),
                            textEditingController: _nameController,
                            hintText: "Enter full name",
                            hintTextColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                            borderSideColor: AppTheme.appColor,
                            // suffixIcon: InkWell(
                            //   onTap: () {
                            //     _nameController.clear();
                            //   },
                            //   child: Icon(
                            //     Icons.edit,
                            //     color: AppTheme.appColor,
                            //     size: 22,
                            //   ),
                            // ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          AppText(
                            "Email*",
                            size: 16,
                            color: Color(0xffF70000),
                          ),
                          SizeBoxHeight4(),
                          AppField(
                            validator: (value) =>
                                ValidatorScreen.emailValidation(value!),
                            textEditingController: _emailController,
                            hintText: "Enter your email",
                            hintTextColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                            borderSideColor: AppTheme.appColor,
                            // suffixIcon: InkWell(
                            //   onTap: () {
                            //     _emailController.clear();
                            //   },
                            //   child: Icon(
                            //     Icons.edit,
                            //     color: AppTheme.appColor,
                            //     size: 22,
                            //   ),
                            // ),
                          ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // AppText(
                          //   "Address*",
                          //   size: 16,
                          //   color: Color(0xffF70000),
                          // ),
                          // SizeBoxHeight4(),
                          // AppField(
                          //   validator: (value) =>
                          //       ValidatorScreen.emailValidation(value!),
                          //   textEditingController: _addressController,
                          //   hintTextColor: AppTheme.appColor,
                          //   hintText: "Enter your address",
                          //   borderRadius: BorderRadius.circular(10),
                          //   borderSideColor: AppTheme.appColor,
                          //   suffixIcon: InkWell(
                          //     onTap: () {
                          //       _emailController.clear();
                          //     },
                          //     child: Icon(
                          //       Icons.edit,
                          //       color: AppTheme.appColor,
                          //       size: 22,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // AppText("Country*",
                          //     size: 15, color: AppTheme.appColor),
                          // SizeBoxHeight4(),
                          // Container(
                          //   height: 50,
                          //   width: size.width * 0.92,
                          //   margin: const EdgeInsets.only(top: 3, bottom: 8),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       width: 1.2,
                          //       color: AppTheme.appColor,
                          //     ),
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       CountryListPick(
                          //         onChanged: (CountryCode? countryCode) {
                          //           _resetCountryNameController.text =
                          //               countryCode?.name ?? '';
                          //           _resetCountryInitialController.text =
                          //               countryCode?.code ?? '';
                          //           setState(() {
                          //             _initialCountry =
                          //                 _resetCountryInitialController
                          //                     .text = countryCode?.code ?? '';
                          //           });
                          //         },
                          //         theme: CountryTheme(
                          //           labelColor: AppTheme.appColor,
                          //           alphabetTextColor: AppTheme.appColor,
                          //           // alphabetSelectedBackgroundColor: AppTheme.appColor,
                          //           alphabetSelectedTextColor:
                          //               AppTheme.appColor,
                          //           isShowFlag: true,
                          //           showEnglishName: true,
                          //           isShowCode: false,
                          //           isShowTitle: true,
                          //           isDownIcon: false,
                          //         ),
                          //         initialSelection: _initialCountry,
                          //         useUiOverlay: true,
                          //         useSafeArea: false,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 4,
                          ),
                          AppText(
                            "Phone Number *",
                            size: 15,
                            color: AppTheme.appColor,
                          ),
                          SizeBoxHeight4(),
                   // InternationalPhoneNumberInput(
                   //          textFieldController: _phoneNumberController,
                   //          initialValue: PhoneNumber(isoCode: "US"),
                   //          keyboardType: TextInputType.number,
                   //            onInputChanged: (PhoneNumber number) {
                   //              phone=number.phoneNumber;
                   //              // print(phone); // e.g. +1234567890
                   //            },
                   //            inputDecoration: InputDecoration(
                   //            // suffixIcon: InkWell(
                   //            //   onTap: () {},
                   //            //   child: Icon(
                   //            //     Icons.edit,
                   //            //     color: AppTheme.appColor,
                   //            //     size: 22,
                   //            //   ),
                   //            // ),
                   //            isDense: true,
                   //            focusedBorder: OutlineInputBorder(
                   //              borderSide: BorderSide(
                   //                  width: 1, color: AppTheme.appColor),
                   //              borderRadius: BorderRadius.all(
                   //                Radius.circular(10),
                   //              ),
                   //            ),
                   //            disabledBorder: OutlineInputBorder(
                   //              borderSide: BorderSide(
                   //                  width: 1, color: AppTheme.appColor),
                   //              borderRadius: BorderRadius.all(
                   //                Radius.circular(10),
                   //              ),
                   //            ),
                   //            enabledBorder: OutlineInputBorder(
                   //              borderSide: BorderSide(
                   //                  width: 1, color: AppTheme.appColor),
                   //              borderRadius: BorderRadius.all(
                   //                Radius.circular(10),
                   //              ),
                   //            ),
                   //            border: OutlineInputBorder(
                   //              borderSide: BorderSide(
                   //                  width: 2, color: AppTheme.appColor),
                   //              borderRadius: BorderRadius.all(
                   //                Radius.circular(10),
                   //              ),
                   //            ),
                   //            hintText: '(425) 123-4567',
                   //            hintStyle: TextStyle(
                   //              color: Color.fromRGBO(247, 0, 0, 0.5),
                   //              fontSize: 14,
                   //              fontFamily: "Roboto Condensed",
                   //            ),
                   //          ),
                   //          selectorTextStyle: const TextStyle(
                   //            color: Color.fromRGBO(247, 0, 0, 0.5),
                   //          ),
                   //          selectorConfig: const SelectorConfig(
                   //            selectorType:
                   //                PhoneInputSelectorType.BOTTOM_SHEET,
                   //            // backgroundColor: Colors.white,
                   //            showFlags: false,
                   //            setSelectorButtonAsPrefixIcon: true,
                   //            trailingSpace: false,
                   //            useEmoji: false,
                   //          ),
                   //          textStyle: const TextStyle(
                   //            color: Colors.black,
                   //            letterSpacing: 0.4,
                   //          ),),

                          AppField(
                            // validator: (value) =>
                            //     ValidatorScreen.nameValidation(value!),
                            textEditingController: _phoneNumberController,
                            hintText: "Enter phone number",
                            hintTextColor: AppTheme.appColor,
                            borderRadius: BorderRadius.circular(10),
                            borderSideColor: AppTheme.appColor,
                          ),

                          SizeBoxHeight15(),
                          Center(
                            child: AppButton(
                              onPressed: () {
                                if (globalKey.currentState!.validate()) {
                                  _customerEditProfile();
                                  final snackBar =
                                      SnackBar(content: Text("Updated"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              text: "Save Changes",
                              textSize: 14,
                              width: 130,
                              height: 48,
                              textColor: Colors.white,
                              btnColor: AppTheme.appColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _customerEditProfile() async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;
    var response;

    try {
      response = await dio.post(path: AppUrls.getCustomerProfile, data: {
        "email": _emailController.getText(),
        "name": _nameController.getText(),
        "phoneNumber": _phoneNumberController.getText(),
      });

      var responseData = response.data;

      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        if (resData['status'] == true) {
          var data = resData['data'];
          Prefs.getPrefs().then((pref) {
            pref.setString(PrefKey.name, data["name"]);
            pref.setString(PrefKey.email, data["email"]);
            pref.setString(PrefKey.phone, data["phoneNumber"]);
          });
        } else {
          MessageDialog(
                  title: resData['status'] == false ? "False" : "",
                  message: resData['message'] ??
                      "Something went wrong, please try again!")
              .show(context);
        }
      } else if (response.data != null) {
        MessageDialog(
                title: response.data['message'],
                message: response.data['description'] ??
                    "Something went wrong, please try again!")
            .show(context);
      } else {
        responseError(context, response);
      }
    } catch (e, s) {
      print(e);

      print(s);

      if (loading) {
        Navigator.pop(context);
        loading = false;
      }

      MessageDialog(title: e.toString(), message: response["message"])
          .show(context);
    }
  }

  _getValueFromPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _nameController.text = pref.getString(PrefKey.name)!;
    _emailController.text = pref.getString(PrefKey.email)!;
    _phoneNumberController.text = pref.getString(PrefKey.phone)!;
    setState(() {});
  }

  getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      name = prefs.getString(PrefKey.name);
    });
    // print("...........++++++++.${name}");
  }
}
