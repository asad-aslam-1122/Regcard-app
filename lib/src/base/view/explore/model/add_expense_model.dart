import 'dart:io';

import '../../home/model/members_model.dart';

class AddExpenseModel {
  String title, date;
  double amount;
  File? picture;
  bool hasAccepted;
  List<MembersItems> addedMembersList = [];
  List<MembersItems>? paymentPaidMembersList;

  AddExpenseModel(
      {required this.title,
      required this.amount,
      required this.date,
      this.hasAccepted = false,
      this.picture,
      this.paymentPaidMembersList,
      required this.addedMembersList});
}
