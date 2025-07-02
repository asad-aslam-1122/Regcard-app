import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../resources/localization/app_localization.dart';
import '../../resources/resources.dart';
import '../app_button.dart';
import '../bot_toast/zbot_toast.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends State<NoInternetScreen> {
  bool isChecking = false;
  final Connectivity _connectivity = Connectivity();

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    switch (result.first) {
      case ConnectivityResult.wifi:
        {
          ZBotToast.showToastSuccess(message: "Connection Restored");
          Navigator.pop(context);
        }
        break;
      case ConnectivityResult.mobile:
        {
          ZBotToast.showToastSuccess(message: "Hurray! Connection Restored");
          Navigator.pop(context);
        }
        break;
      case ConnectivityResult.none:
        break;
      default:
        break;
    }
    debugPrint(result.toString());
  }

  void startConnectionStream() {}

  Future<bool> checkBeforeGoingBack() async {
    List<ConnectivityResult> result;
    result = await _connectivity.checkConnectivity();
    if (result.first == ConnectivityResult.mobile ||
        result.first == ConnectivityResult.wifi) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    initConnectivity();
    // startConnectionStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //FeatureDiscovery.dismissAll(Get.context);
    return WillPopScope(
      onWillPop: checkBeforeGoingBack,
      child: SafeAreaWidget(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: titleAppBar(
              title: "regcard",
              onTap: () {
                initConnectivity();
              }),
          body: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * .1,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      noInternetWidget(scale: 2),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * .05),
                        //  alignment: Alignment.topCenter,
                        width: Get.width,
                        child: Text(
                          LocalizationMap.getTranslatedValues(
                              "no_internet_connection"),
                          style: R.textStyles.inter(
                              color: R.colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                isChecking
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: R.colors.primaryColor,
                        ),
                      )
                    : AppButton(
                        buttonWidth: 80.w,
                        borderColor: R.colors.primaryColor,
                        color: R.colors.primaryColor,
                        buttonTitle: 'retry',
                        textColor: R.colors.white,
                        onTap: () {
                          initConnectivity();
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noInternetWidget({double scale = 2}) {
    return Center(
        child: Image.asset(
      R.images.noInternetGif,
      scale: scale,
    ));
  }
}
