import 'package:get/get.dart';

import '../controllers/controller.dart';

class HomeDrawerBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<DrawerHomeController>(DrawerHomeController());
    Get.put<CategoryController>(CategoryController());
    Get.put<ProductController>(ProductController());
    Get.put<CartController>(CartController());
  }
}
