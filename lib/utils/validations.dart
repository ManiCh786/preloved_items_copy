import 'package:get/get.dart';

String? validateMobile(String? value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (value!.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  } else if (value.length < 10) {
    return 'Please enter valid mobile number';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return 'Required Password';
  } else if (value.length < 6) {
    return 'Required Greater then 6 digits Password';
  } else if (value.length > 15) {
    return 'Password Length exceeded';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return 'Required Email';
  } else if (value.length < 3) {
    return 'Required valid email';
  } else if (value.isNotEmpty && !(GetUtils.isEmail(value))) {
    return "Email is Invalid";
  }
  return null;
}

String? validateUserName(String? value) {
  if (value!.isEmpty) {
    return 'enter user name';
  }
  return null;
}
String? validateAField(String? value){
  if (value!.isEmpty) {
    return 'This Field Can\t Be Empty';
  }
  return null;
}
