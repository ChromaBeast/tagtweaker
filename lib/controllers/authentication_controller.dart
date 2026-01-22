import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_tweaker/services/google_sign_in_service.dart';
import 'package:tag_tweaker/widgets/custom_snackbar.dart';

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

      final UserCredential userCredential = await GoogleSignInService.instance
          .signInWithGoogle();

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        CustomSnackbar.showSuccess(
          title: 'SUCCESS',
          message:
              'Signed in as ${firebaseUser.displayName ?? firebaseUser.email ?? 'User'}',
        );
      }
    } on GoogleSignInException catch (e) {
      CustomSnackbar.showError(title: 'ERROR', message: e.message);
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: e.message ?? 'Authentication failed',
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAnonymously() async {
    try {
      isLoading.value = true;
      await _auth.signInAnonymously();
      CustomSnackbar.showSuccess(
        title: 'SUCCESS',
        message: 'Signed in as Guest',
      );
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: e.message ?? 'Anonymous sign-in failed',
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'An unexpected error occurred: ${e.toString()}',
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
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'Sign out failed: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Whether the current user is a guest (anonymous)
  bool get isGuest => _auth.currentUser?.isAnonymous ?? false;

  /// Links the current anonymous account to Google credentials
  /// This preserves all user data while upgrading to a full account
  Future<void> linkGoogleAccount() async {
    try {
      isLoading.value = true;

      if (!isGuest) {
        CustomSnackbar.showError(
          title: 'ERROR',
          message: 'You are already signed in with an account',
        );
        return;
      }

      // Get Google credential
      final credential = await GoogleSignInService.instance
          .getGoogleCredential();

      // Link to current anonymous user
      await _auth.currentUser!.linkWithCredential(credential);

      CustomSnackbar.showSuccess(
        title: 'SUCCESS',
        message: 'Account upgraded successfully!',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        CustomSnackbar.showError(
          title: 'ERROR',
          message: 'This Google account is already linked to another user',
        );
      } else {
        CustomSnackbar.showError(
          title: 'ERROR',
          message: e.message ?? 'Failed to link account',
        );
      }
    } catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
