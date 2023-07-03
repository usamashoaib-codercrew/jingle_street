import 'package:flutter/material.dart';
import 'package:jingle_street/config/keys/pref_keys.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/auth_screen/login_screen.dart';
import 'package:jingle_street/view/customer_screen/customer_profile_edit_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/contact_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/help_screen.dart';
import 'package:jingle_street/view/vendor_screen/vendor_profile_screen.dart';
import 'package:req_fun/req_fun.dart';

class SettingScreen extends StatefulWidget {
  final int? type;
  final String? name;
  const SettingScreen({super.key, this.type, this.name});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppTheme.appColor,
        appBar: SimpleAppBar1(
          text: "Settings",
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
                height: 330,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              if(widget.type == 1){
                                push(VendorProfile());
                              } else {
                                push(CustomerProfileEdit());
                              }

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  "Profile",
                                  size: 16,
                                  bold: FontWeight.w700,
                                  color: AppTheme.appColor,
                                ),
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: AppTheme.appColor,
                                  size: 22,
                                )
                              ],
                            )),
                        SizeBoxHeight3(),
                        Container(
                            color: AppTheme.appColor,
                            height: 1,
                            width: size.width),
                        SizeBoxHeight10(),
                        InkWell(
                          onTap: () {
                            push(HelpScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                "Help",
                                size: 16,
                                bold: FontWeight.w700,
                                color: AppTheme.appColor,
                              ),
                              Icon(
                                Icons.help_outline,
                                size: 22,
                                color: AppTheme.appColor,
                              )
                            ],
                          ),
                        ),
                        SizeBoxHeight3(),
                        Container(
                            color: AppTheme.appColor,
                            height: 1,
                            width: size.width),
                        SizeBoxHeight10(),
                        InkWell(
                          onTap: () {
                            push(ContactScreen());
                          },
                          child: Row(
                            children: [
                              AppText(
                                "Contact us",
                                size: 16,
                                bold: FontWeight.w700,
                                color: AppTheme.appColor,
                              ),
                            ],
                          ),
                        ),
                        SizeBoxHeight3(),
                        Container(
                            color: AppTheme.appColor,
                            height: 1,
                            width: size.width),
                        SizeBoxHeight10(),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    contentPadding: EdgeInsets.zero,
                                    backgroundColor: AppTheme.appColor,
                                    children: [
                                      SizeBoxHeight12(),
                                      Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "Are you sure, you want\n\n          to",
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .whiteColor)),
                                                TextSpan(
                                                    text: " Log out?",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .whiteColor))
                                              ],
                                            ),
                                          ),
                                          SizeBoxHeight32(),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                              top: BorderSide(
                                                  width: 2,
                                                  color: AppTheme.whiteColor),
                                            )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await logoutUser();
                                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                                    replace(LoginScreen());
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 150/size.width*150,
                                                    child: Center(
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .whiteColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 3,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                    right: BorderSide(
                                                        width: 2,
                                                        color: AppTheme
                                                            .whiteColor),
                                                  )),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    pop(context);
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 150/size.width* 150,
                                                    child: Center(
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppTheme
                                                                .whiteColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                "Logout",
                                size: 16,
                                bold: FontWeight.w700,
                                color: AppTheme.appColor,
                              ),
                              Icon(
                                size: 22,
                                Icons.logout,
                                color: AppTheme.appColor,
                              )
                            ],
                          ),
                        )
                      ]),
                ))));
  }

  logoutUser() async {
    await Prefs.remove(PrefKey.authorization);
    await Prefs.remove(PrefKey.id);
    await Prefs.remove(PrefKey.verified);
    await Prefs.remove(PrefKey.profile);
    await Prefs.remove(PrefKey.fcm_token);

  }
}
