import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/explore/view/split_payment/add_expense_view.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/app_bars.dart';
import '../../../../../../utils/bot_toast/zbot_toast.dart';
import '../../view_model/expense_vm.dart';

class SplitPaymentsView extends StatefulWidget {
  static String route = '/SplitPaymentsView';
  const SplitPaymentsView({super.key});

  @override
  State<SplitPaymentsView> createState() => _SplitPaymentsViewState();
}

class _SplitPaymentsViewState extends State<SplitPaymentsView> {
  @override
  void initState() {
    ZBotToast.loadingShow();
    ExpenseVm vm = context.read<ExpenseVm>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await vm.getAllMembers();
        ZBotToast.loadingClose();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.white,
      appBar: titleAppBar(
          title: 'split_payments',
          titleCenter: true,
          icon: Icons.arrow_back_ios_sharp),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                R.images.splitBills,
                scale: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "split_payments_with_ease".L(),
                style: R.textStyles
                    .inter(fontWeight: FontWeight.w600, fontSize: 18.sp),
              ),
              Text(
                "create_your_first_split_payment_to_share_costs_seamlessly".L(),
                textAlign: TextAlign.center,
                style: R.textStyles
                    .inter(fontWeight: FontWeight.w300, fontSize: 10.sp),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddExpenseView.route);
        },
        backgroundColor: R.colors.primaryColor,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: R.colors.white,
          size: 30,
        ),
      ),
    );
  }
}
