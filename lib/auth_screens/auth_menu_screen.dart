import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:preloved_cloths/controllers/auth_controller.dart';

import '../admin_screens/admin_screens.dart';
import '../main_wrapper.dart';
import '../utils/utils.dart';
import 'login_screen.dart';
import 'profile_info_screen.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({Key? key}) : super(key: key);
  CheckIfUserLogin() async {
    String? userRole;
    String? userName;
    String? status;

    if (FirebaseAuth.instance.currentUser != null) {
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;

      await AuthController.instance.userCollectionRef
          .doc(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          userRole = doc.data()!['accountType'];
          userName = doc.data()!['fName'];
          status = doc.data()!['status'];
          if (userRole == "user" && status == "active" && userName != "") {
            Get.offAllNamed("/home");
          } else if (userRole == "user" ||
              userRole == "admin" && status == "active" && userName == "") {
            Get.offAllNamed("/addProfileInfo");
          } else if (status == "blocked") {
            AuthController.instance.logout();
            Fluttertoast.showToast(
                msg: "You are blocked By Admin Contact Admin !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: Dimensions.font16);
          } else if (userRole == "admin" && status == "active") {
            Get.offAllNamed("/adminDashboard");
          }
        }
      });
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(seconds: 1)).then((value) {
      CheckIfUserLogin();
    });

    // Future.delayed(Duration(seconds: 2)).then((value) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => LoginScreen(),
    //       ));
    // });
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              'assets/img/logoapp.png',
              height: height * .30,
              width: width * 0.60,
            ),
          ),
        ],
      )),
    );
  }

  // checkRole(DocumentSnapshot snapshot, bool isEmpty) {
  //   if (!isEmpty) {
  //     if (snapshot['accountType'] == "admin") {
  //       Get.offAll(Dashboard());
  //     } else {
  //       Get.offAll(MainWrapper());
  //     }
  //   } else {
  //     Get.offAll(AddProfileInfo());
  //   }
  // }
}
