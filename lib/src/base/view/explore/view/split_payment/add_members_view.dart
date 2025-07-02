import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/explore/model/split_payment_model.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/src/base/view/home/model/members_model.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../utils/app_button.dart';

class AddMembersView extends StatefulWidget {
  static String route = '/AddMembersView';
  AddMembersView({super.key});

  @override
  State<AddMembersView> createState() => _AddMembersViewState();
}

class _AddMembersViewState extends State<AddMembersView> {
  List<Participants> selectedMembers = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    ExpenseVm expenseVm = Provider.of<ExpenseVm>(context, listen: false);
    ZBotToast.loadingShow();
    selectedMembers = List.from(expenseVm.addedMembersList);
    ZBotToast.loadingClose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(builder: (context, vm, _) {
      List<MembersItems> filteredMembers = vm.allMembersList
          .where((element) => (element.fullName ?? "")
              .isCaseInsensitiveContains(searchController.text))
          .toList();

      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'add_members',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: searchField(vm),
            ),
            if (filteredMembers.isNotEmpty)
              selectAllRow(vm: vm, filteredMembers: filteredMembers),
            filteredMembers.isEmpty
                ? Expanded(
                    child: Center(
                    child: emptyScreen(),
                  ))
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: membersWidget(filteredMembers[index]),
                        );
                      },
                    ),
                  ),
            if (filteredMembers.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: AppButton(
                    buttonTitle: "add",
                    textSize: 10.sp,
                    onTap: () {
                      context.read<ExpenseVm>().addedMembersList =
                          List.from(selectedMembers);
                      context.read<ExpenseVm>().update();
                      Get.back();
                    },
                    fontWeight: FontWeight.w500,
                    textColor: R.colors.white,
                    color: R.colors.black,
                    borderRadius: 25,
                    borderColor: R.colors.black,
                    buttonWidth: 40.w,
                    textPadding: 0,
                  ),
                ),
              )
          ],
        ),
      );
    });
  }

  Widget selectAllRow(
      {required ExpenseVm vm, required List<MembersItems> filteredMembers}) {
    bool isSelectAll = selectedMembers.length == filteredMembers.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "select_all".L(),
            style: R.textStyles
                .inter(fontWeight: FontWeight.w500, fontSize: 12.sp),
          ),
          InkWell(
            onTap: () {
              if (selectedMembers.length == filteredMembers.length) {
                selectedMembers.clear();
              } else {
                selectedMembers.clear();
                selectedMembers.addAll(filteredMembers.map(
                  (e) => Participants(
                      contributionAmount: e.amount,
                      percentage: e.percentage,
                      fullName: e.fullName,
                      isPaid: e.isPaid,
                      pictureUrl: e.pictureUrl,
                      userId: e.id),
                ));
              }
              setState(() {});
            },
            child: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                      color: isSelectAll
                          ? R.colors.transparent
                          : R.colors.primaryColor),
                  color: isSelectAll ? R.colors.primaryColor : R.colors.white),
              child: isSelectAll
                  ? Icon(Icons.check, color: R.colors.white, size: 13)
                  : null,
            ),
          )
        ],
      ),
    );
  }

  Widget membersWidget(MembersItems? membersItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DisplayImage(
                  imageUrl: membersItems?.pictureUrl ?? "",
                  isCircle: true,
                  hasMargin: false,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Text(membersItems?.fullName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: R.textStyles.inter(
                            fontSize: 12.sp, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (selectedMembers.indexWhere(
                    (element) => element.userId == membersItems?.id,
                  ) !=
                  -1) {
                selectedMembers.removeWhere(
                  (element) => element.userId == membersItems?.id,
                );
              } else {
                selectedMembers.add(Participants(
                    contributionAmount: membersItems?.amount ?? 0.0,
                    paymentStatus: 0,
                    percentage: membersItems?.percentage ?? 0,
                    fullName: membersItems?.fullName ?? "",
                    isPaid: membersItems?.isPaid ?? false,
                    pictureUrl: membersItems?.pictureUrl ?? "",
                    userId: membersItems?.id ?? ""));
              }
              setState(() {});
            },
            child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: R.colors.primaryColor),
                    color: selectedMembers.indexWhere(
                              (element) => element.userId == membersItems?.id,
                            ) !=
                            -1
                        ? R.colors.primaryColor
                        : R.colors.white),
                child: Icon(Icons.check,
                    color: selectedMembers.indexWhere(
                              (element) => element.userId == membersItems?.id,
                            ) !=
                            -1
                        ? R.colors.white
                        : R.colors.transparent,
                    size: 13)),
          ),
        ],
      ),
    );
  }

  Widget searchField(ExpenseVm vm) {
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
          hintText: "enter_email_or_username",
          suffixIcon: searchController.text.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    searchController.clear();
                    setState(() {});
                  },
                  child: Icon(Icons.cancel_outlined, color: R.colors.black))
              : null),
      onTapOutside: (val) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (val) async {
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
