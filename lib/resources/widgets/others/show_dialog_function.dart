import 'package:flutter/material.dart';
class ShowDialogFunction extends StatelessWidget {
  final String error;
  ShowDialogFunction({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SimpleDialog(
      title: Text("error"),
      children: [
        Text("${error}"),
      ],
    );
  }
}
