import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/src/base/view/explore/view/travel_guide_view.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_bars.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/custom_footer.dart';
import '../../../../../utils/heights_widths.dart';
import '../../home/model/travel_guides_model.dart';

class TravelGuideGridView extends StatefulWidget {
  static String route = '/travel_guide_grid_view';

  const TravelGuideGridView({super.key});

  @override
  State<TravelGuideGridView> createState() => _TravelGuideGridViewState();
}

class _TravelGuideGridViewState extends State<TravelGuideGridView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onLoading(HomeVm vm) async {
    ZBotToast.loadingShow();
    if (vm.travelGuidesModel.hasNext ?? false) {
      await vm.getTravelGuides(
          pageNumber: (vm.travelGuidesModel.currentPage ?? 0) + 1,
          isLoading: true);
    }
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh(HomeVm vm) async {
    vm.travelGuidesModel.travelItems?.clear();
    vm.update();
    await vm.getTravelGuides(pageNumber: 1);

    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(
        builder: (context, homeVm, child) => Scaffold(
            backgroundColor: R.colors.white,
            appBar: titleAppBar(
              title: 'travel_guides',
              titleCenter: true,
              icon: Icons.arrow_back_ios_sharp,
            ),
            body: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(
                color: R.colors.white,
                backgroundColor: R.colors.primaryColor,
              ),
              footer: customFooter(
                  context, homeVm.travelGuidesModel.hasNext ?? false),
              onLoading: () => onLoading(homeVm),
              onRefresh: () => onRefresh(homeVm),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                childAspectRatio: 1 / 1.35,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                children: List.generate(
                    homeVm.travelGuidesModel.travelItems?.length ?? 0,
                    (index) => travelGuideWidget(
                        homeVm.travelGuidesModel.travelItems?[index])),
              ),
            )));
  }

  Widget travelGuideWidget(TravelGuidesItems? travelGuidesItems) {
    return InkWell(
      onTap: () {
        Get.toNamed(TravelGuideView.route, arguments: {
          'url': travelGuidesItems?.blogUrl,
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: travelGuidesItems?.thumbnailUrl ?? "",
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                width: 55.w,
                height: 30.h,
                padding: const EdgeInsets.only(right: 10),
                child: SpinKitPulse(
                  color: R.colors.primaryColor,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 55.w,
                  height: 30.h,
                  child: url.isEmpty
                      ? Image.asset(
                          R.images.spot1,
                          // scale: 1,
                        )
                      : const Icon(Icons.error)),
            ),
          ),
          Text("travel_guide".L(),
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w200, fontSize: 7.sp)),
          h0P5,
          Text(travelGuidesItems?.title ?? '',
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w500, fontSize: 10.sp)),
        ],
      ),
    );
  }
}
