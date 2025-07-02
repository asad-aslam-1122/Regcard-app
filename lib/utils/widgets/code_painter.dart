import 'dart:typed_data';
import "dart:ui" as ui;

import 'package:flutter/material.dart';

class CodePainter extends CustomPainter {
  CodePainter({required this.qrImage, this.margin = 10}) {
    _paint = Paint()
      ..color = Colors.white
      ..style = ui.PaintingStyle.fill;
  }
  final double margin;
  final ui.Image qrImage;
  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromPoints(
      Offset.zero,
      Offset(size.width, size.height),
    );
    canvas
      ..drawRect(rect, _paint)
      ..drawImage(qrImage, Offset(margin, margin), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  ui.Picture toPicture(double size) {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    paint(canvas, Size(size, size));
    return recorder.endRecording();
  }

  Future<ui.Image> toImage(
    double size, {
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    return Future<ui.Image>.value(
      toPicture(size).toImage(size.toInt(), size.toInt()),
    );
  }

  Future<ByteData?> toImageData(
    double originalSize, {
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final ui.Image image = await toImage(
      originalSize + margin * 2,
      format: format,
    );
    return image.toByteData(format: format);
  }
}
