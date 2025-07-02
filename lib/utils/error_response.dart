import 'package:flutter/material.dart';

String errorLog(Map? r, String? m) {
  List errors = [];
  String errorString = '';
  debugPrint("this is model checking $r");

  if (r != null) {
    Map err = r;
    err.forEach((key, value) {
      errors = value;
    });

    if (errors.isNotEmpty) {
      errorString = errors.join("\n");
    }
  } else {
    errorString = m.toString();
  }

  return errorString;
}
