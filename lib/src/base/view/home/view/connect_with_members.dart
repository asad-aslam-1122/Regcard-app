import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/home/model/members_model.dart';
import 'package:regcard/src/base/view/home/view/connect_member_view.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/common_bottomsheet.dart';
import '../../../../../utils/custom_footer.dart';

class ConnectWithMembers extends StatefulWidget {
  static String route = "/ConnectWithMembers";
  const ConnectWithMembers({super.key});

  @override
  State<ConnectWithMembers> createState() => _ConnectWithMembersState();
}

class _ConnectWithMembersState extends State<ConnectWithMembers> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onLoading(HomeVm vm) async {
    ZBotToast.loadingShow();
    if (vm.membersModel.hasNext == true) {
      await vm.getMembers(
          pageNumber: (vm.membersModel.currentPage ?? 0) + 1, isLoading: true);
    }
    ZBotToast.loadingClose();
    _refreshController.loadComplete();
    if (mounted) setState(() {});
  }

  void onRefresh(HomeVm vm) async {
    vm.membersModel.membersItems?.clear();
    await vm.getMembers(pageNumber: 1);
    if (mounted)
      setState(() {
        searchController.clear();
      });
    _refreshController.refreshCompleted();
  }

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    HomeVm vm = Provider.of<HomeVm>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => onRefresh(vm));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(builder: (context, homeVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'connect_with_members',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: searchField(homeVm),
            ),
            (homeVm.membersModel.membersItems ?? []).isEmpty
                ? Expanded(
                    child: Center(
                    child: emptyScreen(),
                  ))
                : Expanded(
                    child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropMaterialHeader(
                          color: R.colors.white,
                          backgroundColor: R.colors.primaryColor,
                        ),
                        footer: customFooter(
                            context, homeVm.membersModel.hasNext ?? false),
                        onLoading: () => onLoading(homeVm),
                        onRefresh: () => onRefresh(homeVm),
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          itemCount:
                              homeVm.membersModel.membersItems?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return Center(
                              child: membersWidget(
                                  (homeVm.membersModel.membersItems ??
                                      [])[index],
                                  homeVm),
                            );
                          },
                        )),
                  ),
          ],
        ),
      );
    });
  }

  Widget membersWidget(MembersItems? membersItems, HomeVm homeVm) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(ConnectMemberView.route,
                      arguments: {"member": membersItems});
                },
                child: DisplayImage(
                    width: 60,
                    height: 60,
                    isAllowOnTap: false,
                    imageUrl: membersItems?.pictureUrl ?? '',
                    isCircle: true),
              ),
              Positioned(
                right: 5,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(CommonBottomSheet(
                      title: "send_request",
                      subTitle: "Are_you_sure_you_want_to_send_this_request",
                      showFirstButton: true,
                      showSecondButton: true,
                      firstButtonOnTap: () {
                        Get.back();
                      },
                      secondButtonOnTap: () async {
                        ZBotToast.loadingShow();
                        bool isSend =
                            await homeVm.sendRequest(membersItems?.id ?? "");
                        if (isSend) {
                          membersItems?.isRequestSent = true;
                        }
                        Get.back();
                        ZBotToast.loadingClose();
                      },
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: R.colors.primaryColor,
                        shape: membersItems?.isRequestSent == true
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        borderRadius: membersItems?.isRequestSent == true
                            ? null
                            : BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      membersItems?.isRequestSent == true
                          ? Icons.check
                          : Icons.add,
                      color: R.colors.white,
                      size: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: 65,
            child: Text(membersItems?.fullName ?? "",
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: R.textStyles
                    .inter(fontWeight: FontWeight.w600, fontSize: 8.sp)),
          ),
          SizedBox(
            width: 65,
            child: Text(
              ((membersItems?.workPosition?.isNotEmpty ?? false) &&
                      (membersItems?.company?.isNotEmpty ?? false))
                  ? "${membersItems?.workPosition} at\n${membersItems?.company}"
                  : membersItems?.workPosition ?? "",
              textAlign: TextAlign.center,
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w300, fontSize: 7.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchField(HomeVm homeVm) {
    return TextFormField(
      controller: searchController,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      decoration: R.decoration.fieldDecoration(
          preIcon: Image.asset(
            R.images.searchIcon,
            scale: 5,
          ),
          radius: 31,
          hintText: "search",
          suffixIcon: searchController.text.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    searchController.clear();
                    onRefresh(homeVm);
                    setState(() {});
                  },
                  child: Icon(Icons.cancel_outlined, color: R.colors.black))
              : null),
      onTapOutside: (val) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (val) async {
        await homeVm.getMembers(searchText: searchController.text);
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
          'no_member_search_desc'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 9.sp,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
