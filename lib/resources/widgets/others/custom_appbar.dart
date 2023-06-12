import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_assets.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;
  final Widget? title;
  final double? elevation;
  final double height;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const CustomAppBar({
    Key? key,
    this.backgroundColor = Colors.blue,
    this.leading,
    this.title,
    this.elevation,
    this.centerTitle = false,
    this.actions,
    this.height = 50,
    this.leadingWidth,
  }) : super(key: key);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leadingWidth: leadingWidth,
      leading: leading,
      centerTitle: centerTitle,
      actions: actions,
      elevation: elevation,
      title: title,
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final Color color;

  MyAppBar({
    Key? key,
    this.height = 60.0,
    required this.child,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      child: child,
    );
  }
}

ReusableAppBar({BackButton, Function()? ontap}) {
  return AppBar(
      leadingWidth: 50,
      toolbarHeight: 80,
      backgroundColor: AppTheme.appColor,
      elevation: 0,
      leading: BackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 20),
              child: InkWell(
                onTap: ontap,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.chevron_left,
                      color: AppTheme.error,
                      size: 28,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      title: Image(
        image: AssetImage(AppAssetsImages.appLogo),
        width: 195,
      ),
      centerTitle: true);
}

SimpleAppBar1({text, Function()? onTap}) {
  return AppBar(
    leadingWidth: 45,
    title: AppText(
      text,
      bold: FontWeight.bold,
      color: AppTheme.appColor,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
  );
}

SimpleAppBar({text, Function()? onTap, action}) {
  return AppBar(
  
     
    leadingWidth: 50,
    title: AppText(
      text,
      bold: FontWeight.bold,
      color: AppTheme.appColor,
      size: 24,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          radius: 17,
          backgroundColor: AppTheme.appColor,
          child: Center(
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    ),
  );

}
