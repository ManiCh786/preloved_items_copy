import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class ConfirmationDialog {
  static void showConfirmationDialog(
    String title,
    String message,
    Function onConfirm,
    Color bgColorConfirm,
    Color bgColorCancel,
    Color fontColor,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message, style: TextStyle(fontSize: Dimensions.font16)),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: fontColor)),
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(backgroundColor: bgColorCancel),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: bgColorConfirm),
                child: Text('Confirm', style: TextStyle(color: fontColor)),
                onPressed: () {
                  onConfirm();
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
