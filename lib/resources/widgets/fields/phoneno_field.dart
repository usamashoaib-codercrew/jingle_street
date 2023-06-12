import 'package:flutter/material.dart';




  


txtField(txt){

  return   TextField(
    decoration: InputDecoration(

      hintText: txt,
      hintStyle: TextStyle(color: Color.fromRGBO(247, 0, 0, 0.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffF70000), width: 2)),
      disabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffF70000), width: 1)) ,
      enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Color(0xffF70000), width: 1)),

    ),
  );

}