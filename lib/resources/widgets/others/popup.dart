import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/resources/widgets/others/row.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:jingle_street/view/vendor_screen/add_items_screen.dart';

buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    backgroundColor: AppTheme.appColor,
    content: Container(
      width: MediaQuery.of(context).size.width,
      height: 390,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppText(
                  "Categories:",
                  color: AppTheme.appColor,
                  size: 20,
                  bold: FontWeight.w700,
                ),
                SizedBox(
                  height: 25,
                ),
                reuseRow(
                    txt: "Burgers",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddItemsScreen( "Burger", ),
                          ));
                    }),
                SizeBoxHeight12(),
                reuseRow(
                    txt: "Pizza",
                  
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddItemsScreen( "Pizza", ),
                          ));
                    }),
                SizeBoxHeight12(),
                
                reuseRow(
                    txt: "Sandwiches",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddItemsScreen( "Sandwich",),
                          ));
                    }),
                SizeBoxHeight12(),
      
                reuseRow(
                    txt: "Fries",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  AddItemsScreen( "Fries", ))));
                    }),
                SizeBoxHeight12(),
                reuseRow(
                    txt: "Sauces",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  AddItemsScreen( "Sauce", ))));
                    }),
                SizeBoxHeight12(),
                reuseRow(
                    txt: "Desserts",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  AddItemsScreen( "Desert",))));
                    }),
                SizeBoxHeight12(),
                reuseRow(
                    txt: "Soft Drinks",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AddItemsScreen(
                                 "Soft Drinks",))));
                    }),
                SizeBoxHeight12(),
                reuseRow(txt: "Others",
                onPressed: () {
                  Navigator.pop(context);
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddItemsScreen( "Product"),
                          ));
                },
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// buildOtpDialog(BuildContext context, time) {
//   return new AlertDialog(
//     contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 10),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//     content: Container(
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: new Column(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("assets/images/mob.png"))),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             AppText(
//               "OTP Verification",
//               color: AppTheme.appColor,
//               bold: FontWeight.w400,
//               size: 24,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             AppText(
//               "Enter OTP code send to ....",
//               color: AppTheme.appColor,
//               bold: FontWeight.w400,
//               size: 18,
//             ),
//             SizedBox(
//               height: 30,
//             ),

//             OtpTextField(
//               // margin: EdgeInsets.all(3),
//               textStyle: TextStyle(fontSize: 18),

//               numberOfFields: 6,
//               showFieldAsBox: true,
//               fieldWidth: 34,
//               // enabled: false
//               // ,
//               hasCustomInputDecoration: true,

//               cursorColor: AppTheme.appColor,

//               decoration: InputDecoration(
//                   counterText: "",
//                   isDense: true,
//                   contentPadding: EdgeInsets.all(10),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           BorderSide(color: AppTheme.appColor, width: 1)),
//                   disabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           BorderSide(color: AppTheme.appColor, width: 1)),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           BorderSide(color: AppTheme.appColor, width: 1)),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppTheme.appColor),
//                     borderRadius: BorderRadius.circular(10),
//                   )),
//             ),
//             SizeBoxHeight16(),

//             AppText(
//               "Didn't receive OTP code",
//               color: AppTheme.appColor,
//               bold: FontWeight.w400,
//               size: 18,
//               onTap: () {},
//             ),
//             // SizedBox(
//             //   height: 5,
//             // ),
//             Row(
//               children: [
//                 TextButton(
//                     onPressed: () {},
//                     child: AppText(
//                       "Resend Code",
//                       color: AppTheme.appColor,
//                       underline: true,
//                     )),
//                 AppText(
//                   "$time sec",
//                   color: AppTheme.appColor,
//                   size: 17,
//                   bold: FontWeight.w300,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 100,
//             ),
//             AppButton(
//               text: "Verify & Proceed",
//               width: 150,
//               textColor: AppTheme.whiteColor,
//               btnColor: AppTheme.appColor,
//               textSize: 16,
//               onPressed: () {},
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
