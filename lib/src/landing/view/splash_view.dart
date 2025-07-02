import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/services/hive_db.dart';
import 'package:regcard/src/auth/model/login_model.dart';
import 'package:regcard/src/auth/view/login_view.dart';
import 'package:regcard/src/base/view/base_view.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/src/base/view/my_regcard/view_model/my_reg_card_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';

import '../../../resources/resources.dart';
import '../../auth/view/complete_profile/complete_profile_form.dart';
import '../../auth/view_model/auth_vm.dart';

class SplashView extends StatefulWidget {
  static String route = '/splash_view';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    var baseVm = Provider.of<BaseVm>(context, listen: false);
    var authVm = Provider.of<AuthVm>(context, listen: false);
    var homeVm = Provider.of<HomeVm>(context, listen: false);
    var regCardsVm = Provider.of<MyRegCardVm>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ZBotToast.loadingShow();
      Future.delayed(const Duration(seconds: 1), () async {
        AppUser.login = (await HiveDb.getLoginData()) ?? LoginModel();
        baseVm.getLegalDocs();
        authVm.clearPersonalizedList();
        if (AppUser.login.token != null) {
          await authVm.getProfileWithSteps();
          await baseVm.getProfile();
          await regCardsVm.getAllDurations();
          await regCardsVm.getAllRegCards(pageNumber: 1);
          authVm.getPersonalizationOptions(id: 0);
          authVm.getPersonalizationOptions(id: 1);
          authVm.getPersonalizationOptions(id: 2);
          authVm.getPersonalizationOptions(id: 3);
          homeVm.getTravelGuides();
          homeVm.getHomeMembers();
          homeVm.getChatHead();
          homeVm.getMembers();
          if (AppUser.login.emailConfirmationRequired == true &&
              AppUser.login.emailConfirmed != true) {
            Get.toNamed(LoginView.route);
          } else {
            AppUser.profileForms.profileStep != 7
                ? {
                    authVm.completeProfilePageIndex =
                        AppUser.profileForms.profileStep!,
                    authVm.completeProfilePageController = PageController(
                        initialPage: authVm.completeProfilePageIndex),
                    authVm.update(),
                    Get.toNamed(CompleteProfileForm.route),
                  }
                : Get.offAllNamed(BaseView.route);
          }
        } else {
          Get.offAllNamed(LoginView.route);
        }
      });
      setState(() {});
    }); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.white,
    );
  }
}
