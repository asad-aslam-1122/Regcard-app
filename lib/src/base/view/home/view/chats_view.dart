import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/src/base/view/home/model/chat_head_model.dart';
import 'package:regcard/src/base/view/home/model/chat_model.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/app_user.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utils/app_bars.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/custom_footer.dart';
import '../../../../../utils/inbox_card_widget.dart';

class ChatsView extends StatefulWidget {
  static String route = "/ChatView";

  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int pageNumber = 1;

  void onLoading(HomeVm vm) async {
    ZBotToast.loadingShow();
    if ((vm.chatHeadModel.totalRecords ?? 0) >
        (vm.chatHeadModel.chatHead ?? []).length) {
      pageNumber += 1;
      await vm.getChatHead(
        pageNumber: pageNumber,
        isLoading: true,
      );
      vm.update();
    }
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh(HomeVm vm) async {
    vm.chatHeadModel.chatHead?.clear();
    await vm.getChatHead(pageNumber: 1, isLoading: false);
    vm.update();

    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    HomeVm homeVm = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        ZBotToast.loadingShow();
        await homeVm.getChatHead(pageNumber: pageNumber, isLoading: false);
        homeVm.update();
        ZBotToast.loadingClose();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(
        builder: (context, homeVm, child) => Scaffold(
            appBar: titleAppBar(
                title: 'inbox',
                titleCenter: true,
                icon: Icons.arrow_back_ios_sharp),
            backgroundColor: R.colors.white,
            body: (homeVm.chatHeadModel.chatHead ?? []).isEmpty
                ? emptyScreen()
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropMaterialHeader(
                      color: R.colors.white,
                      backgroundColor: R.colors.primaryColor,
                    ),
                    footer: customFooter(
                        context,
                        ((homeVm.chatHeadModel.totalRecords ?? 0) >
                            (homeVm.chatHeadModel.chatHead ?? []).length)),
                    onLoading: () => onLoading(homeVm),
                    onRefresh: () => onRefresh(homeVm),
                    child: ListView.builder(
                        itemCount: homeVm.chatHeadModel.chatHead?.length ?? 0,
                        itemBuilder: (context, index) => chatTileWidget(
                            (homeVm.chatHeadModel.chatHead ?? [])[index],
                            homeVm)))));
  }

  Widget chatTileWidget(ChatHead chatHead, HomeVm homeVm) {
    Sender otherUser = (chatHead.users ?? [])[0].id == AppUser.userProfile?.id
        ? (chatHead.users ?? [])[1]
        : (chatHead.users ?? [])[0];
    return InboxCardWidget(
      chatHead: chatHead,
      homeVm: homeVm,
      otherUser: otherUser,
    );
  }

  Widget emptyScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'no_chats'.L(),
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600),
          ),
          Text(
            'no_chats_found'.L(),
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
