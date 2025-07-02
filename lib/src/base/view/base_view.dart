import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/account/view/account_view.dart';
import 'package:regcard/src/base/view/explore/view/explore_view.dart';
import 'package:regcard/src/base/view/home/view/search_view.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/resources.dart';
import '../../../utils/global_functions.dart';
import '../../../utils/safe_area_widget.dart';
import '../view_model/base_vm.dart';
import 'home/view/chats_view.dart';
import 'home/view/home_view.dart';
import 'home/view/notification_view.dart';
import 'my_regcard/view/reg_card_list_view.dart';

class BaseView extends StatefulWidget {
  static String route = '/base_view';

  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  List pages = [
    const ExploreView(),
    const HomeView(),
    // const MyRegCardView(
    //   isFromDashboard: true,
    // ),

    RegCardListView(),

    const AccountView(),
  ];

  List labels = [
    'explore',
    'home',
    'my_RegCard',
    'account',
  ];

  List<String> activeIcon = [
    R.images.explore,
    R.images.home,
    R.images.myRegCard,
    R.images.account,
  ];

  void onItemTapped(int index) {
    var vm = Provider.of<BaseVm>(context, listen: false);
    setState(() {
      vm.baseSelectedIndex = index;
    });
  }

  Future<bool> onBack() {
    var vm = Provider.of<BaseVm>(context, listen: false);
    vm.baseSelectedIndex = 1;
    vm.update();
    return Future.value(false);
  }

  @override
  void initState() {
    var baseVm = Provider.of<BaseVm>(context, listen: false);
    var homeVm = Provider.of<HomeVm>(context, listen: false);
    homeVm.getAllNotifications();
    baseVm.getRegCardInfo();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      AppUser.url = await baseVm.shareMyRegCard();
    });
    baseVm.getSocialLinks();
    var authVm = Provider.of<AuthVm>(context, listen: false);
    authVm.getDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(
        builder: (context, vm, _) => WillPopScope(
            onWillPop:
                vm.baseSelectedIndex == 1 ? GlobalFunctions.onWillPop : onBack,
            child: SafeAreaWidget(
              backgroundColor: R.colors.greyBackgroundColor,
              child: Scaffold(
                  backgroundColor: R.colors.white,
                  appBar: vm.baseSelectedIndex != 1
                      ? AppBar(
                          elevation: 0,
                          centerTitle: true,
                          backgroundColor: R.colors.white,
                          leadingWidth: 75,
                          leading: InkWell(
                            splashColor: R.colors.transparent,
                            highlightColor: R.colors.transparent,
                            onTap: () {
                              Get.toNamed(SearchView.route);
                            },
                            child: Image.asset(R.images.search, scale: 4),
                          ),
                          title: Image.asset(R.images.appLogo, scale: 4),
                          actions: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(ChatsView.route);
                              },
                              child: Image.asset(R.images.message, scale: 4),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(NotificationView.route);
                              },
                              child:
                                  Image.asset(R.images.notification, scale: 4),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        )
                      : null,
                  body: pages.elementAt(vm.baseSelectedIndex),
                  bottomNavigationBar: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: R.colors.greyBackgroundColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            activeIcon.length,
                            (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    vm.baseSelectedIndex = index;
                                  });
                                },
                                child: bottomNavItems(labels[index],
                                    activeIcon[index], index, vm))),
                        SizedBox(
                          width: 7.w,
                        ),
                        Center(
                            child: Image.asset(
                          R.images.appLogo,
                          height: 3.h,
                        )),
                        w1
                      ],
                    ),
                  )),
            )));
  }

  Widget bottomNavItems(String title, String image, int index, BaseVm vm) {
    return Container(
      padding: EdgeInsets.only(
          top: index == 0 ? 1.5.h : 1.2.h,
          left: index == 0 ? 0.w : 11.w,
          right: index == 3 ? 1.w : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            height: index == 0 ? 2.5.h : 3.h,
          ),
          h1,
          Text(
            title.L(),
            style: index == vm.baseSelectedIndex
                ? R.textStyles.inter(
                    color: R.colors.primaryColor,
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w600)
                : R.textStyles.inter(
                    color: R.colors.black,
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w400),
          ),
          h0P5,
          if (index == vm.baseSelectedIndex)
            Container(
              height: 1.h,
              width: 1.w,
              decoration: BoxDecoration(
                  color: R.colors.primaryColor, shape: BoxShape.circle),
            )
        ],
      ),
    );
  }
}
