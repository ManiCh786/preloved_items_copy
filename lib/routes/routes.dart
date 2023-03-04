import 'package:get/get.dart';

import '../admin_screens/admin_screens.dart';
import '../admin_screens/screens/screens.dart';
import '../auth_screens/auth_screens.dart';
import '../auth_screens/forgot_password_screen.dart';
import '../bindings/bindings.dart';
import '../main_wrapper.dart';

var routes = [
  GetPage(
    name: '/splash',
    page: () => const CheckAuth(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/login',
    page: () => LoginScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/register',
    page: () => RegisterScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/home',
    bindings: [UsersHomeBindings()],
    page: () => const MainWrapper(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/adminDashboard',
    bindings: [HomeDrawerBindings()],
    page: () => AdminDashboard(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/addProfileInfo',
    page: () => AddProfileInfo(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/userManagement',
    page: () => UsersManagement(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/forgotPassword',
    page: () => ForgotPassword(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/addProductScreen',
    page: () => ProductForm(),
    transition: Transition.fadeIn,
  ),
];
