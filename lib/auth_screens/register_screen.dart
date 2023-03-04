import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => MainWrapper(),
                  //     ));
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
            SizedBox(height: Dimensions.height10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),
            // GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => MainWrapper(),
            //           ));
            //     },
            //     child: Container(
            //       width: width * 0.7,
            //       height: height * 0.06,
            //       decoration: BoxDecoration(
            //         // borderRadius: BorderRadius.circular(Dimensions.radius30),
            //         image: const DecorationImage(
            //           image: AssetImage("assets/img/loginbtn.png"),
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       child: Padding(
            //           padding: EdgeInsets.all(5),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 width: width * 0.2,
            //                 height: height,
            //                 decoration: const BoxDecoration(
            //                   // color: Colors.white,
            //                   // borderRadius: BorderRadius.circular(Dimensions.radius30),
            //                   image: DecorationImage(
            //                     image: AssetImage("assets/img/g.png"),
            //                     // fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //               Center(
            //                 child: Text(
            //                   "Login with Google",
            //                   style: TextStyle(
            //                       fontSize: Dimensions.font26,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.white),
            //                 ),
            //               ),
            //             ],
            //           )),
            //     )),
            // SizedBox(height: width * 0.1),
          ],
        ),
      ),
    );
  }
}
