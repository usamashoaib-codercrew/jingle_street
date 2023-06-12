import 'package:flutter/material.dart';


class AppCheckBox extends StatelessWidget {
  final bool value;
  final Color? checkColor;
  final Color? hoverColor;
  final Color? activeColor;
  final double borderSidewidth;
  final Color? focusColor;
  final Color? borderSideColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Function(bool?) onChanged;

  const AppCheckBox({
    Key? key,
    required this.value,
    required this.onChanged, this.checkColor, this.fillColor, this.focusColor, this.borderSideColor, this.borderSidewidth = 1, this.activeColor, this.hoverColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 20,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.5, color: Colors.red),
                left: BorderSide(width: 1.5, color: Colors.red),
                right: BorderSide(width: 1.5, color: Colors.red),
                bottom: BorderSide(width: 1.5, color: Colors.red),
              ),
            ),
            child: Checkbox(

              side: BorderSide(

              width: borderSidewidth,
                  color: borderSideColor!
              ),

              activeColor: activeColor,
              focusColor: focusColor,
              fillColor: fillColor,
              hoverColor: hoverColor,
              value: value,
              checkColor: checkColor,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// class AppCheckBox extends StatelessWidget {
//   final bool value;
//   final String text;
//   final Function(bool?) onChanged;
//   final Function()? onTap;
//
//   const AppCheckBox({
//     Key? key,
//     required this.value,
//     required this.text,
//     required this.onChanged,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           child: Row(
//             //   mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: Checkbox(
//                       value: value,
//                       onChanged: onChanged,
//                       checkColor: Colors.white,
//                     )),
//               ),
//               Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   child: AppText(
//                     text,
//                     color: Colors.white,
//                     size: 14,
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





