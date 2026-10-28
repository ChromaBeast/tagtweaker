import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
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
      // Downscale/compress on device: avatars are shown at <=120dp, so a
      // full-resolution camera photo only wastes upload time and storage.
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) return;

      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;
      final oldPhotoUrl = user.photoURL;

      // Upload new image first so a failed upload never leaves the user
      // without an avatar.
      final ref = _storage.ref().child(
        'user_profiles/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await ref.putFile(
        File(image.path),
        SettableMetadata(
          contentType: 'image/jpeg',
          cacheControl: 'public, max-age=31536000, immutable',
        ),
      );
      final String downloadUrl = await ref.getDownloadURL();

      // Update Auth Profile
      await user.updatePhotoURL(downloadUrl);

      // Update Firestore User Document (merge to avoid doc.get() check)
      await _firestore.collection('users').doc(user.uid).set({
        'photoURL': downloadUrl,
      }, SetOptions(merge: true));

      // Delete the previous avatar, but only if it lives in this user's
      // own storage folder.
      if (oldPhotoUrl != null &&
          oldPhotoUrl.contains('firebasestorage.googleapis.com')) {
        try {
          final oldRef = _storage.refFromURL(oldPhotoUrl);
          if (oldRef.fullPath.startsWith('user_profiles/${user.uid}/')) {
            await oldRef.delete();
          }
        } catch (e) {
          debugPrint('Error deleting old image: $e');
        }
      }

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
        message: 'FAILED TO UPDATE PROFILE PICTURE',
      );
      debugPrint('updateProfilePicture error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await NeoLogoutDialog.show(
      context,
      onConfirm: () async {
        // Signs out of Google + Firebase and clears per-user caches.
        await Get.find<AuthenticationController>().signOut();
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
        message: 'Failed to update name',
      );
      debugPrint('updateDisplayName error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
