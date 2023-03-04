import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preloved_cloths/controllers/auth_controller.dart';
import 'package:preloved_cloths/widget/small_text_widget.dart';

import '../utils/utils.dart';
import '../widget/widget.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Forgot Password ", color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height45),
              BigText(text: "Enter Your Email to reset password"),
              SizedBox(height: Dimensions.height45),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                controller: emailController,
              ),
              const SizedBox(height: 16),
              ReuseableButton(
                onTap: _submitForm,
                text: "Reset Password",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await AuthController.instance.auth
            .sendPasswordResetEmail(email: emailController.text);

        Fluttertoast.showToast(
            msg: "Password reset email sent to ${emailController.text}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
      } catch (e) {
        Fluttertoast.showToast(
            msg: " ${e.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Email is required to reset password !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }
}
