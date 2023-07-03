import 'package:country_list_pick/country_list_pick.dart';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/connectivity/connectivity.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/dio/functions.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/widgets/button/radio_button.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/fields/password_field.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jingle_street/view/auth_screen/login_screen.dart';
import 'package:jingle_street/view/auth_screen/otp_screen.dart';
import 'package:req_fun/req_fun.dart';

import '../../resources/widgets/others/custom_appbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;

  late AppDio dio;
  AppLogger logger = AppLogger();
  GlobalKey<FormState> formKey = GlobalKey();
  String? phone;
  int type = 2;
  String _initialCountry = 'US';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _resetCountryNameController = TextEditingController();

  final _resetCountryInitialController = TextEditingController();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: ReusableAppBar(
        BackButton: true,
        ontap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
        }
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeBoxHeight4(),
              AppText(
                "Sign Up",
                size: 24,
                bold: FontWeight.bold,
              ),
              SizeBoxHeight4(),
              AppText(
                "Create your account",
                size: 18,
                color: Color(0xffFFFFFF),
              ),
              SizeBoxHeight4(),
              Form(
                key: formKey,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, left: 39, right: 40),
                            child: AppText(
                              "Select one to proceed:",
                              size: 20,
                              color: AppTheme.appColor,
                              bold: FontWeight.w700,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 40),
                            child: Row(
                              children: [
                                AppRadioButton(
                                  value: 0,
                                  groupValue: type,
                                  text: 'Customer',
                                  onChanged: (value) {
                                    setState(() {
                                      type = value!;
                                    });
                                  },
                                ),
                                AppRadioButton(
                                  value: 1,
                                  groupValue: type,
                                  text: 'Vendor',
                                  onChanged: (value) {
                                    setState(() {
                                      type = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Name *",
                              size: 15,
                              bold: FontWeight.w400,
                              color: AppTheme.appColor,
                            ),
                            SizeBoxHeight4(),
                            AppField(
                              validator:
                                  Validator.required('First Name Required'),
                              textEditingController: _nameController,
                              hintText: "Enter your name",
                              hintTextColor: Color.fromRGBO(247, 0, 0, 0.5),
                              borderRadius: BorderRadius.circular(10),
                              borderSideColor: AppTheme.appColor,
                            ),
                            SizeBoxHeight8(),
                            AppText(
                              "Email *",
                              size: 15,
                              bold: FontWeight.w400,
                              color: AppTheme.appColor,
                            ),
                            SizeBoxHeight4(),
                            AppField(
                              validator:
                                  Validator.email("Invalid email address"),
                              textEditingController: _emailController,
                              hintText: "Enter your email",
                              hintTextColor: Color.fromRGBO(247, 0, 0, 0.5),
                              borderRadius: BorderRadius.circular(10),
                              borderSideColor: AppTheme.appColor,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizeBoxHeight8(),
                            AppText("Country *",
                                size: 15, color: AppTheme.appColor),
                            Container(
                              height: 50,
                              width: size.width * 0.92,
                              margin:
                                  const EdgeInsets.only(top: 3, bottom: 8),
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
                                      _resetCountryNameController.text = countryCode?.name ?? '';
                                      _resetCountryInitialController.text = countryCode?.code ?? '';
                                      setState(() {
                                        _initialCountry = _resetCountryInitialController.text = countryCode?.code ?? '';
                                      });
                                    },
                                    appBar: AppBar(
                                      backgroundColor: Colors.red,
                                      title: const Text('Pick your country'),
                                    ),
                                    theme: CountryTheme(
                                      isShowFlag: true,
                                      showEnglishName: true,
                                      isShowCode: false,
                                      labelColor:Colors.red ,
                                      alphabetSelectedBackgroundColor: Colors.red,
                                      alphabetSelectedTextColor: Colors.black,
                                      alphabetTextColor: Colors.red,
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
                            SizeBoxHeight2(),
                            AppText(
                              "Phone Number *",
                              size: 15,
                              color: AppTheme.appColor,
                            ),
                            SizeBoxHeight4(),
                            InternationalPhoneNumberInput(
                              initialValue:
                                  PhoneNumber(isoCode: _initialCountry),
                              keyboardType: TextInputType.number,
                              onInputChanged: (PhoneNumber number) {
                                // e.g. +1234567890
                                phone = number.phoneNumber;
                                setState(() {});
                              },
                              inputDecoration: InputDecoration(
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.appColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.appColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.appColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppTheme.appColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                hintText: '(425) 123-4567',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(247, 0, 0, 0.5),
                                  fontSize: 15,
                                  fontFamily: "Roboto Condensed",
                                ),
                              ),
                              selectorTextStyle: const TextStyle(
                                color: Color.fromRGBO(247, 0, 0, 0.5),
                              ),
                              selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
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
                            SizeBoxHeight8(),
                            AppText(
                              "Password *",
                              bold: FontWeight.w400,
                              size: 15,
                              color: AppTheme.appColor,
                            ),
                            SizeBoxHeight4(),
                            AppPasswordField(
                              controller: _passwordController,
                              hintText: "Enter your password",
                              fontSize: 15,
                              hintColor: Color.fromRGBO(247, 0, 0, 0.5),
                              borderRadius: BorderRadius.circular(10),
                              borderSideColor: AppTheme.appColor,
                              visibilityColor: AppTheme.appColor,
                              validator: (value) {
                                if (value!.length < 6) {
                                  return "Password must be at least 6 characters";
                                } else if (value.isEmpty) return "Required";
                                return null;
                              },
                            ),
                            SizeBoxHeight8(),
                            AppText(
                              "Re-enter Password *",
                              size: 15,
                              bold: FontWeight.w400,
                              color: AppTheme.appColor,
                            ),
                            SizeBoxHeight4(),
                            AppPasswordField(
                              controller: _confirmPasswordController,
                              hintText: "Re-enter your password ",
                              fontSize: 15,
                              hintColor: Color.fromRGBO(247, 0, 0, 0.5),
                              borderRadius: BorderRadius.circular(10),
                              borderSideColor: AppTheme.appColor,
                              visibilityColor: AppTheme.appColor,
                              validator: (value) {
                                if (value!.trim().isEmpty) return "Required";
                                if (_passwordController.getText() !=
                                    value.trim())
                                  return "Password is not matched";
                                return null;
                              },
                            ),
                            SizeBoxHeight16(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  onPressed: () {
                                    if (type == 0 || type == 1) {
                                      _continue(context);

                                    } else {
                                      MessageDialog(
                                              title: 'Select',
                                              message:
                                                  "Please select vendor or customer ")
                                          .show(context);
                                    }
                                  },
                                  text: "Register",
                                  textSize: 18,
                                  fontweight: FontWeight.w400,
                                  width: 150,
                                  height: 48,
                                  textColor: Colors.white,
                                  btnColor: AppTheme.appColor,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizeBoxHeight16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Have an account? ",
                    size: 15,
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: () {
                      replace(LoginScreen());
                    },
                    child: AppText(
                      "Sign In",
                      underline: true,
                      size: 15,
                      bold: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _continue(context) {
    if (formKey.currentState!.validate()) {
      connectivity(context);
    } else {
    }
  }

  connectivity(context) {
    internet(
      connected: () {
        _login(context);
      },
      notConnected: () {
        MessageDialog(
            title: "Connectivity!",
            message:
            "It looks like you are not connected to the internet. Please check your internet connection and try again...")
            .show(context);
      },
    );
  }

  _login(context) async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;
    var response;

    try {
      response = await dio.post(path: AppUrls.signUpUrl, data: {
        "name": _nameController.getText(),
        "phoneNumber": phone,
        "email": _emailController.getText(),
        "password": _passwordController.getText(),
        "type": type,
      });

      var responseData = response.data;

      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;

        if (resData['status'] == true) {
          var data = responseData['data']['user'];
          var token = responseData['data']['token'];
          Prefs.getPrefs().then((prefs) async {
            prefs.setString(PrefKey.authorization,token ?? '');
            prefs.setString(PrefKey.phone,data['phoneNumber'] ?? '');
          }).then((value) {
            replace(OtpScreen(
              phoneNumber: data['phoneNumber'],
            ));
          });

        } else {
          MessageDialog(
                  title: resData['status'] == false ? "False" : "",
                  message: resData['message'] ??
                      "Something went wrong, please try again!")
              .show(context);
        }
      } else if (response.data != null &&
          response.data['description'] != null) {
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
}
