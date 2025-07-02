import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/utils/image_preview.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/enums.dart';
import '../../../../../resources/resources.dart';
import '../../../../../services/custom_file_picker/pdf_view_widget.dart';
import '../../../../../utils/app_bars.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../auth/view/complete_profile/widgets/upload_doc_sheet.dart';
import '../../explore/view/widgets/more_sheet.dart';

class DocumentsView extends StatefulWidget {
  static String route = '/document_view';

  const DocumentsView({Key? key}) : super(key: key);

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  bool isShowDoc = true;
  DocumentType? docType;
  String? appBarTitle;
  String? familyMemberName;
  // List<NewDocumentModel> docList= [];

  @override
  void initState() {
    docType = Get.arguments['docType'];
    // docList = Get.arguments['documents'];
    familyMemberName = Get.arguments['familyMemberName'];
    appBarTitle = Get.arguments['title'];

    if (docType == DocumentType.familyDocuments) {
      isShowDoc = false;
    }
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
          title: appBarTitle,
          titleCenter: true,
          isTranslated: false,
          icon: Icons.arrow_back_ios_sharp,
          actions: [
            InkWell(
              onTap: () async {
                // if(docType == DocumentType.familyDocuments) {
                //   Get.toNamed(AddDocumentsView.route, arguments: {'adDoc': false, 'docType' : docType, 'uploadedDocList' : (value) {
                //     docList  = List.from(value.where((e) => e.documentType == docType).toList());
                //   }});
                // }else{
                await Get.bottomSheet(UploadDocumentSheet(
                  isDocTypeSelected: true,
                  docType: docType,
                  familyMemberName: familyMemberName,
                  // uploadedDocList: (value) {
                  //   docList  = List.from(value.where((e) => e.documentType == docType).toList());
                  // },
                ));
                setState(() {});
                // }
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
          child: documentsView(authVm),
        ),
      ),
    );
  }

  // Widget tile(String? name) {
  //   return GestureDetector(
  //
  //     onTap: () {
  //       Get.toNamed(FamilyMemberView.route,arguments: {
  //         'name' : name,
  //         'documents':docList.where((element) => element.familyMember == name).toList()
  //       });
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
  //       margin: EdgeInsets.only(bottom: 1.5.h),
  //       decoration: BoxDecoration(
  //         color: R.colors.greyBackgroundColor,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(name ??'' , style: R.textStyles.inter(fontSize: 10.sp)),
  //           Icon(Icons.arrow_forward_ios_rounded, color: R.colors.black, size: 15)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget documentsView(AuthVm authVm) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
          color: R.colors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
        shrinkWrap: true,
        children: List.generate(authVm.docViewsList.length, (index) {
          final document = authVm.docViewsList[index];
          final fileType = document.documentUrl?.split(".").last;
          print("file type : $fileType");
          return Column(
            children: [
              // InkWell(
              //   onTap: () async {
              //       if ( fileType== FileTypeEnum.jpg.name ||
              //           fileType == FileTypeEnum.jpeg.name ||
              //           fileType == FileTypeEnum.png.name) {
              //         Get.dialog(
              //           ImageSlider(
              //             index: index,
              //             sliderList: listOfDoc.map((e) => e.file).toList()
              //             // id == 0 ? authVm.myDocuments.map((e) => e.file).toList() : authVm.additionalDocuments.map((e) => e.file).toList(),
              //           ),
              //         );
              //       } else if (fileType == FileTypeEnum.pdf.name) {
              //         Get.to(
              //           () => PDFViewWidget(
              //             path: document?.file!.path??"",
              //             isForSubmit: false,
              //           ),
              //         );
              //       } else {
              //         await OpenFilex.open(document?.file!.path);
              //       }
              //
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
              //     width: Get.width * .40,
              //     height: 40.w,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage(
              //           (fileType == FileTypeEnum.jpg.name ||
              //                   fileType == FileTypeEnum.jpeg.name ||
              //                   fileType == FileTypeEnum.png.name
              //               ? R.images.image
              //               : fileType == FileTypeEnum.pdf.name
              //                   ? R.images.pdf
              //                   : (fileType == FileTypeEnum.xls.name ||
              //                           fileType == FileTypeEnum.xlsx.name)
              //                       ? R.images.xls
              //                       : R.images.doc),
              //         ),
              //         fit: BoxFit.cover,
              //       ),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              // if (fileType == FileTypeEnum.jpg.name ||
              //     fileType == FileTypeEnum.jpeg.name ||
              //     fileType == FileTypeEnum.png.name)
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: document.documentUrl ?? "",
                  imageBuilder: (context, image) {
                    return GestureDetector(
                      onTap: () async {
                        if (fileType != null) {
                          if (fileType == FileTypeEnum.jpg.name ||
                              fileType == FileTypeEnum.jpeg.name ||
                              fileType == FileTypeEnum.png.name) {
                            Get.to(() => ImageViewScreen(imageProvider: image));
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
                                      url: document.documentUrl,
                                    ));
                              } else {
                                await OpenFilex.open(
                                    document.documentUrl ?? "");
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
              h1,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      '${document.name}.$fileType',
                      style: R.textStyles.inter(
                        color: R.colors.black,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(MoreOptionSheet(
                        id: document.id,
                        docType: docType,
                        familyMemberName: familyMemberName,
                        documentUrl: document.documentUrl,
                        documentName: document.name,
                      )).then((value) {
                        if (authVm.docViewsList.isEmpty) {
                          Get.back();
                        }
                      });
                      setState(() {});
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
    );
    //   Wrap(
    //   spacing: 18,
    //   children: List.generate(
    //     listOfDoc.length,
    //     // id == 0
    //     //     ? authVm.myDocuments.length
    //     //     : authVm.additionalDocuments.length,
    //     (index) {
    //       final document = listOfDoc[index];
    //       // id == 0
    //       //     ? authVm.myDocuments[index]
    //       //         : authVm.additionalDocuments[index];
    //       // final fileType = document.file!.path.split('.').last;
    //       return Stack(
    //         alignment: AlignmentDirectional.bottomEnd,
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               DisplayImage(
    //                 imageUrl: listOfDoc[index].documentUrl,
    //                 height: 50,
    //                 width: 50,
    //               ),
    //               //
    //               // InkWell(
    //               //   onTap: () async {
    //               //     if (fileType != null) {
    //               //       if (fileType == FileTypeEnum.jpg.name ||
    //               //           fileType == FileTypeEnum.jpeg.name ||
    //               //           fileType == FileTypeEnum.png.name) {
    //               //         Get.dialog(
    //               //           ImageSlider(
    //               //             index: index,
    //               //             sliderList: listOfDoc.map((e) => e.file).toList()
    //               //             // id == 0 ? authVm.myDocuments.map((e) => e.file).toList() : authVm.additionalDocuments.map((e) => e.file).toList(),
    //               //           ),
    //               //         );
    //               //       } else if (fileType == FileTypeEnum.pdf.name) {
    //               //         Get.to(
    //               //           () => PDFViewWidget(
    //               //             path: document?.file!.path??"",
    //               //             isForSubmit: false,
    //               //           ),
    //               //         );
    //               //       } else {
    //               //         await OpenFilex.open(document?.file!.path);
    //               //       }
    //               //     }
    //               //   },
    //               //   child: Container(
    //               //     margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
    //               //     width: Get.width * .40,
    //               //     height: 40.w,
    //               //     decoration: BoxDecoration(
    //               //       image: DecorationImage(
    //               //         image: AssetImage(
    //               //           (fileType == FileTypeEnum.jpg.name ||
    //               //                   fileType == FileTypeEnum.jpeg.name ||
    //               //                   fileType == FileTypeEnum.png.name
    //               //               ? R.images.image
    //               //               : fileType == FileTypeEnum.pdf.name
    //               //                   ? R.images.pdf
    //               //                   : (fileType == FileTypeEnum.xls.name ||
    //               //                           fileType == FileTypeEnum.xlsx.name)
    //               //                       ? R.images.xls
    //               //                       : R.images.doc),
    //               //         ),
    //               //         fit: BoxFit.cover,
    //               //       ),
    //               //       borderRadius: BorderRadius.circular(8),
    //               //     ),
    //               //   ),
    //               // ),
    //               h1,
    //               Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 2.w),
    //                 child: Text(
    //                   '${document?.name}' ?? "",
    //                   style: R.textStyles.inter(
    //                     color: R.colors.black,
    //                     fontSize: 8.sp,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //           GestureDetector(
    //             onTap: () {
    //               setState(() {
    //                 Get.bottomSheet(MoreOptionSheet());
    //               });
    //             },
    //             child: Container(
    //               height: 20,
    //               width: 20,
    //               decoration: BoxDecoration(
    //                 color: R.colors.transparent,
    //               ),
    //               child: Center(
    //                 child: Icon(
    //                   Icons.more_horiz_outlined,
    //                   color: R.colors.black,
    //                   size: 14,
    //                 ),
    //               ),
    //             ),
    //           )
    //         ],
    //       );
    //     },
    //   ),
    // );
  }
}
