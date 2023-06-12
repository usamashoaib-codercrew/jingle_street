import 'package:flutter/material.dart';
import '../../res/app_theme.dart';
import '../others/app_text.dart';
showAlertDeleteDialog(BuildContext context, onTap) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: AppText("Cancel", color: AppTheme.appColor,),
    onPressed:  () {Navigator.pop(context);},
  );
  Widget continueButton = TextButton(
    child: AppText("Delete",color: AppTheme.appColor),
    onPressed:  onTap,
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete"),
    content: Text("Are you sure you want to delete this item?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}