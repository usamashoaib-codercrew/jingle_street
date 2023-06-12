import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Color? textStyleColor;
  final String? labelText;
  final String? hintText;
  final String? functionValidate;
  final String? parametersValidate;
  final double fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color borderSideColor;
  final Color? hintTextColor;
  final IconData? prefixicon;
  final IconData? visibilityIcon;
  final IconData? visibilityOffIcon;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color fillColor;
  bool obscureText;
  final FocusNode? focusNode;
  final String? Function(String?)? onSaved;
  final String? initialValue;
  final List<FilteringTextInputFormatter>? inputFormattersList;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool decoration;
  final bool? showCursor;
  final bool autocorrect;
  final IconData? prefixIcon;
  final bool maxLengthEnforced;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final double? HintSize;
  final suffixIcon;

  
  AppField({
    Key? key,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.decoration = true,
    this.onSaved,
    this.prefixIcon,
    this.inputFormattersList,
    required this.textEditingController,
    this.textStyleColor,
    this.labelText,
    this.hintText,
    this.functionValidate,
    this.parametersValidate,
    this.fontSize = 15,
    this.fontStyle,
    this.fontWeight,
    this.borderRadius,
    this.borderSide,
    this.prefixicon,
    this.visibilityIcon,
    this.HintSize,
    this.suffixIcon,
    this.visibilityOffIcon,
    this.textInputType,
    this.borderSideColor = Colors.black,
    this.fillColor = Colors.red,
    this.hintTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return TextFormField(
    
      
        key: key,
        controller: textEditingController,
        initialValue: initialValue,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        style: TextStyle(color: textStyleColor),
        textDirection: textDirection,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        autofocus: autofocus,
        onSaved: onSaved,
        readOnly: readOnly,
        showCursor: showCursor,
        obscureText: obscureText,
        autocorrect: autocorrect,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
      
        onChanged: onChanged,
        onTap: onTap,
        inputFormatters: inputFormattersList,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        decoration: InputDecoration(
          counterText: "",
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(fontSize: textScaleFactor * fontSize,color: hintTextColor),
          fillColor: fillColor,
          isDense: true,
          border: OutlineInputBorder(borderRadius: borderRadius??BorderRadius.zero,borderSide: BorderSide(width: 1,color: borderSideColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius??BorderRadius.zero,
              borderSide: BorderSide(color: borderSideColor,width: 1)),
          disabledBorder:
              OutlineInputBorder(
                  borderSide: BorderSide(color: borderSideColor, width: 1)),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius?? BorderRadius.zero,
              borderSide: BorderSide(color: borderSideColor, width: 1)),
          labelStyle: TextStyle(
              fontSize: 14, color: textStyleColor),
        ));
  }
}





class MyAppField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? Function(String?)? onSaved;
  final String? initialValue;
  final String? label;
  final List<FilteringTextInputFormatter>? inputFormattersList;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final isEnable;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool decoration;
  final bool? showCursor;
  final bool obscureText;
  final bool autocorrect;
  final IconData? prefixIcon;
  final bool maxLengthEnforced;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final borderWidth;
  final  borderColor;
  final  FocusBorderColor;
  final  TextFieldHeight;
  final TextFieldWidth;
  final TextColor;
  final HintText;
  final HintColor;
  final HintSize;

  MyAppField({
    Key? key,
    required this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.isEnable = true,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.decoration = true,
    this.label,
    this.onSaved,
    this.borderWidth,
    this.prefixIcon,
    this.inputFormattersList,
     this.borderColor,
     this.FocusBorderColor,
    this.TextFieldHeight,
    this.TextFieldWidth,
    this.TextColor,
    this.HintText,
    this.HintColor,
    this.HintSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TextFieldHeight,
      width: TextFieldWidth,
      child: TextFormField(
          key: key,
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          style: TextStyle(color: TextColor),
          textDirection: textDirection,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          autofocus: autofocus,
          onSaved: onSaved,
          readOnly: readOnly,
          showCursor: showCursor,
          obscureText: obscureText,
          autocorrect: autocorrect,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onTap: onTap,
          inputFormatters: inputFormattersList,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          enabled: isEnable,
          decoration: InputDecoration(
            hintText: HintText,
            hintStyle: TextStyle(color: HintColor, fontSize: HintSize),
            labelText: label,
            fillColor: isEnable == false ? Colors.black26 : Colors.black,
            isDense: true,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FocusBorderColor)),
            disabledBorder: !isEnable ? OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!, width: 1)) : null ,
            enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(5)
            ),
            labelStyle: TextStyle(fontSize: 14, color: isEnable ? Colors.white : Colors.grey[400]),
          )),
    );
  }
}

