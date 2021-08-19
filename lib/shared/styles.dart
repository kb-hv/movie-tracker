import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_tracker/shared/size_config.dart';

const yellow = Color(0xffFFC91F);
const green = Color(0xff00BC8F);

RoundedRectangleBorder cardBorderStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 3),
  side: BorderSide(
    color: yellow.withOpacity(0.2),
    width: SizeConfig.safeBlockVertical * 0.15,
  ),
);

Center loadingIndicator = Center(
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(yellow),
    backgroundColor: green,
  ),
);

var textFieldDecor = InputDecoration(
  contentPadding: EdgeInsets.all(SizeConfig.safeBlockVertical),
  labelStyle: TextStyle(color: Colors.black45),
  labelText: 'Name of Movie',
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  ),
);

var toast = Fluttertoast.showToast(
  backgroundColor:
  Colors.black45,
  textColor: Colors.white,
  msg:
  "Done",
  toastLength:
  Toast.LENGTH_SHORT,
  gravity:
  ToastGravity.BOTTOM,
);