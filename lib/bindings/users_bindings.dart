import 'package:get/get.dart';

import '../controllers/controller.dart';

class UsersHomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<CategoryController>(CategoryController());
    Get.put<ProductController>(ProductController());
    Get.put<ProductDetailsPageController>(ProductDetailsPageController());
    Get.put<CartController>(CartController());
  }
}
