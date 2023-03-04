import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import 'small_text_widget.dart';

class ExpandableTextWidget extends GetView<ProductDetailsPageController> {
  final String text;
  late String firsthalf;
  late String secondhalf;
  final int firstHalfLength;
  final TextStyle style;
  ExpandableTextWidget({
    Key? key,
    required this.text,
    this.firstHalfLength = 600,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return splitText();
  }

  splitText() {
    if (text.length < firstHalfLength) {
      firsthalf = text;
      secondhalf = "";
    } else {
      firsthalf = text.substring(0, firstHalfLength);
      secondhalf = text.substring(firstHalfLength, text.length);
    }

    return Container(
      child: secondhalf.isEmpty
          ? SmallText(
              text: firsthalf,
            )
          : Obx(
              () => Column(
                children: [
                  Text(
                    controller.flag.isTrue
                        ? (firsthalf + "...")
                        : (firsthalf + secondhalf),
                    style: style,
                  ),
                 
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          controller.flag.isTrue ? "show more" : "show less",
                          style: const TextStyle(color: Colors.black),
                        ),
                        controller.flag.isTrue
                            ? const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.arrow_drop_up,
                                color: Colors.black,
                              )
                      ],
                    ),
                    onTap: () {
                      controller.flagNotflag();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
