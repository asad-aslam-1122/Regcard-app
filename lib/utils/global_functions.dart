import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:regcard/utils/localization_extension.dart';

import '../src/auth/view_model/auth_vm.dart';
import 'bot_toast/zbot_toast.dart';

class GlobalFunctions {
  static DateTime? currentBackPressTime;
  static Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      ZBotToast.showToastError(
        message: "press_again_to_exit".L(),
      );

      return Future.value(false);
    }
    return Future.value(true);
  }

  static Future<bool> onBackPop() {
    DateTime now = DateTime.now();
    var authVm = Provider.of<AuthVm>(Get.context!, listen: false);

    if (authVm.completeProfilePageIndex != 0) {
      authVm.completeProfilePageIndex = authVm.completeProfilePageIndex - 1;
      authVm.update();
      authVm.completeProfilePageController
          .jumpToPage(authVm.completeProfilePageIndex);
      return Future.value(false);
    } else {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
        currentBackPressTime = now;
        ZBotToast.showToastError(
          message: "press_again_to_exit".L(),
        );

        return Future.value(false);
      }
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  static Future<bool> checkPermissionStatus(PermissionStatus status) async {
    // switch (status) {
    //   case PermissionStatus.denied:
    //     if (!await Permission.location.request().isGranted) {
    //       Get.dialog(const PermissionDialog());
    //     } else {
    //       return true;
    //     }
    //     return false;
    //   case PermissionStatus.granted:
    //     return true;
    //   case PermissionStatus.restricted:
    //     Get.dialog(const PermissionDialog());
    //
    //     return false;
    //   case PermissionStatus.limited:
    //     Get.dialog(const PermissionDialog());
    //
    //     return false;
    //   case PermissionStatus.permanentlyDenied:
    //     Get.dialog(const PermissionDialog());
    //
    //     return false;

    // }
    return true;
  }
}
