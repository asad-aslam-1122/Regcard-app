import 'package:flutter/material.dart';

import '../resources/resources.dart';

class SafeAreaWidget extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool? bottom;
  final bool? top;
  const SafeAreaWidget({Key? key, required this.child, this.backgroundColor, this.bottom, this.top}) : super(key: key);

  @override
  State<SafeAreaWidget> createState() => _SafeAreaWidgetState();
}

class _SafeAreaWidgetState extends State<SafeAreaWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: widget.backgroundColor ?? R.colors.white,
        child: SafeArea(bottom: widget.bottom ?? true, top: widget.top ?? false, child: widget.child));
  }
}
