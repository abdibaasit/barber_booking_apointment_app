import 'package:get/get.dart';

class MainController extends GetxController {
  // Observable index for Bottom Navigation
  RxInt currentIndex = 0.obs;

  // Method to update index
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
