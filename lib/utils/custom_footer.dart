import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../resources/resources.dart';

CustomFooter customFooter(BuildContext context, bool hasNext) {
  return CustomFooter(
    builder: (context, mode) {
      switch (mode) {
        case LoadStatus.idle:
          return SizedBox();
        case LoadStatus.loading:
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitRotatingCircle(
                    color: R.colors.primaryColor,
                    size: 20,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    "loading".L(),
                    style: R.textStyles.inter(),
                  ),
                ],
              ));
        case LoadStatus.failed:
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "load_failed_please_try_again".L(),
                style: R.textStyles.inter(),
              ),
            ),
          );
        case LoadStatus.canLoading:
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_upward_sharp,
                  size: 20,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  "release_to_load_more".L(),
                  style: R.textStyles.inter(),
                ),
              ],
            ),
          );
        default:
          return SizedBox();
      }
    },
  );
}
