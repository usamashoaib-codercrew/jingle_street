import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';

reuseRow({txt, Function()? onPressed}) {
  return InkWell(
    onTap: onPressed,
    child: Row(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
              color: AppTheme.appColor, borderRadius: BorderRadius.circular(5)),
        ),
        SizeBoxWidth8(),
        AppText(
          txt,
          color: AppTheme.appColor,
          size: 16,
          bold: FontWeight.w400,
        ),
      ],
    ),
  );
}
