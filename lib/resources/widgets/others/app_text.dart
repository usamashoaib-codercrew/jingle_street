import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight bold;
  final Color? color;
  final bool justifyText;
  final bool alignText;
  final bool underline;
  final bool ellipsis;
  final Function()? onTap;

  const AppText(
    this.text, {
    Key? key,
    this.size = 18,
    this.bold = FontWeight.normal,
    this.color = Colors.white,
    this.justifyText = false,
    this.alignText = false,
    this.onTap,
    this.underline = false,
    this.ellipsis = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: onTap != null ? onTap : null,
      child: Text(
        text,
        textAlign: justifyText ? TextAlign.center : null,
        style: TextStyle(
          fontFamily: "Roboto Condensed",
          fontWeight: bold,
          overflow: ellipsis ? TextOverflow.ellipsis : null,
          color: color,
          fontSize: textScaleFactor * size,
          decoration: underline ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}

class AppBarText extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool isSelected;

  const AppBarText(
      {Key? key, required this.text, this.onTap, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Container(
          height: 40,
          width: 60,
          child: Center(
              child: AppText(text,
                  color: Colors.white, size: 11, alignText: true)),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  width: 1)),
        ),
      ),
    );
  }
}

class AppTextWithInfoIcon extends StatelessWidget {
  final String text;
  final double size;
  final bool bold;
  final Color color;
  final Widget infoIcon;

  const AppTextWithInfoIcon(
    this.text, {
    Key? key,
    this.size = 18,
    this.bold = false,
    required this.color,
    required this.infoIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: size,
            ),
          ),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: infoIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class RequiredText extends StatelessWidget {
  final String labelText;
  final TextDecoration? textDecoration;
  final String requiredSign;
  final double labelTextScale;
  final int labelMaxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final Color labelColor;
  final Color? textSpanColor;
  final GestureTapCallback? onTap;

//  final FontWeight fontWeight;
  final double fontSize;

  const RequiredText(
    this.labelText, {
    Key? key,
    this.requiredSign = ' *',
    this.labelColor = Colors.black54,
    // this.fontWeight,
    required this.fontSize,
    this.labelMaxLines = 1,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.labelTextScale = 1.0,
    this.textDecoration,
    this.textSpanColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: RichText(
          text: TextSpan(
              text: labelText,
              style: TextStyle(
                color: labelColor,
                fontSize: fontSize,
              ),
              children: [
                TextSpan(
                    text: requiredSign,
                    style: TextStyle(
                        decoration: textDecoration,
                        color: textSpanColor,
                        //  fontWeight: fontWeight,
                        fontSize: fontSize))
              ]),
          textScaleFactor: labelTextScale,
          maxLines: labelMaxLines,
          overflow: overflow,
          textAlign: textAlign,
        ),
      ),
    );
  }
}

Widget CustomRow(
    {required text,
    color,
    size,
    fontsize,
    iconcolor,
    fontweight,
    fontfamily,
    icon,
    ontap,
    SizedBox,
    CircleAvatar}) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25),
    child: Row(
      children: [
        CircleAvatar,
        SizedBox,
        Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: fontsize,
              fontWeight: fontweight,
              fontFamily: fontfamily),
        ),
        Spacer(),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppTheme.appColor,
              )),
          child: InkWell(
              onTap: ontap,
              child: Icon(
                icon,
                color: iconcolor,
                size: size,
              )),
        ),
      ],
    ),
  );
}

Widget RowText(
    {required text,
    color,
    size,
    fontsize,
    fontweight,
    fontfamily,
    required text1,
    color1,
    size1,
    fontsize1,
    fontweight1,
    fontfamily1}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: TextStyle(
            color: color,
            fontSize: fontsize,
            fontWeight: fontweight,
            fontFamily: fontfamily),
      ),
      Text(
        text1,
        style: TextStyle(
            color: color1,
            fontSize: fontsize1,
            fontWeight: fontweight1,
            fontFamily: fontfamily1),
      ),
    ],
  );
}
