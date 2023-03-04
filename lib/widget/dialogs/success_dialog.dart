import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key, required this.message, required this.onPressed});
  final String message;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              message,
              style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onPressed(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(80, 40),
                  ),
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
