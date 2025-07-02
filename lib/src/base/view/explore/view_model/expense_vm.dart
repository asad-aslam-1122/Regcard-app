import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/src/base/view/explore/model/add_expense_model.dart';
import 'package:regcard/src/base/view/explore/model/split_payment_model.dart';
import 'package:regcard/src/base/view/home/model/members_model.dart';

import '../../../../../constant/api_urls.dart';
import '../../../../../constant/enums.dart';
import '../../../../../services/api_service.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';

class ExpenseVm extends ChangeNotifier {
  ApiRequest apiRequest = ApiRequest();
  bool isEdit = false;
  late TabController tabController;
  DateTime selectedDate = DateTime.now();
  TextEditingController titleTC = TextEditingController();
  TextEditingController amountTC = TextEditingController();
  TextEditingController dateTC = TextEditingController();
  File? selectedPicture;
  List<MembersItems> allMembersList = [];
  List<Participants> addedMembersList = [];
  List<AddExpenseModel> expenseModelList = [];
  List<AddExpenseModel> otherExpenseList = [];

  int selectedExpenseIndex = 0;
  PaymentMethodEnum? selectedMethod;
  PaymentSplitEnum? selectedSplit;
  double remainingAmount = 0.0;

  Future<bool> getAllMembers() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getAllMembers,
      giveHeader: true,
      onSuccess: (r) {
        log("--all member-$r");
        List list = jsonDecode(r);
        allMembersList = list.map((e) => MembersItems.fromJson(e)).toList();
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["title"]);
      },
    );
    notifyListeners();
    return proceed;
  }

  void updateRemainingAmount() {
    double total = addedMembersList.fold(
        0.0,
        (initialValue, user) =>
            initialValue + (user.contributionAmount ?? 0.0));
    remainingAmount = (double.parse(amountTC.text)) - total;
    update();
  }

  void handleInputChange(int index, String value) {
    double val = double.parse(value);

    if (selectedMethod == PaymentMethodEnum.percentage) {
      addedMembersList[index].percentage = double.parse(value);
      val = (val / 100) * (double.parse(amountTC.text));
    }
    addedMembersList[index].contributionAmount = val;
    updateRemainingAmount();
    update();
  }

  String getRemainingAmount(bool fixed) {
    return fixed
        ? "\$${remainingAmount.toPrecision(2)} ${remainingAmount.toPrecision(2).isNegative ? "over" : "left"}"
        : "${((remainingAmount / double.parse(amountTC.text)) * 100).toPrecision(2)}% ${(remainingAmount.toPrecision(2).isNegative) ? "over" : "left"}";
  }

  bool getRemainingValue() {
    return selectedMethod == PaymentMethodEnum.fix
        ? remainingAmount.toPrecision(2) != 0
        : ((remainingAmount / double.parse(amountTC.text)) * 100)
                .toPrecision(2) !=
            0;
  }

  String getTotalOfReaming(bool fixed) {
    return fixed
        ? "\$${(double.parse(amountTC.text) - remainingAmount).toPrecision(2)} of \$${double.parse(amountTC.text).toPrecision(2)}"
        : "${((100 - (remainingAmount / double.parse(amountTC.text)) * 100)).toPrecision(2)}% of 100%";
  }

  void equallyDivideAmount() {
    double amount = double.parse(amountTC.text) / addedMembersList.length;
    double percentage = 100 / addedMembersList.length;
    for (int i = 0; i < addedMembersList.length; i++) {
      addedMembersList[i].contributionAmount = amount;
      addedMembersList[i].percentage = percentage;
    }
    updateRemainingAmount();
    update();
  }

  onMethodSelected(PaymentMethodEnum method) {
    selectedMethod = method;
    remainingAmount = 0.0;
    updateRemainingAmount();
    updateController();
    update();
  }

  onSplitSelected(PaymentSplitEnum split) {
    selectedSplit = split;
    remainingAmount = 0.0;
    equallyDivideAmount();
    updateController();
    update();
  }

  updateController() {
    for (int i = 0; i < addedMembersList.length; i++) {
      addedMembersList[i].controller = TextEditingController(
          text: selectedMethod == PaymentMethodEnum.percentage
              ? addedMembersList[i].percentage?.toPrecision(2).toString() ??
                  "0.00"
              : addedMembersList[i]
                      .contributionAmount
                      ?.toPrecision(2)
                      .toString() ??
                  "0.00");
    }
  }

  clearAll() {
    selectedExpenseIndex = 0;
    titleTC.clear();
    amountTC.clear();
    dateTC.clear();
    addedMembersList.clear();
    selectedPicture = null;
    selectedMethod = null;
    selectedSplit = null;
    remainingAmount = 0.0;
    update();
  }

  void update() {
    notifyListeners();
  }
}
