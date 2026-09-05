import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';
import '../custom_network_image.dart';

/// Reusable avatar widget with edit button for profile ID card
class ProfileAvatar extends StatelessWidget {
  final User? user;
  final VoidCallback onEdit;
  final bool isLoading;

  const ProfileAvatar({
    super.key,
    required this.user,
    required this.onEdit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: NeoBrutalColors.black, width: 3),
          ),
          child: ClipOval(
            child: user?.photoURL != null
                ? CustomNetworkImage(user!.photoURL!, fit: BoxFit.cover)
                : Container(
                    color: NeoBrutalColors.mediumGrey,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: NeoBrutalColors.black,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.purple,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.black,
                shadowOffset: 2,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: NeoBrutalColors.white,
                      ),
                    )
                  : const Icon(
                      Icons.edit,
                      size: 14,
                      color: NeoBrutalColors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
