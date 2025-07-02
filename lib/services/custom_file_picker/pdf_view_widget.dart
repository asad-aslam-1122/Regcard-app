import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewWidget extends StatefulWidget {
  final String path;
  final bool isForSubmit;
  final bool fromUrl;
  final String? url;

  const PDFViewWidget(
      {Key? key,
      required this.path,
      this.isForSubmit = true,
      this.fromUrl = false,
      this.url})
      : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFViewWidget> with WidgetsBindingObserver {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: R.colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: R.colors.white,
            appBar: AppBar(
                backgroundColor: R.colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                  onTap: () {
                    Get.back(result: false);
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(Icons.arrow_back_rounded,
                          color: R.colors.primaryColor)),
                ),
                title: Text(
                  "Preview",
                  style: R.textStyles.inter(fontSize: 14.sp),
                )),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  // widget.fromUrl
                  //     ? SfPdfViewerTheme(
                  //         data:
                  //             SfPdfViewerThemeData(backgroundColor: R.colors.white),
                  //         child: SfPdfViewer.network(
                  //           scrollDirection: PdfScrollDirection.horizontal,
                  //           pageLayoutMode: PdfPageLayoutMode.single,
                  //           canShowTextSelectionMenu: false,
                  //           widget.url ?? "",
                  //           key: _pdfViewerKey,
                  //         ),
                  //       )
                  //     :
                  Column(
                children: [
                  Expanded(
                    child: SfPdfViewerTheme(
                      data:
                          SfPdfViewerThemeData(backgroundColor: R.colors.white),
                      child: SizedBox(),
                      // child: SfPdfViewer.file(
                      //   scrollDirection: PdfScrollDirection.horizontal,
                      //   pageLayoutMode: PdfPageLayoutMode.single,
                      //   canShowTextSelectionMenu: false,
                      //   File(widget.path),
                      //   key: _pdfViewerKey,
                      // ),
                    ),
                  ),
                  if (widget.isForSubmit)
                    Container(
                      color: R.colors.white,
                      width: 100.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 10),
                      child: AppButton(
                          buttonTitle: "submit",
                          onTap: () {
                            Get.back(result: true);
                          }),
                    )
                  else
                    const SizedBox(
                      height: 10,
                    ),
                ],
              ),
            )),
      ),
    );
  }

  Widget detailsRow({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(
                color: R.colors.primaryColor, shape: BoxShape.circle),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: R.textStyles.inter(color: R.colors.red, fontSize: 10.sp),
          )
        ],
      ),
    );
  }
}
