import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:regcard/constant/enums.dart';

int? getDeviceType(BuildContext context) {
  final double deviceWidth = MediaQuery.of(context).size.shortestSide;
  final double deviceHeight = MediaQuery.of(context).size.longestSide;
  final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

  // Calculate the diagonal screen size
  final double screenSize = sqrt(pow(deviceWidth, 2) + pow(deviceHeight, 2));

  // Determine the device type based on screen size and pixel density
  if (kIsWeb) {
    return DeviceTypeEnums.web.index;
  } else if (Platform.isAndroid) {
    return DeviceTypeEnums.androidMobile.index;
    // if (screenSize >= 600) {
    //   return DeviceTypeEnums.androidTab.index;
    // } else {
    //   return DeviceTypeEnums.androidMobile.index;
    // }
  } else if (Platform.isIOS) {
    return DeviceTypeEnums.iOSMobile.index;
    // if (screenSize >= 1100 && deviceWidth / pixelRatio >= 768) {
    //   return DeviceTypeEnums.iOSTab.index;
    // } else {
    //   return DeviceTypeEnums.iOSMobile.index;
    // }
  } else {
    // Unknown device
    return null;
  }
}