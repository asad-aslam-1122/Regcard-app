import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/src/base/view/explore/model/records_model.dart';
import 'package:regcard/src/base/view/explore/view/widgets/more_sheet.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/enums.dart';
import '../../../../../resources/resources.dart';
import '../../../../../services/custom_file_picker/pdf_view_widget.dart';
import '../../../../../utils/app_bars.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../../utils/image_preview.dart';
import '../../../../auth/view/complete_profile/widgets/upload_doc_sheet.dart';

class MyRecordsView extends StatefulWidget {
  static String route = '/my_records_view';
  const MyRecordsView({super.key});

  @override
  State<MyRecordsView> createState() => _MyRecordsViewState();
}

class _MyRecordsViewState extends State<MyRecordsView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onLoading(BaseVm vm) async {
    ZBotToast.loadingShow();
    if (vm.recordsModel.hasNext == true) {
      await vm.getRecords(
          pageNumber: (vm.recordsModel.currentPage ?? 0) + 1, isLoading: true);
    }
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh(BaseVm vm) async {
    vm.recordsModel.items?.clear();
    vm.update();
    await vm.getRecords(
      pageNumber: 1,
    );
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    ZBotToast.loadingShow();
    var vm = Provider.of<BaseVm>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      vm.getRecords();
      ZBotToast.loadingClose();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(
        builder: (context, baseVm, child) => Scaffold(
            backgroundColor: R.colors.white,
            appBar: titleAppBar(
                title: 'my_records',
                titleCenter: true,
                icon: Icons.arrow_back_ios_sharp,
                actions: [
                  if (baseVm.recordsModel.items?.isNotEmpty == true)
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(const UploadDocumentSheet(
                          isRecordsDoc: true,
                          isDocTypeSelected: true,
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: R.colors.primaryColor),
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.add,
                          color: R.colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                ]),
            body: baseVm.recordsModel.items?.isEmpty == true
                ? Center(
                    child: emptyScreen(),
                  )
                : documentsView(records: baseVm.recordsModel, baseVm: baseVm)));
  }

  Widget documentsView({RecordsModel? records, required BaseVm baseVm}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: R.colors.greyBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(
          color: R.colors.white,
          backgroundColor: R.colors.primaryColor,
        ),
        onLoading: () => onLoading(baseVm),
        onRefresh: () => onRefresh(baseVm),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          childAspectRatio: 1 / 1.15,
          shrinkWrap: true,
          children: List.generate(records?.items?.length ?? 0, (index) {
            final document = records?.items?[index];
            final fileType = document?.recordUrl?.split(".").last;
            return Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: document?.recordUrl ?? "",
                    imageBuilder: (context, image) {
                      return GestureDetector(
                        onTap: () async {
                          if (fileType != null) {
                            if (fileType == FileTypeEnum.jpg.name ||
                                fileType == FileTypeEnum.jpeg.name ||
                                fileType == FileTypeEnum.png.name) {
                              Get.to(
                                  () => ImageViewScreen(imageProvider: image));
                            }
                          }
                        },
                        child: Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: image, fit: BoxFit.cover)),
                        ),
                      );
                    },
                    placeholder: (context, url) => Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SpinKitPulse(
                        color: R.colors.primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return (fileType == FileTypeEnum.pdf.name ||
                              fileType == FileTypeEnum.xls.name ||
                              fileType == FileTypeEnum.xlsx.name ||
                              fileType == FileTypeEnum.doc.name ||
                              fileType == FileTypeEnum.docx.name)
                          ? GestureDetector(
                              onTap: () async {
                                if (fileType == FileTypeEnum.pdf.name) {
                                  Get.to(() => PDFViewWidget(
                                        path: "",
                                        fromUrl: true,
                                        url: document?.recordUrl,
                                      ));
                                } else {
                                  await OpenFilex.open(
                                      document?.recordUrl ?? "");
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 5, left: 5, right: 5),
                                width: Get.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        (fileType == FileTypeEnum.pdf.name)
                                            ? R.images.pdfPage
                                            : (fileType ==
                                                        FileTypeEnum.xls.name ||
                                                    fileType ==
                                                        FileTypeEnum.xlsx.name)
                                                ? R.images.xlsPage
                                                : R.images.docPage,
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: R.colors.primaryColor),
                              child: Icon(Icons.error, color: R.colors.white),
                            );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        '${document?.name}.$fileType',
                        style: R.textStyles.inter(
                          color: R.colors.black,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Get.bottomSheet(MoreOptionSheet(
                            id: document?.id,
                            isRecords: true,
                            documentName: document?.name,
                            documentUrl: document?.recordUrl,
                          ));
                        });
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: R.colors.transparent,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.more_horiz_outlined,
                            color: R.colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget emptyScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'no_records'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'no_records_desc'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 9.sp,
              fontWeight: FontWeight.w300),
        ),
        h5,
        AppButton(
          buttonTitle: 'add_records',
          textSize: 9.sp,
          onTap: () {
            Get.bottomSheet(const UploadDocumentSheet(
              isAddToTempList: false,
              isRecordsDoc: true,
              isDocTypeSelected: true,
            ));
          },
          fontWeight: FontWeight.w500,
          textColor: R.colors.black,
          color: R.colors.textFieldFillColor,
          borderRadius: 25,
          borderColor: R.colors.black,
          horizentalPadding: 13.w,
          textPadding: 1.5.h,
        ),
      ],
    );
  }
}
