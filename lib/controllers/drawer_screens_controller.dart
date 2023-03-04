import 'package:get/get.dart';

class DrawerHomeController extends GetxController {
  var drawerCurrentIndex = 0.obs;

  updateNavCurrentIndex(int index) {
    drawerCurrentIndex.value = index;
  }
}