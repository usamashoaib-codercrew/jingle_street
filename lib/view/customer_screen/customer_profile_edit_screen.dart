import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/dio/functions.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
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
                             ),
                           SizedBox(
                            height: 4,
                          ),
                          AppText(
                            "Phone Number *",
                            size: 15,
                            color: AppTheme.appColor,
                          ),
                          SizeBoxHeight4(),
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
  }
}
