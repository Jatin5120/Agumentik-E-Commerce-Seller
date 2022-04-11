import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);

  User? get user => _user.value;
  set user(User? user) => _user.value = user;

  @override
  void onReady() {
    super.onReady();
  }
}
