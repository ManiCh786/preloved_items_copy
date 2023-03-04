import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ReuseableButton extends StatelessWidget {
  ReuseableButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.bgColor = const Color(0xff141414),
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: MaterialButton(
        onPressed: onTap,
        minWidth: size.width * 0.9,
        height: size.height * 0.07,
        color: bgColor,
        child: Text(
          text,
          style:  TextStyle(
            color: Colors.white,
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
