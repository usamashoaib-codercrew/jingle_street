import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppDateTimePicker {
  static getTime() {
    var _getTime = "";
    _getTime = DateFormat.jm().format(DateTime.now());
    return _getTime;
  }

  static Future getDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    var _getDate = "";

    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, initialDatePickerMode: DatePickerMode.day, firstDate: DateTime(2015), lastDate: DateTime(2101));

    if (picked != null) {
      selectedDate = picked;
      _getDate = DateFormat.yMd().format(selectedDate);
    }

    return _getDate;
  }
}
