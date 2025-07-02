import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/account/view/my_profile_view.dart';
import 'package:regcard/src/base/view/explore/view/my_records_view.dart';
import 'package:regcard/src/base/view/explore/view/split_payment/split_payments_view.dart';
import 'package:regcard/src/base/view/explore/view/travel_guides_gridview.dart';
import 'package:regcard/src/base/view/settings/view/settings_view.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/heights_widths.dart';

class ExploreView extends StatefulWidget {
  static String route = '/explore_view';

  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  List titles = [
    'my_regcard',
    'split_payments',
    'my_profile',
    'my_records',
    'travel_guide',
    'settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(
        builder: (context, baseVm, child) => Scaffold(
              backgroundColor: R.colors.white,
              body: Center(
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    h5,
                    ...List.generate(titles.length,
                        (index) => tileWidget(titles[index], index, baseVm)),
                  ],
                ),
              ),
            ));
  }

  Widget tileWidget(String title, int index, BaseVm baseVm) {
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            baseVm.baseSelectedIndex = 2;
            baseVm.update();
            break;
          case 1:
            Get.toNamed(SplitPaymentsView.route);
            break;
          case 2:
            Get.toNamed(MyProfileView.route);
            break;
          case 3:
            Get.toNamed(MyRecordsView.route);
            break;
          case 4:
            Get.toNamed(TravelGuideGridView.route);
            break;
          case 5:
            Get.toNamed(SettingsView.route);
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Text(
          title.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp),
        ),
      ),
    );
  }
}
