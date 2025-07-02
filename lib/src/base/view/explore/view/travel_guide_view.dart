import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';

class TravelGuideView extends StatefulWidget {
  static String route = "/travel_guide";

  const TravelGuideView({super.key});

  @override
  State<TravelGuideView> createState() => _TravelGuideViewState();
}

class _TravelGuideViewState extends State<TravelGuideView> {
  late final WebViewController _controller;

  static String url = '';

  @override
  void initState() {
    dynamic args = Get.arguments;
    if (args != null) {
      url = args['url'];
    } else {
      url = 'https://www.regcard.com';
    }

    ZBotToast.loadingShow();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(R.colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              ZBotToast.loadingClose();
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWidget(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 23,
                color: R.colors.black,
              )),
          backgroundColor: R.colors.white,
          title: Text(
            url,
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: R.colors.white,
        body: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
