import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/settings/view_model/settings_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';

class BiometricView extends StatelessWidget {
  static String route = "/BiometricView";
  const BiometricView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsVm>(
      builder: (context, settingVm, child) {
        return Scaffold(
          backgroundColor: R.colors.white,
          appBar: titleAppBar(
            title: 'biometrics',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  decoration: BoxDecoration(
                    color: R.colors.greyBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("biometrics".L(),
                          style: R.textStyles.inter(fontSize: 10.sp)),
                      FlutterSwitch(
                        value: () {
                          return settingVm.isBiometricEnabled;
                        }(),
                        onToggle: (val) {
                          settingVm.isBiometricEnabled = val;
                          settingVm.update();
                        },
                        activeColor: R.colors.primaryColor,
                        height: 26,
                        width: 58,
                        padding: 2,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
