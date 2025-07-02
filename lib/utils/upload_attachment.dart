// import 'dart:developer';
// import 'dart:io';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:serve_u/utils/localization_extension.dart';
// import 'package:sizer/sizer.dart';
// import '../../../../../resources/resources.dart';
// import '../../../../../utils/heights_widths.dart';
//
// class UploadAttachment extends StatefulWidget {
//   final List<PlatformFile> portfolioList;
//   const UploadAttachment({super.key,required this.portfolioList});
//
//   @override
//   State<UploadAttachment> createState() => _UploadAttachmentState();
// }
//
// class _UploadAttachmentState extends State<UploadAttachment> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         uploadButtonWidget(onPressed: () async {
//           FilePickerResult? result = await FilePicker.platform.pickFiles(
//             type: FileType.custom,
//             allowMultiple: true,
//             allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//           );
//
//           if (result != null) {
//             List<PlatformFile> list = result.files
//                 .map((e) =>
//                 PlatformFile(name: e.name, size: e.size, path: e.path))
//                 .toList();
//
//             widget.portfolioList.addAll(list.reversed);
//             setState(() {
//
//             });
//           } else {
//             log("User canceled the picker");
//           }
//         }),
//         h2,
//         if (widget.portfolioList.isNotEmpty)
//           ...List.generate(widget.portfolioList.length, (index) {
//             PlatformFile file = widget.portfolioList[index];
//             return pickedFileWidget(
//                 name: file.name,
//                 extension: file.extension ?? "",
//                 list: widget.portfolioList,
//                 path: file.path ?? "",
//                 index: index);
//           }),
//       ],
//     );
//   }
//
//
//   Widget imageWidget(String extension, String path) {
//     switch (extension) {
//       case "png":
//       case "jpg":
//       case "jpeg":
//         return Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                     image: FileImage(File(path)), fit: BoxFit.cover)));
//       case "pdf":
//         return Image.asset(
//           width: 40,
//           height: 40,
//           R.images.pdfIcon,
//         );
//       case "doc":
//       case "docx":
//         return Image.asset(width: 40, height: 40, R.images.docIcon);
//       default:
//         const SizedBox();
//         return const SizedBox();
//     }
//   }
//
//   pickedFileWidget(
//       {required String name,
//         required String extension,
//         required String path,
//         required List<PlatformFile> list,
//         required int index}) {
//     double progress = 1;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           imageWidget(extension, path),
//           w3,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         name,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: R.textStyles.gilroySemiBold(
//                             fontSize: 12.sp, color: R.colors.primaryColor),
//                       ),
//                     ),
//                     w2,
//                     Text(
//                       "uploaded_successfully".L(),
//                       style: R.textStyles
//                           .gilroyMedium(
//                           fontSize: 8.sp, color: R.colors.primaryColor)
//                           .copyWith(fontStyle: FontStyle.italic),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "100%-${timeago.format(DateTime.now())}",
//                   style: R.textStyles.gilroyMedium(fontSize: 10.sp,color: R.colors.primaryTextColor),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: LinearPercentIndicator(
//                           lineHeight: 6,
//                           percent: progress,
//                           animationDuration: 1,
//                           padding: EdgeInsets.zero,
//                           barRadius: const Radius.circular(10),
//                           backgroundColor: R.colors.lightGrey,
//                           progressColor: R.colors.lightGrey),
//                     ),
//                     w2,
//                     GestureDetector(
//                       onTap: () {
//                         list.removeAt(index);
//                         setState(() {});
//                       },
//                       child: Icon(
//                         CupertinoIcons.clear_circled_solid,
//                         color: R.colors.primaryColor,
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget uploadButtonWidget({required VoidCallback onPressed}) {
//     return DottedBorder(
//         color: R.colors.primaryColor,
//         dashPattern: const [7, 8],
//         radius: const Radius.circular(12),
//         padding: EdgeInsets.zero,
//         borderType: BorderType.RRect,
//         borderPadding: const EdgeInsets.all(2),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4),
//           child: TextButton(
//             onPressed: onPressed,
//             style: TextButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   R.images.uploadIcon,
//                   width: 18,
//                   height: 18,
//                 ),
//                 w2,
//                 Text(
//                   "upload".L(),
//                   style: R.textStyles.gilroyMedium(
//                       fontSize: 12.sp, color: R.colors.primaryColor),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
//
// }
