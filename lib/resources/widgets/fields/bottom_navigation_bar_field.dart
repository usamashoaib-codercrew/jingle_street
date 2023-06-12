import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';

class BottomNavigationBarField extends StatefulWidget {
  final List<Widget> bodyList;

  // final List<BottomNavigationBarItem> items;

  final List<IconData> iconData;

  const BottomNavigationBarField(
      {Key? key, required this.bodyList, required this.iconData})
      : super(key: key);

  @override
  State<BottomNavigationBarField> createState() =>
      _BottomNavigationBarFieldState();
}

class _BottomNavigationBarFieldState extends State<BottomNavigationBarField> {
  int _currentState = 0;

  void _navOnTapped(int currentindex) {
    _currentState = currentindex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor:Color(0xffC0C0C0),
        activeColor: AppTheme.appColor,
        borderColor: Colors.red,
          gapLocation: GapLocation.none,
        leftCornerRadius: 32,rightCornerRadius: 32,
          icons: widget.iconData,
          activeIndex: _currentState,
          onTap: _navOnTapped),
      body: widget.bodyList.elementAt(_currentState),
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
