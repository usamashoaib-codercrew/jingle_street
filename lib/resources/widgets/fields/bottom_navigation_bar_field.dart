import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/view/home_screen/google_map_screen.dart';
import 'package:jingle_street/view/home_screen/notification_screen.dart';
import 'package:jingle_street/view/home_screen/setting_screen/setting_screen.dart';

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

  // void _navOnTapped(int currentindex) {
  //   _currentState = currentindex;
  //   setState(() {});
  // }
  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GoogleMapScreen()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettingScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      itemCount: 3,
      tabBuilder: (index, isActive) {
         return index == 0? Icon(Icons.home):(index ==1 ? Stack(
    children: <Widget>[
      new Icon(Icons.notifications),
      new Positioned(
        right: 0,
        child: new Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            minWidth: 12,
            minHeight: 12,
          ),
          child: new Text(
            '0',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],) :Icon(Icons.settings));
        // Icon(
        //     index == 0 ? Icons.home : (index == 1 ? Icons.search : Icons.person),
        //     color: Colors.blue,
        //   );
      },

        // inactiveColor:Color(0xffC0C0C0),
        // activeColor: AppTheme.appColor,
        borderColor: Colors.red,
          gapLocation: GapLocation.none,
        leftCornerRadius: 32,rightCornerRadius: 32,
        
          // icons: widget.iconData,
          activeIndex: _currentState,
          onTap: (index){
            setState(() {_currentState = index;});
          //  navigateToScreen(index);
          }),
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
