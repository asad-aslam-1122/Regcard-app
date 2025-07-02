import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/custom_footer.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../explore/view/travel_guide_view.dart';
import '../model/travel_guides_model.dart';

class SearchView extends StatefulWidget {
  static String route = "/SearchView";

  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();
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
              resizeToAvoidBottomInset: false,
              backgroundColor: R.colors.white,
              appBar: titleAppBar(
                  title: 'search',
                  titleCenter: true,
                  icon: Icons.arrow_back_ios_sharp),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    searchField(homeVm),
                    h1,
                    Expanded(
                        child: SmartRefresher(
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
                      child:
                          (homeVm.travelGuidesModel.travelItems ?? []).isEmpty
                              ? Center(child: emptyScreen())
                              : GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 1 / 1.35,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  children: List.generate(
                                      homeVm.travelGuidesModel.travelItems
                                              ?.length ??
                                          10,
                                      (index) => travelGuideWidget(homeVm
                                          .travelGuidesModel
                                          .travelItems?[index])),
                                ),
                    ))
                  ],
                ),
              ),
            ));
  }

  Widget searchField(HomeVm homeVm) {
    return TextFormField(
      controller: searchController,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      // validator: FieldValidator.validateEmail,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
          preIcon: Icon(Icons.search, color: R.colors.lightGreyColor),
          radius: 31,
          hintText: "search",
          suffixIcon: searchController.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    searchController.clear();
                    onRefresh(homeVm);
                    setState(() {});
                  },
                  child: Icon(Icons.cancel_outlined, color: R.colors.black))
              : null),
      onTap: () {
        setState(() {});
      },
      onTapOutside: (val) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (val) {
        homeVm.getTravelGuides(searchText: searchController.text);
        setState(() {});
      },
      onEditingComplete: () async {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget emptyScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'no_search'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'no_search_desc'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 9.sp,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget travelGuideWidget(TravelGuidesItems? travelGuidesItems) {
    return InkWell(
      onTap: () {
        Get.toNamed(TravelGuideView.route, arguments: {
          'url': travelGuidesItems?.blogUrl,
        });
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: travelGuidesItems?.thumbnailUrl ?? "",
              imageBuilder: (context, imageProvider) {
                return Container(
                  // width: 55.w,
                  // height: 30.h,
                  // margin: const EdgeInsets.only(right: 10),
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
          Text("Travel Guide",
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
