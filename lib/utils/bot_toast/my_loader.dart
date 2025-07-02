import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../resources/resources.dart';

class MyLoader extends StatefulWidget {
  final Color color;

  const MyLoader({Key? key, this.color = Colors.red}) : super(key: key);

  @override
  MyLoaderState createState() => MyLoaderState();
}

class MyLoaderState extends State<MyLoader> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: R.colors.primaryColor.withOpacity(.05),
      child: Center(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: SpinKitSpinningLines(
              color: R.colors.primaryColor,
            )),
      ),
    );
  }
}
