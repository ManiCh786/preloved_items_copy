import 'package:get/get.dart';

class ProductDetailsPageController extends GetxController {
  RxBool flag = true.obs;
  RxBool isBulk = false.obs;
  var count = 1.obs;

  set initialQuantity(int value) {
    count.value = value;
  }

  flagNotflag() {
    flag.value = !flag.value;
  }

  countPlus() {
    count++;
  }

  countMinus() {
    print("count value is $count");
    print("isBulk $isBulk");

    if (isBulk.value == true) {
      count.value != 50 ? count-- : null;
    } else {
      count.value != 1 ? count-- : null;
    }
  }
}
