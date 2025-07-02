import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../constant/enums.dart';
import '../../resources/resources.dart';
import '../../src/auth/model/new_document_model.dart';

class ImageSlider extends StatefulWidget {
  final int index;
  final List<NewDocumentModel?> sliderList;

  const ImageSlider({super.key, required this.index, required this.sliderList});

  @override
  ImageSliderState createState() => ImageSliderState();
}

class ImageSliderState extends State<ImageSlider> {
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.sliderList.removeWhere((element) =>
          (element?.documentUrl?.split(".").last == FileTypeEnum.jpg.name) ||
          (element?.documentUrl?.split(".").last == FileTypeEnum.jpeg.name) ||
          (element?.documentUrl?.split(".").last == FileTypeEnum.png.name));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Get.height * .2),
      child: CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            aspectRatio: 10 / 12,
            autoPlay: true,
            initialPage: widget.index,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.fastOutSlowIn,
            viewportFraction: 0.6,
            enlargeCenterPage: true,
          ),
          items: widget.sliderList.map((item) {
            final fileType = item?.documentUrl?.split(".").last;
            return GestureDetector(
                onTap: () {
                  // Get.to(() => ImageView(
                  //       path: item!,
                  //       isForSubmit: false,
                  //     ));
                },
                child: (fileType == FileTypeEnum.jpg.name ||
                        fileType == FileTypeEnum.jpeg.name ||
                        fileType == FileTypeEnum.png.name)
                    ? CachedNetworkImage(
                        imageUrl: item?.documentUrl ?? "",
                        imageBuilder: (context, image) {
                          return Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
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
                        errorWidget: (context, url, error) => Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: R.colors.primaryColor),
                          child: Icon(Icons.error, color: R.colors.white),
                        ),
                      )
                    : const SizedBox());
          }).toList()),
    );
  }
}
