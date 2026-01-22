import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tag_tweaker/pages/auth/login_page.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_snackbar.dart';

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

      // Update Firestore User Document
      await _firestore.collection('users').doc(user.uid).update({
        'photoURL': downloadUrl,
      });

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
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: NeoBrutalTheme.brutalBox(
            color: NeoBrutalColors.white,
            borderColor: NeoBrutalColors.black,
            shadowColor: NeoBrutalColors.black,
            shadowOffset: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LOGOUT?',
                style: NeoBrutalTheme.heading.copyWith(
                  fontSize: 20,
                  color: NeoBrutalColors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.white,
                        borderColor: NeoBrutalColors.black,
                        shadowColor: NeoBrutalColors.black,
                        shadowOffset: 2,
                      ),
                      child: Text(
                        'CANCEL',
                        style: NeoBrutalTheme.heading.copyWith(
                          fontSize: 14,
                          color: NeoBrutalColors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context); // Close dialog
                      await _auth.signOut();
                      Get.offAll(() => const LoginPage());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.lime,
                        borderColor: NeoBrutalColors.black,
                        shadowColor: NeoBrutalColors.black,
                        shadowOffset: 2,
                      ),
                      child: Text(
                        'LOGOUT',
                        style: NeoBrutalTheme.heading.copyWith(
                          fontSize: 14,
                          color: NeoBrutalColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateDisplayName(BuildContext context) async {
    final nameController = TextEditingController(
      text: currentUser.value?.displayName ?? '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: NeoBrutalTheme.brutalBox(
            color: NeoBrutalColors.white,
            borderColor: NeoBrutalColors.black,
            shadowColor: NeoBrutalColors.black,
            shadowOffset: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'EDIT NAME',
                style: NeoBrutalTheme.heading.copyWith(
                  fontSize: 20,
                  color: NeoBrutalColors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: NeoBrutalTheme.brutalBox(
                  color: NeoBrutalColors.white,
                  borderColor: NeoBrutalColors.black,
                  shadowOffset: 0,
                ),
                child: TextField(
                  controller: nameController,
                  style: NeoBrutalTheme.body.copyWith(
                    color: NeoBrutalColors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: NeoBrutalTheme.body.copyWith(
                      color: NeoBrutalColors.mediumGrey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.white,
                        borderColor: NeoBrutalColors.black,
                        shadowColor: NeoBrutalColors.black,
                        shadowOffset: 2,
                      ),
                      child: Text(
                        'CANCEL',
                        style: NeoBrutalTheme.heading.copyWith(
                          fontSize: 14,
                          color: NeoBrutalColors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.lime,
                        borderColor: NeoBrutalColors.black,
                        shadowColor: NeoBrutalColors.black,
                        shadowOffset: 2,
                      ),
                      child: Text(
                        'SAVE',
                        style: NeoBrutalTheme.heading.copyWith(
                          fontSize: 14,
                          color: NeoBrutalColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      CustomSnackbar.showError(title: 'ERROR', message: 'Name cannot be empty');
      return;
    }

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      await user.updateDisplayName(newName);

      // Update Firestore if document exists
      final docRef = _firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'displayName': newName});
      }

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
