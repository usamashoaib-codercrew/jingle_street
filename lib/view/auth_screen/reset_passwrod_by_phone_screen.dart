import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import '../../resources/widgets/button/app_button.dart';
import '../../resources/widgets/others/custom_appbar.dart';


class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final CountryController = TextEditingController();
  final PhoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
    appBar: ReusableAppBar(BackButton:false),
      backgroundColor: AppTheme.appColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: size.height * 0.05),
              AppText(
                "Reset Password",
                bold: FontWeight.bold,
                size: 24,
              ),
              SizeBoxHeight8(),
              AppText(
                "Set your new Password.",
                size: 15,
                color: Colors.white,
              ),
              SizeBoxHeight8(),
             
              Container(
             
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, right: 30, bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText("Password*", size: 15, color: AppTheme.appColor),
                                   SizeBoxHeight4(),

                      MyAppField(
                        HintText: "Enter password",
                        HintColor: AppTheme.appColor,
                        HintSize: 12.0,
                        controller: CountryController,
                        borderWidth: 1.0,
                        borderColor: AppTheme.appColor,
                        FocusBorderColor: AppTheme.appColor,
                        TextFieldWidth: size.width,
                        TextFieldHeight: 45.0,
                        TextColor: Colors.black,
                      ),
                                    SizeBoxHeight8(),

                      AppText("Re-enter password*", size: 12, color: AppTheme.appColor),
                                   SizeBoxHeight4(),

                      MyAppField(
                        HintText: "Confirm password",
                        HintColor: AppTheme.appColor,
                        HintSize: 12.0,
                        controller: PhoneNumberController,
                        borderWidth: 1.0,
                        borderColor: AppTheme.appColor,
                        FocusBorderColor: AppTheme.appColor,
                        TextFieldWidth: size.width,
                        TextFieldHeight: 45.0,
                        TextColor: Colors.black,
                      ),
                      SizedBox(height: size.height * 0.08),
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
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
      )),
    );
  }
}
