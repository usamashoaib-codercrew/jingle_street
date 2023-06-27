import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:req_fun/req_fun.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late AppDio dio;
  bool loading = false;
  var resData;

  @override
  void initState() {
    dio = AppDio(context);
    getNOtifications();
    // TODO: implement initState
    super.initState();
  }

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
      body: resData == null
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.whiteColor),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: resData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:8.0, ),
                    child: Column(
                    
                      children: [
                        Container(
                          // color: Colors.black,
                          height: 70,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage("${resData[index]["image"]}"),
                                radius: 25,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    "${resData[index]["message"]}",
                                    ellipsis: true,
                                    size: 20,
                                    bold: FontWeight.w400,
                                  ),
                                  SizeBoxHeight10(),
                                   formatTimestampWidget(timestamp: resData[index]["updatedAt"]),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                            thickness: 1,
                            color: AppTheme.whiteColor,
                            indent: 10,
                            endIndent: 10),
                      ],
                    ),
                  );
                }),
          ),
    );
  }

  Future<void> getNOtifications() async {
    loading = true;
    var response;

    try {
      response = await dio.get(
        path: AppUrls.getNotify,
      );

      var responseData = response.data;

      if (loading) {
        loading = false;
      }

      if (response.statusCode == StatusCode.OK) {
        resData = responseData["data"];
        setState(() {});
        print("resData$resData");
      }
    } catch (e, s) {
      print(e);
      print(s);

      MessageDialog(title: e.toString(), message: response["message"])
          .show(context);
    }
  }
  Text formatTimestampWidget({required int timestamp}) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat('d MMM').format(dateTime);
  var formattedTime = DateFormat('h:mm a').format(dateTime);

  return Text(
    '$formattedDate at $formattedTime',
    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppTheme.whiteColor),
  );
}
}
