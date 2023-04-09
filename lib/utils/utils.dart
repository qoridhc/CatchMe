import 'package:flutter/material.dart';

  double getMediaHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  double getMediaWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  double getAppBarHeight(BuildContext context){
    return MediaQuery.of(context).padding.top;
  }

