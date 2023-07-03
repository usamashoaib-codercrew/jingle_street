import 'dart:async';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/connectivity/connectivity.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/dio/functions.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/auth_screen/login_screen.dart';
import 'package:jingle_street/view/home_screen/home_nav_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _smsCodeController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  int start = 180;
  bool loading = false;
  String time = '00:00';
  bool again = false;
  AppLogger _logger = AppLogger();
  late AppDio dio;
  String userNumber = '';
  var otpFieldVisibility = false;
  var receivedID = '';

  //new data
  String? _verificationId;
  bool _verificationInProgress = false;
  late Timer timer;

  @override
  void initState() {
    dio = AppDio(context);
    startTimer();
    _verifyPhoneNumber(widget.phoneNumber);
    _logger.init();
    super.initState();
  }

  @override
  void dispose() {
    _smsCodeController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.appColor,
      appBar: ReusableAppBar(BackButton: false),
      body: Padding(
        padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, right: 15, left: 15, bottom: 20),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/mob.png"))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AppText(
                      "OTP Verification",
                      color: AppTheme.appColor,
                      bold: FontWeight.bold,
                      size: 24,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AppText(
                      "Enter OTP code send to ${widget.phoneNumber}",
                      color: AppTheme.appColor,
                      bold: FontWeight.w400,
                      size: 18,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    OtpTextField(
                      handleControllers: _handleControllers,
                      textStyle: TextStyle(fontSize: 18),
                      numberOfFields: 6,
                      showFieldAsBox: true,
                      fieldWidth: 40,
                      hasCustomInputDecoration: true,
                      cursorColor: AppTheme.appColor,
                      decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppTheme.appColor, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppTheme.appColor, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppTheme.appColor, width: 1)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.appColor),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),

                    SizeBoxHeight32(),

                    AppText(
                      "Didn't receive OTP code?",
                      color: AppTheme.appColor,
                      bold: FontWeight.w400,
                      size: 18,
                      onTap: () {},
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: start != 0
                                ? null
                                : () {
                                    start = 180;
                                    startTimer();
                                    _verifyPhoneNumber(widget.phoneNumber);
                                    setState(() {});
                                  },
                            child: AppText(
                              "Resend Code",
                              bold: FontWeight.bold,
                              size: 16,
                              color: AppTheme.appColor,
                              underline: true,
                            )),
                        AppText(
                          time,
                          color: AppTheme.appColor,
                          size: 17,
                          bold: FontWeight.w300,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    AppButton(
                      text: "Verify & Proceed",
                      width: 240,
                      height: 48,
                      borderRadius: 16,
                      fontweight: FontWeight.w400,
                      textColor: AppTheme.whiteColor,
                      btnColor: AppTheme.appColor,
                      textSize: 18,
                      onPressed: () {
                        String smsCode = _smsCodeController.text.trim();
                        if (smsCode.isNotEmpty) {
                          _signInWithPhoneNumber(smsCode);
                        }
                      },
                    ),

                    SizeBoxHeight8(),
                    AppButton(
                      text: "Log out",
                      width: 240,
                      height: 48,
                      borderRadius: 16,
                      btnColor: AppTheme.appColor,
                      textSize: 18,
                      onPressed: () async {
                        await clearUserData();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        replace(LoginScreen());
                      },
                      textColor: AppTheme.whiteColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
          int sec = start % 60;
          int min = (start / 60).floor();
          String minute = min.toString().length <= 1 ? "0$min" : "$min";
          String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
          time = "$minute : $second";
        });
      }
    });
  }

  connectivity(context) {
    internet(
      connected: () {
        signUpVerify(context);
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

  signUpVerify(context) async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;
    var response;

    try {
      response = await dio.post(path: AppUrls.verifySignUp);
      var responseData = response.data;
      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;
        var data = responseData['data']['user'];
        if (resData['status'] == true) {
          Prefs.getPrefs().then((prefs) async {
            prefs.setString(PrefKey.id, data['id']);
            prefs.setString(PrefKey.name, data['name'] ?? "");
            prefs.setString(PrefKey.phone, data['phoneNumber'] ?? "");
            prefs.setString(PrefKey.email, data['email'] ?? "");
            prefs.setInt(PrefKey.type, data['type']);
            prefs.setInt(PrefKey.verified, data['verified']);
            var token = prefs.getString('fcm_token');
            getAuthToken(token!);
          }).then((value) {
            replace(HomeNavScreen(type: data['type']));
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
        );
      } else {
        responseError(context, response);
      }
    } catch (e, s) {
      print(e);
      print(s);
      if (loading) {
        loading = false;
      }

      MessageDialog(title: e.toString(), message: response["message"])
          .show(context);
    }
  }

  //new data
  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      _verificationInProgress = true;
    });

    verificationCompleted(AuthCredential phoneAuthCredential) {
      setState(() {
        _verificationInProgress = false;
      });

      FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((userCredential) {
        // Handle sign in success
        // User sign-in successful, navigate to home screen
        //Navigator.pushReplacementNamed(context, '/home');
      }).catchError((error) {
        // Handle sign in failure
        // User sign-in failed, show error message
        setState(() {
          // _verificationError = true;
          // _verificationErrorMessage = error.message;
          _verificationInProgress = false;
        });
      });
    }

    verificationFailed(FirebaseAuthException authException) {
      setState(() {
        _verificationInProgress = false;
      });

      if (authException.code == 'missing-phone-number') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The phone number is missing.'),
        ));
      } else if (authException.code == 'missing-client-identifier') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid captcha. Try again.'),
        ));
      } else if (authException.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'You have been blocked due to unusual activity. Try again later.'),
        ));
      } else if (authException.code == 'quota-exceeded') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The SMS quota for the project has been exceeded.'),
        ));
      } else if (authException.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('The user account has been disabled by an administrator.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${authException.message}'),
        ));
      }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //       'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}'),
      // ));
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      setState(() {
        _verificationId = verificationId;
        _verificationInProgress = false;
      });

      // _forceResendingToken = forceResendingToken;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification code sent to $phoneNumber'),
      ));
    }

    codeAutoRetrievalTimeout(String verificationId) {
      setState(() {
        _verificationId = verificationId;
      });
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (error) {
      setState(() {
        _verificationInProgress = false;
      });
    }
  }

  Future<void> _signInWithPhoneNumber(String smsCode) async {
    setState(() {
      _verificationInProgress = true;
    });

    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((userCredential) {
      setState(() {
        _verificationInProgress = false;
      });
      // Handle sign in success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Phone number Verified Successfully!'),
      ));
      // replace(LoginScreen());
      connectivity(context);
    }).catchError((error) {
      setState(() {
        _verificationInProgress = false;
      });

      if (error.code == 'session-expired') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('SMS code Expired. Resend verification code to try again.'),
        ));
      } else if (error.code == 'sms-code-timeout') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Request timed out. Please try again.'),
        ));
      } else if (error.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Invalid SMS code. Resend and check user-provided code.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${error.message}'),
        ));
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Phone number sign in failed. Error: $error'),
      // ));
    });
  }

  void _handleControllers(List<TextEditingController?> controllers) {
    final code = controllers.map((c) => c?.text).join('');
    _smsCodeController.text = code;
  }

  clearUserData() async {
    await Prefs.remove(PrefKey.authorization);
  }

  Future<void> getAuthToken(String tokenIs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final fcm_tokenGEt = prefs.getString('fcm_token');
    final Map<String, dynamic> headers = {
      'Authorization':
          'Bearer $tokenIs', // Replace with your actual authorization token
      // 'Content-Type': 'application/json',
    };
    try {
      final response = await dio.post(
          options: Options(headers: headers),
          path: AppUrls.updatefcmToken,
          data: {
            'fcm': fcm_tokenGEt,
          });
      if (response.statusCode == StatusCode.OK) {
        print("FCM TOKEN HAS BEEN ADDED SUCCESSFULLY $fcm_tokenGEt");
      }
    } catch (e, stackTrace) {
      print('Update FCM token exception: $e\nStack trace: $stackTrace');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('FCM Token not updated.'),
      // ));
    }
  }
}
