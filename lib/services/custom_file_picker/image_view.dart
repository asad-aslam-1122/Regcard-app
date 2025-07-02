// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:sizer/sizer.dart';

class ImageView extends StatefulWidget {
  final File path;
  final bool isForSubmit;
  const ImageView({Key? key, required this.path, this.isForSubmit = true}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: R.colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
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
                    child: Icon(Icons.arrow_back_rounded, color: R.colors.primaryColor)),
              ),
              title: Text(
                "view",
                style: R.textStyles.inter(fontSize: 14.sp),
              )),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(widget.path), fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          bottomNavigationBar: widget.isForSubmit
              ? Container(
                  height: 7.h,
                  color: R.colors.white,
                  width: 100.w,
                  margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4),
                  child: AppButton(
                      buttonTitle: "submit",
                      // color: R.colors.themeColor,
                      // textColor: R.colors.white,e
                      onTap: () {
                        Get.back(result: true);
                      }),
                )
              // ignore: prefer_const_constructors
              : SizedBox(
                  height: 10,
                ),
        ),
      ),
    );
  }
}
