import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/img/loginimg.png"))),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.paddingAll20,
                  right: Dimensions.paddingAll20),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello",
                    style: TextStyle(
                      fontSize: Dimensions.font50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in to your account",
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.height30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DynamicTextField(
                          textFieldController: emailFieldController,
                          validators: validateEmail,
                          hintText: "Enter Email",
                          isObscure: false,
                          keyoardtype: TextInputType.emailAddress,
                          icon: Icons.email,
                          iconColor: Colors.yellow,
                        ),
                        SizedBox(height: Dimensions.height20),
                        DynamicTextField(
                          textFieldController: passwordFieldController,
                          validators: validatePassword,
                          hintText: "Enter Password",
                          isObscure: true,
                          icon: Icons.password,
                          iconColor: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/forgotPassword");
                        },
                        child: Text(
                          " Forgot Password ?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height45),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  final email = emailFieldController.text;
                  final password = passwordFieldController.text;
                  AuthController.instance.login(email, password);
                } else {
                  AdvanceSnackBar(
                    textSize: Dimensions.font14,
                    bgColor: Colors.red,
                    message: 'Email and Password is required !',
                    mode: Mode.ADVANCE,
                    duration: Duration(seconds: 3),
                  ).show(context);
                }
              },
              child: Container(
                width: width * 0.5,
                height: height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  image: const DecorationImage(
                    image: AssetImage("assets/img/loginbtn.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: Dimensions.font36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Padding(
              padding: EdgeInsets.only(right: Dimensions.width10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Don\'t have and account? ",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: Dimensions.font20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: Text(
                      " Register ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
