
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';


infoIconButton({required Function()? onTap}) {
  return SizedBox(
    width: 18,
    height: 18,
    child: IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.info,
        size: 18,
        color: Colors.yellow.shade600,
      ),
      onPressed: onTap,
    ),
  );
}

radioGroupYesNoWidget(
    {
      fTin=false,
      String title = "",
      textSize = 14.0,
      textColor = Colors.white,
      firstText = "Yes",
      secondText = "No",
      groupValue = 100,
      firstValue = 101,
      secondValue = 102,
      required Function(int) onChange,
      void Function()? onIconTap}) {
  return Container(
    child: Column(
      children: [
        (!fTin)?Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: RequiredText(title,
                  labelMaxLines: 4,
                  labelColor: Colors.black, fontSize: 14,
                )),
          ],
        ):SizedBox(),
        Row(
          children: [
            RadioButton<int>(
              text: firstText,
              value: firstValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth8(),
            RadioButton<int>(
              text: secondText,
              value: secondValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
          ],
        ),
      ],
    ),
  );
}

radioGroup3ValuesWidget(
    {required String title,
      textSize = 14.0,
      textColor = Colors.black,
      firstText = "Yes",
      secondText = "No",
      thirdText = "Don't Know",
      groupValue = 100,
      firstValue = 101,
      secondValue = 102,
      thirdValue = 103,
      required Function(int) onChange,
      required void Function()? onIconTap}) {
  return Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: AppTextWithInfoIcon(title,
                      size: textSize,
                      color: textColor,
                      infoIcon: infoIconButton(onTap: onIconTap))),
            ],
          ),
        ),
        Row(
          children: [
            RadioButton<int>(
              text: firstText,
              value: firstValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: secondText,
              value: secondValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: thirdText,
              value: thirdValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
          ],
        ),
      ],
    ),
  );
}


radioGroup5ValuesWidget(
    {required String title,
      textSize = 14.0,
      textColor = Colors.black,
      firstText = "",
      secondText = "",
      thirdText = "",
      fourText = "",
      fiveText = "",
      groupValue = 100,
      firstValue = 101,
      secondValue = 102,
      thirdValue = 103,
      fourValue = 104,
      fiveValue = 105,
      required Function(int) onChange,
      Function()? onIconTap}) {
  return Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: AppText(title,
                    size: textSize,
                    color: textColor,
                    // infoIcon: infoIconButton(onTap: onIconTap)
                  )),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioButton<int>(
              text: firstText,
              value: firstValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: secondText,
              value: secondValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: thirdText,
              value: thirdValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: fourText,
              value: fourValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: fiveText,
              value: fiveValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
          ],
        ),
      ],
    ),
  );
}



radioGroup3ValuesWidgetVert(
    {required String title,
      textSize = 14.0,
      textColor = Colors.black,
      firstText = "Yes",
      secondText = "No",
      thirdText = "Don't Know",
      groupValue = 100,
      firstValue = 101,
      secondValue = 102,
      thirdValue = 103,
      required Function(int) onChange,
      required void Function()? onIconTap})
{
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child:
            AppText(title,size: textSize,
              color: textColor, )
          // Row(
          //
          //   children: [
          //     Flexible(
          //         child: AppTextWithInfoIcon(title,
          //             size: textSize,
          //             color: textColor,
          //             infoIcon: infoIconButton(onTap: onIconTap))),
          //   ],
          // ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioButton<int>(
              text: firstText,
              value: firstValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: secondText,
              value: secondValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
            SizeBoxWidth16(),
            RadioButton<int>(
              text: thirdText,
              value: thirdValue,
              onChanged: (value) {
                onChange(value!);
              },
              groupValue: groupValue,
            ),
          ],
        ),
      ],
    ),
  );
}


class RadioButton<T> extends StatelessWidget {
  final T? value;
  final T? groupValue;
  final String text;
  final Function(T?) onChanged;

  const RadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: 20, height: 20, child: Radio<T?>(
                value: value,
                groupValue: groupValue,
                fillColor: (groupValue==null)?MaterialStateProperty.all<Color>(Colors.grey):MaterialStateProperty.all<Color>(Colors.green),
                /*overlayColor: MaterialStateProperty.all<Color>(Colors.white),*/
                //  onChanged: groupValue == null ? (value){ return null;} : onChanged)),
                onChanged: onChanged)),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                onChanged(value!);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}