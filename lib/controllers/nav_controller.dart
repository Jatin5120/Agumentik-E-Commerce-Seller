import 'package:get/get.dart';

class NavController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  set currentIndex(int currentIndex) => _currentIndex.value = currentIndex;

  @override
  void onReady() {
    super.onReady();
  }
}
