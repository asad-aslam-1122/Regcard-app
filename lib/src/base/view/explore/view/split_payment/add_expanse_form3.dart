import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/explore/model/split_payment_model.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../utils/app_button.dart';

class AddExpanseForm3 extends StatefulWidget {
  const AddExpanseForm3({super.key});

  @override
  State<AddExpanseForm3> createState() => _AddExpanseForm3State();
}

class _AddExpanseForm3State extends State<AddExpanseForm3> {
  TextEditingController searchController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(builder: (context, vm, _) {
      List<Participants> filteredMembers = vm.addedMembersList
          .where((element) => (element.fullName ?? "")
              .isCaseInsensitiveContains(searchController.text))
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "who_paid".L(),
            style: R.textStyles
                .inter(fontWeight: FontWeight.w500, fontSize: 12.sp),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
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
                  buttonTitle: "save",
                  textSize: 10.sp,
                  onTap: () {
                    vm.clearAll();
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
      );
    });
  }

  Widget selectAllRow(
      {required ExpenseVm vm, required List<Participants> filteredMembers}) {
    bool allPaid = filteredMembers.every((e) => e.isPaid == true);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
              for (var member in filteredMembers) {
                member.isPaid = !allPaid;
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
                      color: allPaid
                          ? R.colors.transparent
                          : R.colors.primaryColor),
                  color: allPaid ? R.colors.primaryColor : R.colors.white),
              child: allPaid
                  ? Icon(Icons.check, color: R.colors.white, size: 13)
                  : null,
            ),
          )
        ],
      ),
    );
  }

  Widget membersWidget(Participants? participant) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DisplayImage(
                  imageUrl: participant?.pictureUrl ?? "",
                  isCircle: true,
                  hasMargin: false,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Text(participant?.fullName ?? "",
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
              participant.isPaid = !(participant.isPaid ?? false);
              setState(() {});
            },
            child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: R.colors.primaryColor),
                    color: participant!.isPaid == true
                        ? R.colors.primaryColor
                        : R.colors.white),
                child: Icon(Icons.check,
                    color: participant.isPaid == true
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
