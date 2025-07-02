import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/enums.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/account/view/add_documents_view.dart';
import 'package:regcard/src/base/view/account/view/documents_view.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_bars.dart';

class FamilyMemberView extends StatefulWidget {
  static String route = '/FamilyMemberView';

  const FamilyMemberView({Key? key}) : super(key: key);

  @override
  State<FamilyMemberView> createState() => _FamilyMemberViewState();
}

class _FamilyMemberViewState extends State<FamilyMemberView> {
  String? name;
  // List<NewDocumentModel> docList = [];
  DocumentType? docType;

  @override
  void initState() {
    name = Get.arguments['title'];
    // docList = Get.arguments['documents'];
    docType = Get.arguments['docType'];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
      builder: (context, authVm, child) => Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
          title: name,
          titleCenter: true,
          isTranslated: false,
          icon: Icons.arrow_back_ios_sharp,
          actions: [
            InkWell(
              onTap: () {
                if (docType == DocumentType.familyDocuments) {
                  Get.toNamed(AddDocumentsView.route, arguments: {
                    'docTypeSelected': true,
                    'docType': docType,
                  });
                }
                // Get.toNamed(AddDocumentsView.route,
                //     arguments: {'adDoc': false});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: R.colors.primaryColor,
                ),
                padding: const EdgeInsets.all(3),
                margin: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.add,
                  color: R.colors.white,
                  size: 23,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              children: [
                ...List.generate(
                    authVm.familyDocsList
                        .map((e) => e.familyMember)
                        .toSet()
                        .toList()
                        .length,
                    (index) => tile(
                        authVm.familyDocsList
                            .map((e) => e.familyMember)
                            .toSet()
                            .toList()[index],
                        authVm))
              ],
            )),
      ),
    );
  }

  // Widget documentsView(List<NewDocumentModel> listOfDoc) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
  //     decoration: BoxDecoration(
  //         color: R.colors.greyBackgroundColor,
  //         borderRadius: BorderRadius.circular(12)
  //     ),
  //     child: GridView.count(crossAxisCount: 2,
  //       crossAxisSpacing: 15,
  //       mainAxisSpacing: 20,
  //       childAspectRatio: 0.8,
  //       children: List.generate(listOfDoc.length, (index) {
  //         final document = listOfDoc[index];
  //         final fileType = document.documentUrl?.split(".").last;
  //         print("file type : $fileType");
  //         return Column(
  //           children: [
  //             // InkWell(
  //             //   onTap: () async {
  //             //       if ( fileType== FileTypeEnum.jpg.name ||
  //             //           fileType == FileTypeEnum.jpeg.name ||
  //             //           fileType == FileTypeEnum.png.name) {
  //             //         Get.dialog(
  //             //           ImageSlider(
  //             //             index: index,
  //             //             sliderList: listOfDoc.map((e) => e.file).toList()
  //             //             // id == 0 ? authVm.myDocuments.map((e) => e.file).toList() : authVm.additionalDocuments.map((e) => e.file).toList(),
  //             //           ),
  //             //         );
  //             //       } else if (fileType == FileTypeEnum.pdf.name) {
  //             //         Get.to(
  //             //           () => PDFViewWidget(
  //             //             path: document?.file!.path??"",
  //             //             isForSubmit: false,
  //             //           ),
  //             //         );
  //             //       } else {
  //             //         await OpenFilex.open(document?.file!.path);
  //             //       }
  //             //
  //             //   },
  //             //   child: Container(
  //             //     margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
  //             //     width: Get.width * .40,
  //             //     height: 40.w,
  //             //     decoration: BoxDecoration(
  //             //       image: DecorationImage(
  //             //         image: AssetImage(
  //             //           (fileType == FileTypeEnum.jpg.name ||
  //             //                   fileType == FileTypeEnum.jpeg.name ||
  //             //                   fileType == FileTypeEnum.png.name
  //             //               ? R.images.image
  //             //               : fileType == FileTypeEnum.pdf.name
  //             //                   ? R.images.pdf
  //             //                   : (fileType == FileTypeEnum.xls.name ||
  //             //                           fileType == FileTypeEnum.xlsx.name)
  //             //                       ? R.images.xls
  //             //                       : R.images.doc),
  //             //         ),
  //             //         fit: BoxFit.cover,
  //             //       ),
  //             //       borderRadius: BorderRadius.circular(8),
  //             //     ),
  //             //   ),
  //             // ),
  //             // if (fileType == FileTypeEnum.jpg.name ||
  //             //     fileType == FileTypeEnum.jpeg.name ||
  //             //     fileType == FileTypeEnum.png.name)
  //             Expanded(
  //               child: CachedNetworkImage(
  //                 imageUrl: document.documentUrl ?? "",
  //                 imageBuilder: (context, image) {
  //                   return GestureDetector(
  //                     onTap: () async {
  //                       if(fileType!=null){
  //                         if (fileType == FileTypeEnum.jpg.name ||
  //                             fileType == FileTypeEnum.jpeg.name ||
  //                             fileType == FileTypeEnum.png.name)
  //                         {Get.to(() => ImageViewScreen(imageProvider: image));}
  //
  //                       }
  //                     },
  //                     child: Container(
  //                       width: Get.width,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(12),
  //                           image: DecorationImage(image: image, fit: BoxFit.cover)
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 placeholder: (context, url) => Container(
  //                   width: Get.width,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: SpinKitPulse(
  //                     color: R.colors.primaryColor,
  //                   ),),
  //                 errorWidget: (context, url, error)
  //                 { return (fileType == FileTypeEnum.pdf.name || fileType == FileTypeEnum.xls.name || fileType == FileTypeEnum.xlsx.name || fileType == FileTypeEnum.doc.name || fileType == FileTypeEnum.docx.name) ?
  //                 GestureDetector(
  //                   onTap:  () async {
  //                     if (fileType == FileTypeEnum.pdf.name)
  //                     {
  //                       Get.to(() => PDFViewWidget(
  //                         path: document.documentUrl ?? "",
  //                         fromUrl: true,
  //                         url: document.documentUrl,
  //                       ));
  //                     }
  //                     else {
  //                       await OpenFilex.open(document.documentUrl);
  //                     }
  //                   },
  //                   child: Container(
  //                     margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
  //                     width: Get.width,
  //                     decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                           image: AssetImage(
  //                             (fileType == FileTypeEnum.pdf.name)
  //                                 ? R.images.pdf
  //                                 : (fileType == FileTypeEnum.xls.name ||
  //                                 fileType == FileTypeEnum.xlsx.name)
  //                                 ? R.images.xls
  //                                 : R.images.doc,
  //                           ),
  //                           fit: BoxFit.cover),
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                 ) :
  //                 Container(
  //                   width: Get.width,
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: R.colors.primaryColor),
  //                   child: Icon(Icons.error, color: R.colors.white),
  //                 );
  //                 },
  //               ),
  //             ),
  //             h1,
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 2.w),
  //                   child: Text(
  //                     '${document.name}.$fileType',
  //                     style: R.textStyles.inter(
  //                       color: R.colors.black,
  //                       fontSize: 8.sp,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Get.bottomSheet(MoreOptionSheet(id: document.id)).then((value) => Get.back());
  //                     setState(() {});
  //                   },
  //                   child: Container(
  //                     height: 20,
  //                     width: 20,
  //                     decoration: BoxDecoration(
  //                       color: R.colors.transparent,
  //                     ),
  //                     child: Center(
  //                       child: Icon(
  //                         Icons.more_horiz_outlined,
  //                         color: R.colors.black,
  //                         size: 14,
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         );
  //       }),
  //     ),
  //   );
  // }

  Widget tile(String? name, AuthVm authVm) {
    return GestureDetector(
      onTap: () {
        authVm.docViewsList = authVm.familyDocsList
            .where((element) => element.familyMember == name)
            .toList();
        Get.toNamed(DocumentsView.route, arguments: {
          'title': name,
          'docType': docType,
          'familyMemberName': name,
          'documents': authVm.familyDocsList
              .where((element) => element.familyMember == name)
              .toList()
        })?.then((value) {
          if (authVm.familyDocsList.isEmpty) {
            Get.back();
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        margin: EdgeInsets.only(bottom: 1.5.h),
        decoration: BoxDecoration(
          color: R.colors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name ?? '',
                style: R.textStyles.inter(fontSize: 10.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: R.colors.black, size: 15)
          ],
        ),
      ),
    );
  }
}
