  import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class UploadinImageDialog extends StatelessWidget {
  const UploadinImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: Dimensions.height100 + Dimensions.height45,
            width: Dimensions.height100 + Dimensions.height45,
            child: const Center(
              child: Text(
                'Uploading Image . . .',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        );
  }
}