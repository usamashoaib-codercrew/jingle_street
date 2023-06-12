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
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/fields/password_field.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/auth_screen/otp_screen.dart';
import 'package:jingle_street/view/auth_screen/signup_screen.dart';
import 'package:jingle_street/view/home_screen/home_nav_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool _isChecked = false;
  bool _isVendor = false;
  bool _isCustomer = true;
  String ? name;
  late AppDio dio;
  AppLogger Logger = AppLogger();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String userEmail = '';

  @override
  void initState() {
    _loadUserEmailPassword();
    dio = AppDio(context);
    Logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ReusableAppBar(
        BackButton: false,
      ),
      backgroundColor: AppTheme.appColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizeBoxHeight32(),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AppText(
                    "Sign In",
                    color: Colors.white,
                    bold: FontWeight.bold,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizeBoxHeight4(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: AppText(
                  "Sign in to your account.",
                  color: Colors.white,
                  size: 18,
                  bold: FontWeight.w300,
                ),
              ),
            ),
            SizeBoxHeight4(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizeBoxHeight16(),
                  AppText(
                    "Select one to proceed:",
                    bold: FontWeight.bold,
                    color: AppTheme.appColor,
                    size: 20,
                  ),
                  SizeBoxHeight8(),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          onPressed: () {
                            setState(() {
                              _isCustomer = true;
                              _isVendor = false;
                            });
                          },
                          borderRadius: 30,
                          isBorder: false,
                          btnColor:
                              _isCustomer ? AppTheme.appColor : Colors.white,
                          text: 'Customer',
                          textColor:
                              _isCustomer ? Colors.white : AppTheme.appColor,
                          textSize: _isCustomer == true ? 16 : 18,
                          width: width * 0.25,
                        ),
                        AppButton(
                          onPressed: () {
                            setState(() {
                              _isVendor = true;
                              _isCustomer = false;
                            });
                          },
                          borderRadius: 30,
                          isBorder: false,
                          btnColor:
                              _isVendor ? AppTheme.appColor : Colors.white,
                          text: 'Vendor',
                          textColor:
                              _isVendor ? Colors.white : AppTheme.appColor,
                          textSize: 18,
                          width: width * 0.25,
                        )
                      ],
                    ),
                  ),
                  SizeBoxHeight16(),
                ],
              ),
            ),
            SizeBoxHeight16(),
            Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizeBoxHeight64(),
                      AppText(
                        "Email or Number *",
                        color: AppTheme.appColor,
                        size: 15,
                      ),
                      SizeBoxHeight4(),
                      AppField(
                        hintText: "Enter email or mobile number",
                        hintTextColor: Color.fromRGBO(247, 0, 0, 0.5),
                        textEditingController: _emailController,
                        fillColor: AppTheme.appColor,
                        borderSideColor: AppTheme.appColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizeBoxHeight8(),
                      AppText(
                        "Password *",
                        color: AppTheme.appColor,
                        size: 15,
                      ),
                      SizeBoxHeight4(),
                      AppPasswordField(
                          borderSideColor: AppTheme.appColor,
                          borderRadius: BorderRadius.circular(10),
                          hintColor: Color.fromRGBO(247, 0, 0, 0.5),
                          hintText: "Enter Password",
                          visibilityColor: AppTheme.appColor,
                          fontSize: 15,
                          controller: _passwordController),
                      SizeBoxHeight4(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     AppCheckBox(
                      //       hoverColor: AppTheme.appColor,
                      //       activeColor: Colors.white,
                      //       borderSidewidth: 0.1,
                      //       borderSideColor: AppTheme.appColor,
                      //       focusColor: AppTheme.appColor,
                      //       checkColor: AppTheme.appColor,
                      //       value: _isChecked,
                      //       onChanged: (val) {
                      //         _handleRememberMe(val!);
                      //         // saveLoginData(val!);
                      //       },
                      //     ),
                      //     Expanded(
                      //       child: AppText("Remember me",
                      //           color: AppTheme.appColor, size: 15),
                      //     ),
                      //     // AppText(
                      //     //   "Forgot password?",
                      //     //   color: AppTheme.appColor,
                      //     //   size: 12,
                      //     //   onTap: () {
                      //     //     Navigator.push(
                      //     //         context,
                      //     //         MaterialPageRoute(
                      //     //           builder: (context) =>
                      //     //               SetPasswordByPhoneNumber(),
                      //     //         ));
                      //     //   },
                      //     // ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              _continue(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.appColor),
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.appColor),
                              height: 48,
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizeBoxWidth8(),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 29,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizeBoxHeight64(),
                    ],
                  ),
                ),
              ),
            ),
            SizeBoxHeight32(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  "Don't have an account? ",
                  size: 15,
                  color: Colors.white,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));
                  },
                  child: AppText(
                    "Sign Up",
                    underline: true,
                    size: 15,
                    bold: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizeBoxHeight32(),
          ],
        ),
      ),
    );
  }

  _continue(context) {
    if (formKey.currentState!.validate()) {
      connectivity(context);
      print("...............ok");
    } else {
      print(".......... not Ok");
    }
  }

  connectivity(context) {
    internet(connected: () {
      _loginUser(context);
    }, notConnected: () {
      MessageDialog(
              title: "Connectivity!",
              message:
                  "It looks like you are not connected to the internet. Please check your internet connection and try again...")
          .show(context);
    });
  }

  _loginUser(context) async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;
    var response;

    try {
      response = await dio.post(path: AppUrls.loginUrl, data: {
        "info": _emailController.getText(),
        "password": _passwordController.getText(),
      });

      var responseData = response.data;
    

      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        // print("........${resData['status']}");

        if (resData['status']) {
          var data = responseData['data']['user'];
          var token = responseData['data']['token'];
          if (data['verified'] == 1) {
            Prefs.getPrefs().then((prefs) async {
              prefs.setString(PrefKey.id, data['id']);
              prefs.setString(PrefKey.name, data['name'] ?? "");
              prefs.setString(PrefKey.phone, data['phoneNumber'] ?? "");
              prefs.setString(PrefKey.email, data['email'] ?? "");
              prefs.setInt(PrefKey.type, data['type'] ?? "");
              prefs.setString(PrefKey.password, _passwordController.text);
              prefs.setInt(PrefKey.verified, data['verified'] ?? "");
              prefs.setString(PrefKey.authorization, token);
            }).then((value) {
              if (data['type'] == 1 && _isVendor == true) {
                replace(HomeNavScreen(type: data['type'],token: token,));
              } else if (data['type'] == 0 && _isCustomer == true) {
                replace(HomeNavScreen(type: data['type']));
              } else {
                MessageDialog(
                        title: "Select",
                        message:
                            "Something went wrong!\nPlease! Select Correct type")
                    .show(context);
              }
            });
          } else {
            Prefs.getPrefs().then((prefs) async {
              prefs.setString(PrefKey.authorization, token);
              prefs.setString(PrefKey.phone, data['phoneNumber'] ?? "");
            }).then((value) {
              if (data['type'] == 1 && _isVendor == true) {
                replace(OtpScreen(
                  phoneNumber: data['phoneNumber'] ?? "",
                ));
              } else if (data['type'] == 0 && _isCustomer == true) {
                replace(OtpScreen(
                  phoneNumber: data['phoneNumber'] ?? "",
                ));
              } else {
                MessageDialog(
                        title: "Select",
                        message:
                            "Something went wrong!\nPlease! Select Correct type")
                    .show(context);
              }
            });
          }
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

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString(PrefKey.email) ?? "";
      var password = prefs.getString(PrefKey.password) ?? "";
      _emailController.text = email;
      _passwordController.text = password;
    } catch (e) {
      print(e);
    }
  }
}
