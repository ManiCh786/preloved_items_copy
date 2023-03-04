import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preloved_cloths/controllers/auth_controller.dart';

import '../utils/app_theme.dart';
import 'auth_screens/login_screen.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(
    GetMaterialApp(
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      initialRoute: "/splash",
      getPages: routes,
      
    ),
  );
}
