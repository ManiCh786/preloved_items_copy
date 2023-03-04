import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class DynamicTextField extends StatelessWidget {
  const DynamicTextField(
      {Key? key,
      required this.textFieldController,
      required this.validators,
      this.isObscure = false,
      this.obscureChar = "*",
      this.hintText = "Enter Hint Text",
      this.keyoardtype = TextInputType.text,
      required this.icon,
      required this.iconColor,
      this.iconSize = 24,
      this.minLines = 1})
      : super(key: key);
  final TextEditingController textFieldController;

  final String? Function(String?)? validators;
  final bool isObscure;
  final String obscureChar;
  final String hintText;
  final TextInputType keyoardtype;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final int minLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 7,
              offset: const Offset(1, 1),
              color: Colors.grey.withOpacity(0.2),
            ),
          ]),
      child: TextFormField(
        enableInteractiveSelection: true,
        minLines: minLines,
        maxLines: minLines,
        controller: textFieldController,
        validator: validators,
        obscureText: isObscure,
        keyboardType: keyoardtype,
        obscuringCharacter: obscureChar,
        autocorrect: false,
        style: TextStyle(fontSize: Dimensions.font16, color: Colors.black),
        autovalidateMode: AutovalidateMode.onUserInteraction,

        // autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: iconSize),
          prefixIconColor: iconColor,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: Dimensions.font20),
          errorStyle: TextStyle(
              color: Colors.red,
              fontSize: Dimensions.font14,
              fontFamily: 'Inter-ExtraBold'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
