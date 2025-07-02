import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/explore/view/expense_details/my_payments.dart';
import 'package:regcard/src/base/view/explore/view/expense_details/other_payments.dart';
import 'package:regcard/src/base/view/explore/view/split_payment/add_expense_view.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/app_button.dart';

class PaymentHistoryView extends StatefulWidget {
  static String route = '/PaymentHistoryView';
  const PaymentHistoryView({super.key});

  @override
  State<PaymentHistoryView> createState() => _PaymentHistoryViewState();
}

class _PaymentHistoryViewState extends State<PaymentHistoryView>
    with SingleTickerProviderStateMixin {
  List<String> paymentHistoryList = ["my_payments", "other_payments"];
  List<Widget> paymentHistoryBodyList = [MyPayments(), OtherPayments()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final managePageProvider = context.read<ExpenseVm>();
    managePageProvider.tabController =
        TabController(length: paymentHistoryList.length, vsync: this);
    managePageProvider.tabController.addListener(() {
      managePageProvider.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(
      builder: (context, expenseVm, child) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
              backgroundColor: R.colors.white,
              appBar: titleAppBar(
                title: "payment_history",
                titleCenter: true,
                icon: Icons.arrow_back_ios_sharp,
              ),
              body: SizedBox(
                height: 100.h,
                width: 100.h,
                child: Column(
                  children: [
                    h1,
                    Container(
                      height: 39,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Theme(
                        data: ThemeData(
                          splashColor: R.colors.primaryColor,
                        ),
                        child: TabBar(
                          splashBorderRadius: BorderRadius.circular(20),
                          controller: expenseVm.tabController,
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 65),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: R.colors.transparent,
                          indicatorColor: R.colors.primaryColor,
                          unselectedLabelColor: R.colors.black,
                          labelColor: R.colors.black,
                          labelStyle: R.textStyles.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                          tabs: List.generate(
                            paymentHistoryList.length,
                            (index) {
                              return Tab(
                                icon: Text(
                                  paymentHistoryList[index].L(),
                                  style: R.textStyles.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: R.colors.textFieldFillColor.withOpacity(0.5),
                    ),
                    h1,
                    Expanded(
                      child: TabBarView(
                          controller: expenseVm.tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: paymentHistoryBodyList),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: expenseVm.tabController.index == 0
                  ? Padding(
                      padding:
                          EdgeInsets.only(bottom: 6.w, left: 28.w, right: 28.w),
                      child: AppButton(
                        buttonTitle: "add_expense",
                        textSize: 10.sp,
                        onTap: () {
                          Get.toNamed(AddExpenseView.route);
                        },
                        fontWeight: FontWeight.w500,
                        textColor: R.colors.white,
                        color: R.colors.black,
                        borderRadius: 25,
                        borderColor: R.colors.black,
                        buttonWidth: 40.w,
                        textPadding: 0,
                      ),
                    )
                  : null),
        );
      },
    );
  }
}
