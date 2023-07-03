import 'dart:io';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/connectivity/connectivity.dart';
import 'package:jingle_street/config/dio/functions.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/config/logger/app_logger.dart';
import 'package:jingle_street/resources/res/app_assets.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/button/radio_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_switch.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/profile_image.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/resources/widgets/others/popup.dart';
import 'package:req_fun/req_fun.dart';
import 'package:jingle_street/view/vendor_screen/find_marker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/dio/app_dio.dart';

enum VendorType { Stationary, Mobile }

class VendorProfile extends StatefulWidget {
  VendorProfile({super.key});

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  GlobalKey<FormState> globalKey = GlobalKey();
  VendorType? _vendorSelection = VendorType.Stationary;
  TextEditingController _bNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _hashTagController = TextEditingController();
  TextEditingController _timeOpenController = TextEditingController();
  TextEditingController _timeCloseControllerTwo = TextEditingController();

  String? profileImage;
  String _location = "";

  bool _statusCode = false;
  int _statusCodeInIntTrue = 1;
  int _statusCodeInIntFalse = 0;
  bool _loading = false;
  num lat = 0.0;
  num long = 0.0;
  late AppDio _dio;
  AppLogger _logger = AppLogger();
  Position? _mobileVendorPosition;
  GlobalKey<FormState> formKey = GlobalKey();
  LatLng? _selectedLatLng;
  int type = 2;

  _getValueFromShared() async {
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool value = pref.getBool(PrefKey.onAndOffStatus)??false;
      setState(() {
        _statusCode = value;
      });
    }
    catch(e){
    }

  }

  void initState() {
    super.initState();
    _dio = AppDio(context);
    _logger.init();
    _getValueFromShared();
    _getVendorProfile(context);
    _getCurrentPosition();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      body: Padding(
        padding:
        const EdgeInsets.only(left: 15.0, right: 15, top: 40, bottom: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Icon(
                              Icons.chevron_left,
                              color: AppTheme.error,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      AppText(
                        "Welcome Back!",
                        size: 24,
                        bold: FontWeight.bold,
                      ),
                      SizeBoxHeight8(),
                      AppText(
                        "Create your business profile",
                        size: 18,
                      )
                    ],
                  ),
                  AppProfileImage(
                    title: "Profile",
                    imagePicker: true,
                    height: 100,
                    width: 100,
                    radius: 50,
                    imageUrl: profileImage,
                    onImageSelected: (path, name) {
                      setState(
                            () {
                          if (path.path.isNotEmpty) {
                            File _addProfileImage = path;
                            connectivityPic(context, _addProfileImage);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              SizeBoxHeight10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _statusCode == true
                      ? AppText(
                    "Online",
                    size: 20,
                    bold: FontWeight.w700,
                  )
                      : AppText(
                    "Offline",
                    size: 20,
                    bold: FontWeight.w700,
                  ),
                  SizeBoxWidth8(),
                  Container(
                    child: FlutterSwitch(
                      inactiveColor: Colors.white,
                      toggleColor: AppTheme.appColor,
                      activeColor: Colors.green,
                      activeToggleColor: Colors.white,
                      width: 56.0,
                      height: 32.0,
                      valueFontSize: 5.0,
                      toggleSize: 25.0,
                      value: _statusCode,
                      borderRadius: 35.0,
                      padding: 4.0,
                      showOnOff: false,
                      onToggle: (val) {
                        // _changeStatusCode();
                        setState(() {
                          _statusCode = val;
                        });
                        _StatusCodeUpate();
                        Prefs.getPrefs().then((value) {
                          value.setBool(PrefKey.onAndOffStatus, _statusCode);
                        });
                      },
                    ),
                  ),
                  SizeBoxWidth8(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: Icon(
                        Icons.info,
                        size: 22,
                        color: AppTheme.appColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: globalKey,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizeBoxHeight4(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, top: 25),
                            child: AppText(
                              "Select your business type:",
                              size: 18,
                              color: AppTheme.appColor,
                              bold: FontWeight.w700,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                AppRadioButton(
                                  value: 0,
                                  groupValue: type,
                                  text: "Stationary Vendor",
                                  onChanged: (p0) {
                                    setState(() {
                                      type = p0;
                                    });
                                  },
                                ),
                                AppRadioButton(
                                  value: 1,
                                  groupValue: type,
                                  text: "Mobile Vendor",
                                  onChanged: (p0) {
                                    setState(() {
                                      type = p0;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, bottom: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "Business Name *",
                                  bold: FontWeight.w400,
                                  size: 15,
                                  color: AppTheme.appColor,
                                ),
                                SizeBoxHeight4(),
                                AppField(
                                  // validator: (value) =>
                                  //     Validator.nameValidation(value!),
                                  textEditingController: _bNameController,
                                  textInputAction: TextInputAction.next,
                                  borderRadius: BorderRadius.circular(10),
                                  borderSideColor: AppTheme.appColor,
                                  validator: Validator.required('Required'),
                                ),
                                SizeBoxHeight8(),
                                _vendorSelection == VendorType.Stationary
                                    ? AppText(
                                  "Address *",
                                  size: 15,
                                  bold: FontWeight.w400,
                                  color: AppTheme.appColor,
                                )
                                    : AppText(
                                  "Address(Optional) *",
                                  size: 15,
                                  bold: FontWeight.w400,
                                  color: AppTheme.appColor,
                                ),
                                SizeBoxHeight4(),
                                AppField(
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) =>
                                  //     Validator.emailValidation(value!),
                                  validator: Validator.required('Required'),
                                  textEditingController: _addressController,
                                  maxLines: 3,
                                  borderRadius: BorderRadius.circular(10),
                                  borderSideColor: AppTheme.appColor,
                                ),
                                type == 0
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizeBoxHeight8(),
                                    AppText(
                                      "Pick Location *",
                                      size: 15,
                                      color: AppTheme.appColor,
                                      bold: FontWeight.w400,
                                    ),
                                    SizeBoxHeight4(),
                                    _selectedLatLng != null
                                        ? Container(
                                      width:
                                      (600 / widthScreen) * 600,
                                      height: (300 / heightScreen) *
                                          300,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://maps.googleapis.com/maps/api/staticmap?center=${_selectedLatLng!.latitude},${_selectedLatLng!.longitude}&zoom=15&size=400x400&marker=color:red%7C&location=${_selectedLatLng!.latitude},${_selectedLatLng!.longitude}&key=AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap:
                                          _onLocationContainerPressed,
                                        ),
                                      ),
                                    )
                                        : Container(
                                      width:
                                      (600 / widthScreen) * 600,
                                      height: (300 / heightScreen) *
                                          300,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              _location),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap:
                                          _onLocationButtonPressed,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : Container(),
                                SizeBoxHeight8(),
                                AppText(
                                  "Bio *",
                                  size: 15,
                                  color: AppTheme.appColor,
                                  bold: FontWeight.w400,
                                ),
                                SizeBoxHeight4(),
                                AppField(
                                  textInputAction: TextInputAction.next,
                                  // validator: (value) =>
                                  //     Validator.emailValidation(value!),
                                  textEditingController: _bioController,
                                  maxLines: 3,
                                  borderRadius: BorderRadius.circular(10),
                                  borderSideColor: AppTheme.appColor,
                                ),
                                SizeBoxHeight8(),
                                AppText(
                                  "Time *",
                                  size: 15,
                                  color: AppTheme.appColor,
                                  bold: FontWeight.w400,
                                ),
                                SizeBoxHeight4(),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: AppField(
                                          onTap: () {
                                            _selectTime(context);
                                          },
                                          readOnly: true,
                                          textEditingController:
                                          _timeOpenController,
                                          validator:
                                          Validator.required('Required'),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          borderSideColor: AppTheme.appColor,
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                          TextAlignVertical.center,
                                        )),
                                    SizeBoxWidth16(),
                                    Text("to"),
                                    SizeBoxWidth16(),
                                    SizedBox(
                                        width: 100,
                                        child: AppField(
                                          textEditingController:
                                          _timeCloseControllerTwo,
                                          onTap: () {
                                            _selectTimeTwo(context);
                                          },
                                          validator:
                                          Validator.required('Required'),
                                          readOnly: true,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          borderSideColor: AppTheme.appColor,
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                          TextAlignVertical.center,
                                        ))
                                  ],
                                ),
                                SizeBoxHeight8(),
                                AppText(
                                  "Hashtags *",
                                  size: 15,
                                  color: AppTheme.appColor,
                                  bold: FontWeight.w400,
                                ),
                                SizeBoxHeight4(),
                                AppField(
                                  // validator: (value) =>
                                  //     Validator.emailValidation(value!),
                                  textEditingController: _hashTagController,
                                  maxLines: 3,
                                  validator: Validator.required('Required'),
                                  textInputAction: TextInputAction.done,

                                  borderRadius: BorderRadius.circular(10),
                                  borderSideColor: AppTheme.appColor,
                                ),
                                SizeBoxHeight8(),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          buildPopupDialog(context),
                                    );
                                  },
                                  child: Container(
                                    width: 140,
                                    child: Row(
                                      children: [
                                        AppText(
                                          "Add Products *",
                                          size: 15,
                                          color: AppTheme.appColor,
                                          bold: FontWeight.w400,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppTheme.appColor,
                                              size: 23,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizeBoxHeight32(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppButton(
                                      text: "Save Changes",
                                      width: 150,
                                      height: 50,
                                      btnColor: AppTheme.appColor,
                                      textColor: Colors.white,
                                      textSize: 18,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (type == 0) {
                                          if (_location.isNotEmpty || _selectedLatLng !=null &&
                                              _bNameController
                                                  .text.isNotEmpty &&
                                              _addressController
                                                  .text.isNotEmpty &&
                                              _bioController.text.isNotEmpty &&
                                              _timeOpenController
                                                  .text.isNotEmpty &&
                                              _timeCloseControllerTwo
                                                  .text.isNotEmpty &&
                                              _hashTagController
                                                  .text.isNotEmpty) {
                                            _continue(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Please Fill Complete Form'),
                                            ));
                                          }
                                        } else if (type == 1 &&
                                            _bNameController.text.isNotEmpty &&
                                            _addressController
                                                .text.isNotEmpty &&
                                            _bioController.text.isNotEmpty &&
                                            _timeOpenController
                                                .text.isNotEmpty &&
                                            _timeCloseControllerTwo
                                                .text.isNotEmpty &&
                                            _hashTagController
                                                .text.isNotEmpty) {
                                          _continue(context);
                                        } else{
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Please Fill Complete Form'),
                                          ));
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _onLocationButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    ).then((value) {
      _selectedLatLng = value;
      setState(() {});
    });
  }

  void _onLocationContainerPressed() {
    if (_selectedLatLng != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapScreen()),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      // helpText: "9:00",
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeOpenController.text = picked.format(context);
      });
    }
  }

  Future<void> _selectTimeTwo(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeCloseControllerTwo.text = picked.format(context);
      });
    }
  }

  connectivityPic(context, _addProfileImage) {
    internet(connected: () {
      _addPhoto(context, _addProfileImage);
    }, notConnected: () {
      MessageDialog(
          title: "Connectivity!",
          message:
          "It looks like you are not connected to the internet. Please check your internet connection and try again...")
          .show(context);
    });
  }

  _addPhoto(context, File? _addProfileImage) async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    _loading = true;
    var formData;
    if (_addProfileImage != null) {
      String path = _addProfileImage.path;
      formData = FormData.fromMap(
        {
          "profilepic": await MultipartFile.fromFile(path),
        },
      );
    }
    try {
      var response = await _dio.post(
        path: AppUrls.profilePic,
        data: formData,
      );
      if (_loading) {
        progressDialog.dismiss();
        _loading = false;
      }
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var resData = responseData;

        if (resData['status'] == true) {
          var data = resData['data']['profilepic'];
          if (data != null) {
            Prefs.getPrefs().then((prefs) async {
              prefs.setString(PrefKey.profile, data);
              profileImage = prefs.getString(PrefKey.profile);
            });
          }
        } else {
          MessageDialog(
              title: resData['status'] == false ? "False" : "",
              message: resData['message'] ??
                  "Something went wrong, please try again!")
              .show(context);
        }
      } else {
        if (responseData != null) {
          MessageDialog(
              title: response.data['message'],
              message: response.data['description'] ??
                  "Something went wrong, please try again!")
              .show(context);
        } else {
          MessageDialog(
              title: "Error",
              message: "Something went wrong, please try again!")
              .show(context);
        }
      }
    } catch (e) {
      if (_loading) {
        progressDialog.dismiss();
        _loading = false;
      }

      MessageDialog(
          title: "Error",
          message: "Something went wrong, please try again!")
          .show(context);
    }
  }

  ////////////////////////////////////////////////////////////
  ///

  _continue(context) {
    if (globalKey.currentState!.validate()) {
      if (type == 0) {
        connectivity(context);
      } else if (type == 1) {
        connectivity(context);
      } else {
        MessageDialog(title: "Select", message: "Please Select type")
            .show(context);
      }
    }
  }

  connectivity(context) {
    internet(connected: () {
      _addVendorProfile(context);
    }, notConnected: () {
      MessageDialog(
          title: "Connectivity!",
          message:
          "It looks like you are not connected to the internet. Please check your internet connection and try again...")
          .show(context);
    });
  }

  _StatusCodeUpate() async {
    var response;
    try {
      response = await _dio.post(path: AppUrls.updateStatusCode, data: {
        "status":
        _statusCode == true ? _statusCodeInIntTrue : _statusCodeInIntFalse
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _addVendorProfile(context) async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    _loading = true;
    var response;
    var formData;
    formData = FormData.fromMap(
      {
        "businessname": _bNameController.getText(),
        "address": _addressController.getText(),
        "location":
        'https://maps.googleapis.com/maps/api/staticmap?center=${_selectedLatLng == null ? lat : _selectedLatLng!.latitude},${_selectedLatLng == null ? long : _selectedLatLng!}&zoom=15&size=400x400&marker=color:red%7C&location=${_selectedLatLng == null ? lat : _selectedLatLng!.latitude},${_selectedLatLng == null ? long : _selectedLatLng!.longitude}&key=AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU',
        "hashtags": _hashTagController.getText(),
        "type": type,
        "longitude": type == 0
            ? _selectedLatLng == null
            ? long
            : _selectedLatLng!.longitude
            : _mobileVendorPosition!.longitude,
        "latitude": type == 0
            ? _selectedLatLng == null
            ? lat
            : _selectedLatLng!.latitude
            : _mobileVendorPosition!.latitude,
        "status":
        _statusCode == true ? _statusCodeInIntTrue : _statusCodeInIntFalse,
        "businesshours":
        "${_timeOpenController.text} to ${_timeCloseControllerTwo.text}",
        "bio": _bioController.text
      },
    );
    try {
      response = await _dio.post(path: AppUrls.addVendor, data: formData);

      var responseData = response.data;

      if (_loading) {
        _loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;

        if (resData['status'] == true) {
          var data = responseData['data'];
          if (data["status"] == _statusCodeInIntTrue) {
            setState(() {
              _statusCode = true;
            });
          } else if (data["status"] == _statusCodeInIntFalse) {
            setState(() {
              _statusCode = false;
            });
          }
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

      if (_loading) {
        progressDialog.dismiss();
        _loading = false;
      }

      MessageDialog(title: e.toString(), message: response["message"])
          .show(context);
    }
  }

//////////////////////////////////////////////////// Get Profile Vendor ////////////////////////////////

  _getVendorProfile(context) async {
    _loading = true;
    var response;

    try {
      response = await _dio.get(
        path: AppUrls.getVendorProfile,
      );

      var responseData = response.data;

      if (_loading) {
        _loading = false;
      }
      if (response.statusCode == StatusCode.OK) {
        var resData = responseData;

        if (resData['status'] == true) {
          var data = responseData['data']['vendorprofile']??null;
          if (data != null) {
            Prefs.getPrefs().then((prefs) async {
              prefs.setString(PrefKey.profile, data["profilepic"]);
            });

            if (data["type"] == 0) {
              _location = data["location"] ?? AppAssetsImages.appMap;
              long = data['longitude'] + 0.0;
              lat = data['latitude'] + 0.0;
              _bNameController.text = data["businessname"] ?? "";
              _addressController.text = data["address"] ?? "";
              _hashTagController.text = data["hashtags"] ?? "";
              profileImage = data["profilepic"] ?? "";
              type = data["type"] ?? "";
              _bioController.text = data["bio"] ?? "";
              List<String> hours = data["businesshours"].split(" to ");
              if (hours.isNotEmpty) {
                _timeOpenController.text = hours[0];
                _timeCloseControllerTwo.text = hours[1];
              }
              setState(() {});
            } else {
              profileImage = data["profilepic"] ?? "";
              type = data["type"] ?? "";
              _hashTagController.text = data["hashtags"] ?? "";
              _bNameController.text = data["businessname"] ?? "";
              _addressController.text = data["address"] ?? "";
              _bioController.text = data["bio"] ?? "";
              List<String> hours = data["businesshours"].split(" to ") ?? "";
              if (hours.isNotEmpty) {
                _timeOpenController.text = hours[0];
                _timeCloseControllerTwo.text = hours[1];
              }
              setState(() {});
            }
          }
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

      MessageDialog(
          title: e.toString().contains('SocketException')
              ? "Internet Error"
              : "Error",
          message: e.toString().contains('SocketException')
              ? 'No internet connection! Please check your internet connection'
              : 'Fill the required Data!')
          .show(context);
      setState(() { });
    }
  }

  void _getCurrentPosition() async {
    final finalLatlang = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _mobileVendorPosition = finalLatlang;
    });
  }
}
