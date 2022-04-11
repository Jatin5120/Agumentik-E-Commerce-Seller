import 'package:constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/screens.dart';
import 'controllers.dart';

class AuthController extends GetxController {
  final StorageController _storageController = Get.find();
  final UserDataController _userDataController = Get.find();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<GoogleSignInAccount?> _googleAccount = Rx<GoogleSignInAccount?>(null);

  final RxBool _isLoggedIn = false.obs;
  final RxBool _isNewUser = true.obs;

  GoogleSignInAccount? get googleAccount => _googleAccount.value;

  set googleAccount(GoogleSignInAccount? account) => _googleAccount.value = account;

  bool get isLoggedIn => _isLoggedIn.value;

  set isLoggedIn(bool isLoggedIn) => _isLoggedIn.value = isLoggedIn;

  bool get isNewUser => _isNewUser.value;

  set isNewUser(bool isNewUser) => _isNewUser.value = isNewUser;

  @override
  void onReady() {
    super.onReady();
    ever(_isNewUser, _handleNewUser);
    isNewUser = _storageController.isNewUser;
    ever(_isLoggedIn, _handleLogin);
    isLoggedIn = _storageController.isLoggedIn;

    _userDataController.user = _firebaseAuth.currentUser;

    _firebaseAuth.authStateChanges().listen((user) {
      _userDataController.user = user;
      isLoggedIn = user != null;
    });

    "isLoggedIn --> $isLoggedIn".log();
    "isNewUser --> $isNewUser".log();
  }

  // -------------------- State management Methods --------------------

  void _handleNewUser(bool isFirstTime) {
    if (isFirstTime) {
      if (Get.currentRoute != WelcomeScreen.routeName) {
        Get.offAllNamed(WelcomeScreen.routeName);
      }
    } else {
      _handleLogin(isLoggedIn);
    }
    _storageController.writeNewUser(isFirstTime);
  }

  void _handleLogin(bool loggedIn) {
    if (loggedIn) {
      _userDataController.user?.log();
      if (Get.currentRoute != DashboardWrapper.routeName) {
        Get.offAllNamed(DashboardWrapper.routeName);
      }
    } else {
      if (Get.currentRoute != SignUpScreen.routeName) {
        Get.offAllNamed(SignUpScreen.routeName);
      }
    }
    _storageController.writeLoggedIn(loggedIn);
  }

  // -------------------- Authentication Methods --------------------

  void login() {
    isLoggedIn = true;
    "Login = true".log();
  }

  void logout() {
    isLoggedIn = false;
    "Login = false".log();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _googleAccount.value = await _googleSignIn.signOut();
    logout();
  }
}
