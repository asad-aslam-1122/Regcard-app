import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/image_preview.dart';

import '../../resources/resources.dart';

class DisplayImage extends StatelessWidget {
  final String? imageUrl;
  final double? width, height, borderRadius;
  final bool? isCircle;
  final bool? hasMargin;
  final bool? hasBorder;
  final bool? isProfileImage;
  final double? borderWidth;
  final Color? borderColor;
  final bool? isAllowOnTap;
  final BoxFit? fit;
  final ValueChanged<ImageProvider>? image;
  const DisplayImage({
    super.key,
    this.imageUrl,
    this.width = 30,
    this.borderRadius = 10,
    this.height = 30,
    this.borderWidth,
    this.borderColor,
    this.image,
    this.isCircle = false,
    this.hasMargin = true,
    this.hasBorder = false,
    this.isProfileImage = true,
    this.isAllowOnTap = true,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      imageBuilder: (context, imageProvider) {
        if (image != null) {
          image!(imageProvider);
        }
        return GestureDetector(
          onTap: isAllowOnTap == true
              ? () {
                  Get.to(() => ImageViewScreen(imageProvider: imageProvider));
                }
              : null,
          child: Container(
            width: width,
            height: height,
            margin:
                hasMargin! ? const EdgeInsets.only(right: 10) : EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius:
                  isCircle! ? null : BorderRadius.circular(borderRadius ?? 10),
              shape: isCircle! ? BoxShape.circle : BoxShape.rectangle,
              color: hasBorder! ? R.colors.white : null,
              border: hasBorder!
                  ? Border.all(
                      color: borderColor ?? R.colors.primaryColor,
                      width: borderWidth ?? 1,
                    )
                  : null,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
        width: width,
        height: height,
        margin: hasMargin! ? const EdgeInsets.only(right: 10) : EdgeInsets.zero,
        child: SpinKitPulse(
          color: R.colors.primaryColor,
        ),
      ),
      errorWidget: (context, url, error) => Container(
          margin:
              hasMargin! ? const EdgeInsets.only(right: 10) : EdgeInsets.zero,
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: isCircle! ? null : BorderRadius.circular(10),
            shape: isCircle! ? BoxShape.circle : BoxShape.rectangle,
            color: hasBorder! ? R.colors.white : null,
            border: hasBorder!
                ? Border.all(
                    color: borderColor ?? R.colors.primaryColor,
                    width: borderWidth ?? 1,
                  )
                : null,
          ),
          child: isProfileImage!
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: GestureDetector(
                    onTap: isAllowOnTap == true
                        ? () {
                            ZBotToast.showToastError(
                                message: "No profile picture attached");
                          }
                        : null,
                    child: Image.asset(
                      R.images.user,
                      // scale: 1,
                    ),
                  ),
                )
              : const Icon(Icons.error)),
    );
  }
}
