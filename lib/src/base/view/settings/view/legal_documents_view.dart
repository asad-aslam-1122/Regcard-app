import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/safe_area_widget.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_bars.dart';

class LegalDocumentsView extends StatefulWidget {
  static String route = "/LegalDocumentsView";

  const LegalDocumentsView({super.key});

  @override
  State<LegalDocumentsView> createState() => _LegalDocumentsViewState();
}

class _LegalDocumentsViewState extends State<LegalDocumentsView> {
  @override
  Widget build(BuildContext context) {
    return SafeAreaWidget(
      top: true,
      child: Consumer<BaseVm>(builder: (context, baseVm, _) {
        return Scaffold(
          appBar: titleAppBar(
              title: baseVm.legalDocsModel?.name ?? "",
              titleCenter: true,
              isTranslated: false,
              icon: Icons.arrow_back_ios_sharp),
          backgroundColor: R.colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: HtmlWidget(
              baseVm.legalDocsModel?.value ?? "",
              textStyle: R.textStyles.inter(),
            ),
          ),
        );
      }),
    );
  }
}
