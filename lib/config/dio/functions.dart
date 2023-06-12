import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jingle_street/config/keys/response_code.dart';

responseError(BuildContext context, Response response) {
  if (StatusCode.isBadRequest(response.statusCode!)) {
    MessageDialog(
            title: 'Bad Request',
            message: "${response.data[ResponseAttrs.MESSAGE]}")
        .show(context);
  } else if (StatusCode.isServerError(response.statusCode!)) {
    MessageDialog(
            title: "${response.statusMessage}",
            message: "Status Code: ${response.statusCode}").show(context);
  } else {
    MessageDialog(
            title: "Error", message: "${response.data[ResponseAttrs.MESSAGE]}")
        .show(context);
  }
}
