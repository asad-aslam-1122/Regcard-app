import 'dart:io';
import 'dart:math' as m;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

extension IntegerToBoolExtension on int? {
  bool? toBool() {
    if (this == null) {
      return null;
    }
    return this == 1 ? true : (this == 0 ? false : null);
  }
}

extension BoolToIntegerExtension on bool? {
  int? toInt() {
    if (this == null) {
      return null;
    }
    return this == true ? 1 : 0;
  }
}

extension FileSize on int {
  String getFileSizeString() {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (this == 0) return '0${suffixes[0]}';
    var i = ((m.log(this) / m.log(1024)).floor());
    return ((this / m.pow(1024, i)).toStringAsFixed(0)) + suffixes[i];
  }
}

extension UrlToFile on String {
  Future<File> downloadFile() async {
    try {
      final response = await http.get(Uri.parse(this));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = Uri.parse(this).pathSegments.last;
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to load file from URL');
      }
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }
}

extension FileDetails on File {
  Future<Map<String, dynamic>> getFileDetails() async {
    try {
      String fileName = this.uri.pathSegments.last;
      String fileExtension = fileName.split('.').last;
      int fileSize = await this.length();
      return {'name': fileName, 'extension': fileExtension, 'size': fileSize};
    } catch (e) {
      throw Exception('Error retrieving file details: $e');
    }
  }
}
