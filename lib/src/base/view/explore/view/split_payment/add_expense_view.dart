import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/explore/view/split_payment/add_expanse_form1.dart';
import 'package:regcard/src/base/view/explore/view/widgets/custom_indicator.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/app_bars.dart';
import '../../view_model/expense_vm.dart';
import 'add_expanse_form2.dart';
import 'add_expanse_form3.dart';

class AddExpenseView extends StatefulWidget {
  static String route = '/AddExpenseView';
  AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(
      builder: (context, expenseVm, child) {
        return PopScope(
          canPop: expenseVm.selectedExpenseIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (expenseVm.selectedExpenseIndex > 0) {
              expenseVm.selectedExpenseIndex =
                  expenseVm.selectedExpenseIndex - 1;
              expenseVm.update();
            }
          },
          child: Scaffold(
            backgroundColor: R.colors.white,
            appBar: PreferredSize(
              preferredSize: Size(100.w, 12.h),
              child: Column(
                children: [
                  titleAppBar(
                      title: 'add_expense',
                      titleCenter: true,
                      onTap: () {
                        if (expenseVm.selectedExpenseIndex > 0) {
                          expenseVm.selectedExpenseIndex =
                              expenseVm.selectedExpenseIndex - 1;
                          expenseVm.update();
                        } else {
                          Get.back();
                        }
                      },
                      icon: Icons.arrow_back_ios_sharp),
                  h2,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomIndicator(
                        currentIndex: expenseVm.selectedExpenseIndex,
                        totalIndicators: 3),
                  ),
                  h2,
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IndexedStack(
                index: expenseVm.selectedExpenseIndex,
                children: [
                  AddExpanseForm1(),
                  AddExpanseForm2(),
                  AddExpanseForm3(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
