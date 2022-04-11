import 'package:constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageController extends GetxController {
  final GetStorage _storage = GetStorage('SellerBox');

  final RxBool _isLoggedIn = false.obs;
  final RxBool _isNewUser = true.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  set isLoggedIn(bool isLoggedIn) => _isLoggedIn.value = isLoggedIn;

  bool get isNewUser => _isNewUser.value;

  set isNewUser(bool isNewUser) => _isNewUser.value = isNewUser;

  @override
  void onReady() {
    super.onReady();
    isLoggedIn = _getLoggedIn;
    isNewUser = _getNewUser;
  }

  bool get _getLoggedIn => _storage.read(StorageKeys.isLoggedIn) ?? false;

  bool get _getNewUser => _storage.read(StorageKeys.isNewUser) ?? true;

  Future<void> writeLoggedIn(bool value) async => await _storage.write(StorageKeys.isLoggedIn, value);

  Future<void> writeNewUser(bool value) async => await _storage.write(StorageKeys.isNewUser, value);
}
