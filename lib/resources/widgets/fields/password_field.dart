import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final Color? visibilityColor;
  final String? label;
  final double fontSize;
  final Color? textStyleColor;
  final Color? labelColor;
  final Color? hintColor;
  final String? hintText;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color borderSideColor;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextInputType? keyboardType;
  final InputDecoration decoration;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final List<FilteringTextInputFormatter>? inputFormattersList;

  AppPasswordField({
    Key? key,
    required this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
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
    this.label,
    this.keyboardType,
    this.inputFormattersList,
    this.labelColor,
    this.hintText,
    this.hintColor,
    this.borderRadius,
    this.borderSide,
    this.borderSideColor = Colors.black, this.fillColor = Colors.black, this.textStyleColor, this.visibilityColor, this.fontSize= 12,
  });

  @override
  _AppPasswordFieldState createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return TextFormField(
      key: widget.key,
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      style: TextStyle(color: widget.textStyleColor),
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      obscureText: _obscureText,
      autocorrect: widget.autocorrect,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormattersList,
      validator: widget.validator,
      
      decoration: InputDecoration(
        
        labelText: widget.label,
        hintText: widget.hintText,
        isDense: true,
        fillColor: widget.fillColor,
        hintStyle: TextStyle(
          fontSize: textScaleFactor* widget.fontSize,
          color: widget.hintColor,
        ),
        border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(width: 1, color: widget.borderSideColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(color: widget.borderSideColor, width: 1)),
        disabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(color: widget.borderSideColor, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(color: widget.borderSideColor, width: 1)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off: Icons.visibility,
            color: widget.visibilityColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
