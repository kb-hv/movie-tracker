import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal = mediaQueryData.padding.left +
        mediaQueryData.padding.right;
    safeAreaVertical = mediaQueryData.padding.top +
        mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth -
        safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight -
        safeAreaVertical) / 100;
  }
}