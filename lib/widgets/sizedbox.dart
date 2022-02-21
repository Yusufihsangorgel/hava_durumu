import 'package:flutter/material.dart';

class MySize extends StatelessWidget {
  late int size;

  MySize({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.toDouble(),
    );
  }
}
