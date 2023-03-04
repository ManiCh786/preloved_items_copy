import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:preloved_cloths/auth_screens/auth_screens.dart';
import 'package:preloved_cloths/controllers/auth_controller.dart';

import '../main_wrapper.dart';
import '../utils/dimensions.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      image: AssetImage("assets/img/signup.png"))),
              child: Column(
                children: [
                  SizedBox(height: height * 0.15),
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: (Dimensions.radius30 * 2),
                    backgroundImage:
                        const AssetImage("assets/img/profile1.png"),
                  ),
                ],
              ),
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
                    "Welcome",
                    style: TextStyle(
                      fontSize: Dimensions.font50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Get registered here",
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.height45),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DynamicTextField(
                          textFieldController: emailFieldController,
                          validators: validateEmail,
                          hintText: "Enter Email",
                          isObscure: false,
                          icon: Icons.email,
                          iconColor: Colors.deepOrange,
                          keyoardtype: TextInputType.emailAddress,
                        ),
                        SizedBox(height: Dimensions.height20),
                        DynamicTextField(
                          textFieldController: passwordFieldController,
                          validators: validatePassword,
                          hintText: "Enter Password",
                          isObscure: true,
                          icon: Icons.password,
                          iconColor: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height45),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  final email = emailFieldController.text.trim();
                  final password = passwordFieldController.text.trim();
                  AuthController.instance.register(email, password);
                } else {
                  const AdvanceSnackBar(
                    textSize: 14.0,
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
                    "Sign up",
                    style: TextStyle(
                        fontSize: Dimensions.font36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height30),
            Padding(
              padding: EdgeInsets.only(right: Dimensions.width10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Already have an account ? ",
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
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: Text(
                      " Login ",
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
