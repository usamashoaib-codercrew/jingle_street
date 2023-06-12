import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final BorderRadius? borderRadius;
  final Color cursorColor;
  final Color borderSideColor;
  final Color hintColor;
  final Color textStyleColor;
  final String hintText;
  final double fontSize;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController textEditingController;
  final double widthSearchBar;

  const SearchField(
      {Key? key,
      this.borderRadius,
      this.borderSideColor = const Color(0xFFFF70000),
      this.hintColor = const Color(0xFFFF70000),
      required this.hintText,
      required this.textEditingController,
      this.fontSize = 12, required this.widthSearchBar, this.textStyleColor= const Color(0xFFFF70000), this.cursorColor = const Color(0xFFFF70000), this.onChange, this.onSubmitted,})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  double _searchField() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final minDimension = screenWidth < screenHeight ? screenWidth : screenHeight;
    if(minDimension>100 && minDimension<199)
    {return minDimension * 0.4;}
    else if (minDimension>200 && minDimension<299)
    {return minDimension *0.5;}
    else if (minDimension>300 && minDimension<399)
    {return minDimension *0.7;}
    else if(minDimension>400 && minDimension<439)
    {
      return minDimension *0.7;
    }
    else if(minDimension>440 && minDimension<460){
      return minDimension * 0.7;
    }
    else{
      return minDimension *0.6;
    }
    // Adjust this value to adjust the size of the marker
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(width:_searchField(),height: 40,
      child: TextField(
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChange,
        cursorColor: widget.cursorColor,
        style: TextStyle(color: widget.textStyleColor),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 1),
            isCollapsed: false,
          filled: true,
          fillColor: Colors.white,
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


            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFFFF70000),
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: width / 480 * widget.fontSize,
              color: Color(0xFFFF70000),
            )),
        controller: widget.textEditingController,
      ),
    );
  }
}