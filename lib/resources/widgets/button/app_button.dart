import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';

import '../others/app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final double width;
  final double height;
  final Color? btnColor;
  final bool disabled;
  final double textSize;
  final double borderRadius;
  final bool isBorder;
  final Color? textColor;
  final fontweight;


  static Color PrimaryColorVariant = Color(0xFF1565C0);

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    required this.width,
    this.disabled = false,
    this.btnColor,
    this.fontweight,
    this.textSize = 24.0,
    this.borderRadius = 10,
    this.height = 40.0,  this.isBorder = true, this.textColor,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScalingFactor = MediaQuery.of(context).textScaleFactor;
    final widthScreen = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        if (!disabled && onPressed != null) onPressed!();
      },
      child: Container(
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.green.withOpacity(0.5),
          //     spreadRadius: 1,
          //     blurRadius: 1,
          //     offset: Offset(0, 1), // changes position of shadow
          //   ),
          // ],
          border: isBorder ? Border.all(color: disabled ? AppTheme.appColor  :AppTheme.appColor) : null,
          borderRadius: BorderRadius.circular(borderRadius),
          color: disabled
              ? AppTheme.appColor
              : btnColor == null
              ? Colors.black
              : btnColor,
        ),
        height: height,
        width: (width/widthScreen) *widthScreen,

        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: FittedBox(fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: textScalingFactor* textSize, color: textColor, fontWeight: fontweight),
            ),
          ),
        ),
      ),
    );
  }
}




Widget JingleStreetButton({OnPressed, text}){
  return MaterialButton(onPressed: OnPressed,
  child: Container(height: 50, width: 150,
  child: Center(child: AppText(text,color: Colors.white,)),
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
  color: AppTheme.error,
  ),
  ),
  );
}