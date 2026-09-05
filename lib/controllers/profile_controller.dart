import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tag_tweaker/pages/auth/login_page.dart';
import 'package:tag_tweaker/widgets/custom_snackbar.dart';
import 'package:tag_tweaker/widgets/profile_dialogs.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    _auth.userChanges().listen((user) {
      currentUser.value = user;
    });
  }

  Future<void> updateProfilePicture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;

      // Delete old image if it exists and is hosted on Firebase
      if (user.photoURL != null &&
          user.photoURL!.contains('firebasestorage.googleapis.com')) {
        try {
          await _storage.refFromURL(user.photoURL!).delete();
        } catch (e) {
          debugPrint('Error deleting old image: $e');
        }
      }

      // Upload new image
      final ref = _storage.ref().child(
        'user_profiles/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await ref.putFile(File(image.path));
      final String downloadUrl = await ref.getDownloadURL();

      // Update Auth Profile
      await user.updatePhotoURL(downloadUrl);

      // Update Firestore User Document (merge to avoid doc.get() check)
      await _firestore.collection('users').doc(user.uid).set({
        'photoURL': downloadUrl,
      }, SetOptions(merge: true));

      // Force refresh user to update UI
      await user.reload();
      currentUser.value = _auth.currentUser;

      CustomSnackbar.showSuccess(
        title: 'SUCCESS',
        message: 'PROFILE PICTURE UPDATED',
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'FAILED TO UPDATE PROFILE: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await NeoLogoutDialog.show(
      context,
      onConfirm: () async {
        await _auth.signOut();
        Get.offAll(() => const LoginPage());
      },
    );
  }

  Future<void> updateDisplayName(BuildContext context) async {
    final currentName = currentUser.value?.displayName ?? '';
    final newName = await NeoEditNameDialog.show(context, initialName: currentName);

    if (newName == null) return;

    if (newName.isEmpty) {
      CustomSnackbar.showError(title: 'ERROR', message: 'Name cannot be empty');
      return;
    }

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      await user.updateDisplayName(newName);

      // Update Firestore using merge to eliminate unnecessary get() call
      await _firestore.collection('users').doc(user.uid).set({
        'displayName': newName,
      }, SetOptions(merge: true));

      await user.reload();
      currentUser.value = _auth.currentUser;
      currentUser.refresh();

      CustomSnackbar.showSuccess(
        title: 'SUCCESS',
        message: 'Name updated successfully',
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'Failed to update name: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
