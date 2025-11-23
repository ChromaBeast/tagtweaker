import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_tweaker/services/google_sign_in_service.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var user = Rxn<User>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((u) => user.value = u);
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final UserCredential userCredential =
          await GoogleSignInService.instance.signInWithGoogle();

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        Get.snackbar(
          'Success',
          'Signed in as ${firebaseUser.displayName ?? firebaseUser.email ?? 'User'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on GoogleSignInException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Authentication failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAnonymously() async {
    try {
      isLoading.value = true;
      await _auth.signInAnonymously();
      Get.snackbar(
        'Success',
        'Signed in as Guest',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Anonymous sign-in failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      if (_auth.currentUser != null) {
        if (_auth.currentUser!.isAnonymous) {
          await _auth.currentUser!.delete();
        } else {
          await GoogleSignInService.instance.signOut();
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign out failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
