import 'package:flutter/material.dart';
class AppTile extends StatelessWidget {
  final Widget child;
  const AppTile({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      child:child,
    );
  }
}
