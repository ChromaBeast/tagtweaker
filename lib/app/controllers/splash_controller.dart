import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_tweaker/pages/ui/ui_screen.dart';
import 'package:tag_tweaker/pages/auth/login_page.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (isLoggedIn) {
      Get.offAll(() => UIPage(selectedIndex: 0));
    } else {
      Get.offAll(() => const LoginPage());
    }
  }
}
