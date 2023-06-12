import 'package:flutter/material.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';

class Dialogs {
  static infoDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(msg, style: TextStyle()),
        //  title: Icon(Icons.info_outline, color: Colors.yellow[800], size: 60),
          actions: <Widget>[
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: MaterialButton(
                      //       color: Colors.red,
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(4.0),
                      //         child: Text(
                      //           "OK",
                      //           style: TextStyle(color: Colors.white, fontSize: 18),
                      //         ),
                      //       ),
                      //       onPressed: () {
                      //         Navigator.pop(context);
                      //       }),
                      // ),
                    ],
                  )),
            )
          ],
        );
      },
    );
  }

  static appDialog(BuildContext context, {required String title, required String description,  Function? onYesTap}){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900]!,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          title: AppText('$title'),
          content: Text('$description', style: TextStyle(color: Colors.white), textAlign: TextAlign.justify),
          actions: <Widget>[
            MaterialButton(
              child: Text('No', style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
            MaterialButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              onPressed: onYesTap != null ? onYesTap() : (){}
            )
          ],
        );
      },
    );
  }
}