import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.appBarColor,
    required this.appBarTitle,
    required this.fontColor,
  }) : super(key: key);
  final Color appBarColor;
  final Color fontColor;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '$appBarTitle',
        style: TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 40,
          color: fontColor,
        ),
      ),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      backgroundColor: appBarColor,
      elevation: 0.0,
    );
  }
}
