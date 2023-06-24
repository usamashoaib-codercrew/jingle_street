import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:req_fun/req_fun.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.appColor,
      appBar: SimpleAppBar1(
        text: "Notifications",
        onTap: () {
          pop(context);
        },
      ),
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/Mcdonald.png'),
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // AppText(
                          //   "Monika, is online!",
                          //   size: 20,
                          //   bold: FontWeight.w400,
                          //   color: AppTheme.whiteColor,
                          // ),
                          Text(
                            "Monika, is onlilkjfdlgldkfjgldkjflgjdlkfgjldjkflgkldjgflsldkjne!",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              color: AppTheme.whiteColor,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,

                          ),
                          AppText(
                            "28 Feb at 7:22 PM",
                            size: 12,
                            bold: FontWeight.w400,
                            color: AppTheme.whiteColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                    thickness: 1,
                    color: AppTheme.whiteColor,
                    indent: 30,
                    endIndent: 30),
              ],
            );
            //   ListTile(
            //   // minVerticalPadding: 0,
            //   // visualDensity: VisualDensity(horizontal: 0, vertical: 0),
            //   // dense: true,
            //   // contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
            //   leading: CircleAvatar(
            //     backgroundImage: AssetImage('assets/images/Mcdonald.png'),
            //     radius: 25,
            //   ),
            //   title: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       AppText(
            //         "Monika, how was our food?",
            //         size: 20,
            //         bold: FontWeight.w400,
            //         color: AppTheme.whiteColor,
            //       ),
            //       Row(
            //         children: [
            //           AppText(
            //             "Rate us",
            //             size: 20,
            //             bold: FontWeight.w400,
            //             color: AppTheme.whiteColor,
            //           ),
            //           SizedBox(width: 8),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(Icons.star, color: Colors.yellow),
            //               Icon(Icons.star, color: Colors.yellow),
            //               Icon(Icons.star, color: Colors.yellow),
            //               Icon(Icons.star, color: Colors.white),
            //               Icon(Icons.star, color: Colors.white),
            //             ],
            //           ),
            //         ],
            //       ),
            //       AppText(
            //         "28 Feb at 7:22 PM",
            //         size: 12,
            //         bold: FontWeight.w400,
            //         color: AppTheme.whiteColor,
            //       ),
            //       Divider(thickness: 1,color: AppTheme.whiteColor),
            //     ],
            //   ),
            // );
          }),
    );
  }
}
