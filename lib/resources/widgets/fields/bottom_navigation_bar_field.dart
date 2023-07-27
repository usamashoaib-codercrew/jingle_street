import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/view/home_screen/google_map_screen.dart';
import 'package:jingle_street/view/home_screen/notification_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/setting_screen.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationBarField extends StatefulWidget {
  final List<Widget> bodyList;
  final int notifyCount;
  final int currentState;
  final  Function(int)? onTap;

  // final List<BottomNavigationBarItem> items;

//  final List<IconData> iconData;

  const BottomNavigationBarField({
    Key? key,
    required this.bodyList,  this.notifyCount =0,this. onTap,this.currentState=0
    //  required this.iconData
  }) : super(key: key);

  @override
  State<BottomNavigationBarField> createState() =>
      _BottomNavigationBarFieldState();
}

class _BottomNavigationBarFieldState extends State<BottomNavigationBarField> {


 // _BottomNavigationBarFieldState(this.notifyCount);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  // void _navOnTapped(int currentindex) {
  //   _currentState = currentindex;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          height: 8.1.h,
          itemCount: 3,
          tabBuilder: (index, isActive) {
            return index == 0
                ? Icon(Icons.home,color: isActive? AppTheme.appColor:Colors.red.shade200,)
                : (index == 1
                ? Padding(
              padding: EdgeInsets.only(left: 13.2.w,top: 2.2.h),
              child: Stack(
                children: [
                  Icon(Icons.notifications,color: isActive? AppTheme.appColor:Colors.red.shade200,),
                  Positioned(
                    left: 5.w,
                    bottom: 4.1.h,
                    child: Visibility(
                      visible: widget.notifyCount==0? false:true,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration:  BoxDecoration(
                          color: isActive? AppTheme.appColor:Colors.red.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child:  Text(
                          '${widget.notifyCount}',
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )

                    ,
                  )
                ],
              ),
            )
                : Icon(Icons.settings,color: isActive? AppTheme.appColor:Colors.red.shade200,));
            // Icon(
            //     index == 0 ? Icons.home : (index == 1 ? Icons.search : Icons.person),
            //     color: Colors.blue,
            //   );
          },

          // inactiveColor:Color(0xffC0C0C0),
          // activeColor: AppTheme.appColor,
          borderColor: Colors.red,
          gapLocation: GapLocation.none,
          leftCornerRadius: 32,
          rightCornerRadius: 32,

          // icons: widget.iconData,
          activeIndex: widget.currentState,
          onTap: widget.onTap!,),
      body: widget.bodyList.elementAt(widget.currentState),
    );
    // return Scaffold(
    //     body: widget.bodyList.elementAt(_currentState),
    //     bottomNavigationBar: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.only(
    //             topRight: Radius.circular(30), topLeft: Radius.circular(30)),
    //         boxShadow: [
    //           BoxShadow(
    //               color: AppTheme.appColor, spreadRadius: 1.2, blurRadius: 1),
    //         ],
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(30.0),
    //           topRight: Radius.circular(30.0),
    //         ),
    //         child: BottomNavigationBar(
    //
    //           items: widget.items,
    //           currentIndex: _currentState,
    //           onTap: _navOnTapped,
    //           unselectedItemColor: AppTheme.appColor,
    //           selectedItemColor: AppTheme.appColor,
    //           iconSize: 30,
    //           type: BottomNavigationBarType.fixed,
    //         ),
    //       ),
    //     ));
  }
}
