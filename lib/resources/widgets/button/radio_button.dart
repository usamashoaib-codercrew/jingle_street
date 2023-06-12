import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';


class AppRadioButton extends StatelessWidget {
  final dynamic value;
  final Function(dynamic)? onChanged;
  final dynamic groupValue;
  final String text ;
  final double textWidth;
  final bool infoIcon;
  final Function()? infoOnPress;
  final bool enabled;

  const AppRadioButton({
    Key? key,
    required this.value,
    this.onChanged,
    required this.groupValue,
    this.text = "",
    this.textWidth = 0.8,
    this.infoIcon = false,
    this.infoOnPress,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        //here change to your color
        unselectedWidgetColor: Colors.white,
      ),
      child: Row(
        children: [
          Radio(
            toggleable: true,
            value: value,
            onChanged: onChanged,
            groupValue: groupValue,
            activeColor: AppTheme.appColor,
            fillColor: MaterialStatePropertyAll(AppTheme.appColor),

          ),
          Container(
            // width: MediaQuery.of(context).size.width * textWidth*0.9,
            child: AppText(
              text,
              color: AppTheme.appColor,
              size: 16,
              bold: FontWeight.w400,
            ),
          ),
          if (infoIcon == true) ...[
            IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.yellow,
              ),
              onPressed: () {
                infoOnPress!();
              },
            ),
          ]
        ],
      ),
    );
  }
}
