import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';

class CustomIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalIndicators;

  const CustomIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalIndicators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalIndicators, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 3.5,
          width: 24.w,
          decoration: BoxDecoration(
            color: index <= currentIndex
                ? R.colors.primaryColor
                : R.colors.textFieldFillColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2.0),
          ),
        );
      }),
    );
  }
}
