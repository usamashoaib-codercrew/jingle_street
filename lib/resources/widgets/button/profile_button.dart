import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';

class ProfileButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final double height;
  final double width;
  final bool border;
  final  String pic;
  final double borderWidth;
  final Color borderColor;
  final Color? ContainerColor;

  ProfileButton({
    Key? key,
    this.onTap,
    this.height = 32,
    this.width = 32,
    this.border = false,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFFF70000),
    this.ContainerColor = Colors.white,
    this.pic = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final circleSize = screenHeight > screenWidth ? screenWidth : screenHeight;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: (height / circleSize) * height,
        width: (width / circleSize) * width,
        decoration: BoxDecoration(

          // borderRadius: BorderRadius.circular(1),
            border: border
                ? Border.all(width: borderWidth, color: borderColor)
                : null,
            shape: BoxShape.circle,
            color: ContainerColor),
        child: pic.isEmpty
            ? Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(width: 1, color: AppTheme.appColor)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/default.png")),
          ),
        )
            : ClipRRect(  borderRadius: BorderRadius.circular(50.0),child: CachedNetworkImage(
            placeholder: (context, url) => new CircularProgressIndicator(),
            imageUrl:pic,fit: BoxFit.fill,errorWidget:(context,_,fd)=> Image(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/default.png")))),
      ),
    );
  }
}
