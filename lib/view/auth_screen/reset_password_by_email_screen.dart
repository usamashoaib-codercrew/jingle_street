import 'package:flutter/material.dart';
import 'package:jingle_street/config/functions/navigator_functions.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/popup.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import '../../resources/widgets/button/app_button.dart';
import '../../resources/widgets/others/custom_appbar.dart';

class SetPasswordByEmail extends StatefulWidget {
  SetPasswordByEmail({super.key});

  @override
  State<SetPasswordByEmail> createState() => _SetPasswordByEmailState();
}

class _SetPasswordByEmailState extends State<SetPasswordByEmail> {
  final CountryController = TextEditingController();

  final PhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ReusableAppBar(
        BackButton: true,
        ontap: () {
          pop();
        },
      ),
      backgroundColor: AppTheme.appColor,
      body: SafeArea(
          child: SingleChildScrollView(
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
              SizedBox(height: size.height * 0.01),
              AppText(
                "Set Password by email.",
                size: 16,
                color: Colors.white,
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                height:size.height*0.57,

           
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, right: 30, bottom: 130),
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    crossAxisAlignment: CrossAxisAlignment.start,
            
                    children: [
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         AppText("Email*", size: 15, color: AppTheme.appColor),
                      SizeBoxHeight8(),
                      MyAppField(
                        HintText: "Enter your email",
                        HintColor: AppTheme.appColor,
                        HintSize: 12.0,
                        controller: CountryController,
                        borderWidth: 1,
                        borderColor: AppTheme.appColor,
                        FocusBorderColor: AppTheme.appColor,
                        TextFieldWidth: size.width,
                        TextFieldHeight: 45.0,
                        TextColor: Colors.black,
                      ),
                      ],
                     ),
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
