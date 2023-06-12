import 'package:flutter/material.dart';

class AppDatePicker {
  static getTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    TimeOfDay _getDate = TimeOfDay.now();
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      selectedTime = timeOfDay;
      _getDate = selectedTime;
    }

    return _getDate;
  }

  static Future getDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    DateTime _getDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      selectedDate = picked;
      _getDate = selectedDate;
    }

    return _getDate;
  }
}
