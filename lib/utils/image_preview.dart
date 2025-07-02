import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../resources/resources.dart';

class ImageViewScreen extends StatelessWidget {
  final ImageProvider imageProvider;
  const ImageViewScreen({Key? key, required this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.white,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: imageProvider,
            minScale: PhotoViewComputedScale.contained,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 5),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: R.colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
