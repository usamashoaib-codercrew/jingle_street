import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

cupertinoDatePicker(
    BuildContext context, {
      required Function(DateTime, String, String) onSubmit,
      Function? onCancel,
      initialDate,
      minDate,
      maxDate,
      sqlFormat = DateFormats.SQL_DATE_FORMAT,
      userFormat = "dd/MM/yyyy",
      closeOnBackPress: true,
      double height: 350,
    }) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: closeOnBackPress,
    barrierLabel: "",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (c2, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );
    },
    pageBuilder: (c1, a1, a2) {
      DateTime dateTime = DateTime.now();
      String sqlDateValue = dateTime.format(sqlFormat);
      String userDateValue = dateTime.format(userFormat);

      return WillPopScope(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 60.0,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: height,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: initialDate ?? DateTime.now(),
                    maximumDate: maxDate,
                    minimumDate: minDate,
                    onDateTimeChanged: (DateTime newDateTime) {
                      dateTime = newDateTime;
                      sqlDateValue = newDateTime.format(sqlFormat);
                      userDateValue = newDateTime.format(userFormat);
                    },
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onCancel != null) {
                            onCancel();
                          }
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          if (onSubmit != null) onSubmit(dateTime, sqlDateValue, userDateValue);
                        },
                        child: Text("Done")),
                  ],
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => closeOnBackPress,
      );
    },
  );
}
