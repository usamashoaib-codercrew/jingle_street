import 'package:clippy_flutter/triangle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class infoWindow extends StatelessWidget {
  final String businessName;
  final String businessHours;
  final String address;
  final String imageUrl;
  final String hashTags;
  final String location;
  final int type;
  final GestureTapCallback? onTap;
  infoWindow(
      {Key? key,
        this.imageUrl = "",
        this.businessName = "",
        this.address = "",
        this.hashTags = "",
        this.location = "", required this.type, this.onTap, this.businessHours ="",})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(onTap: onTap,
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(padding: EdgeInsets.only(left: 2.w,right: 2.w,top: 2.h,bottom: 2.h),
                decoration: BoxDecoration(
                  color: type ==0?Colors.blue:Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 18.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.fill),borderRadius: BorderRadius.circular(12),),
                    ),
                    Text("${businessName}",style: TextStyle(color: Colors.black,fontSize: 10.sp)),
                    Text("${hashTags}",style: TextStyle(color: Colors.black,fontSize: 10.sp)),
                    Text("${address}",style: TextStyle(color: Colors.black,fontSize: 10.sp)),
                    Text("${businessHours}",style: TextStyle(color: Colors.black,fontSize: 10.sp)),

                    // Text("${type==0?"":location}"),


                  ],
                )),
          ),
        ),

        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: type ==0?Colors.blue:Colors.green,
            width: 20.0,
            height: 10.0,
          ),
        ),
      ]),
    );
  }
}
