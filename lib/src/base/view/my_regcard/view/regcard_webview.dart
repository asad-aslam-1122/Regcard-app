import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/settings/view_model/settings_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../constant/app_user.dart';
import '../../../../../constant/enums.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utils/app_bars.dart';

class RegcardWebView extends StatefulWidget {
  static String route = "/regcard_web_view";

  const RegcardWebView({super.key});

  @override
  State<RegcardWebView> createState() => _RegcardWebViewState();
}

class _RegcardWebViewState extends State<RegcardWebView> {
  late final WebViewController _controller;

  static String url = '';

  @override
  void initState() {
    super.initState();
    var baseVm = Provider.of<BaseVm>(context, listen: false);
    var settingsVm = Provider.of<SettingsVm>(context, listen: false);
    url = baseVm.infoCardModel.webViewUrl ?? "";

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
          onPageStarted: (String url) {
            print('page started');
          },
          onPageFinished: (String url) {
            print('page finished');
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            log("onNavigationRequest");
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) async {
            log("onUrlChange");
            if ((change.url ?? "").contains("&redirect=true")) {
              ZBotToast.loadingShow();
              if (AppUser.userProfile?.isRegCardFirstShare == false) {
                bool isSuccess = await settingsVm.userSettingsToggle(
                    type: NotificationToggleEnum.regCardFirstShare.index,
                    value: true);
                if (isSuccess) {
                  AppUser.userProfile?.isRegCardFirstShare = true;
                  settingsVm.update();
                }
              }
              baseVm.baseSelectedIndex = 2;
              baseVm.update();
              Get.back();
              Future.delayed(Duration(seconds: 1), () {
                ZBotToast.showToastSuccess(
                    message: "share_profile_updated_successfully".L());
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWidget(
      top: true,
      child: Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
          title: 'my_regcard',
          titleCenter: true,
          icon: Icons.arrow_back_ios_sharp,
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
