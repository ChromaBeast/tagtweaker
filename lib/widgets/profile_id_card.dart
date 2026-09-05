import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'profile/profile_avatar.dart';

/// Brutalist member ID card displaying user avatar and profile details
class ProfileIDCard extends StatelessWidget {
  final User? user;
  final VoidCallback onEdit;
  final VoidCallback? onNameEdit;
  final bool isLoading;

  const ProfileIDCard({
    super.key,
    required this.user,
    required this.onEdit,
    this.onNameEdit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.white,
        borderColor: NeoBrutalColors.black,
        shadowColor: NeoBrutalColors.black,
        shadowOffset: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ID Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: NeoBrutalColors.black, width: 4),
              ),
              color: NeoBrutalColors.lime,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MEMBER ID CARD',
                  style: NeoBrutalTheme.heading.copyWith(
                    fontSize: 16,
                    color: NeoBrutalColors.black,
                  ),
                ),
                const Icon(Icons.nfc, color: NeoBrutalColors.black, size: 24),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatar(
                  user: user,
                  onEdit: onEdit,
                  isLoading: isLoading,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'NAME',
                            style: NeoBrutalTheme.mono.copyWith(
                              fontSize: 10,
                              color: NeoBrutalColors.mediumGrey,
                            ),
                          ),
                          if (onNameEdit != null) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: onNameEdit,
                              child: const Icon(
                                Icons.edit,
                                size: 12,
                                color: NeoBrutalColors.mediumGrey,
                              ),
                            ),
                          ],
                        ],
                      ),
                      GestureDetector(
                        onTap: onNameEdit,
                        child: Text(
                          user?.displayName?.toUpperCase() ?? 'TAP TO SET NAME',
                          style: NeoBrutalTheme.heading.copyWith(
                            fontSize: 20,
                            height: 1.1,
                            color: NeoBrutalColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'EMAIL',
                        style: NeoBrutalTheme.mono.copyWith(
                          fontSize: 10,
                          color: NeoBrutalColors.mediumGrey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        color: NeoBrutalColors.black,
                        child: Text(
                          user?.email ?? 'NO EMAIL',
                          style: NeoBrutalTheme.mono.copyWith(
                            fontSize: 12,
                            color: NeoBrutalColors.lime,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ID Footer Barcode (Decorative)
          Container(
            height: 32,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: NeoBrutalColors.black, width: 4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                20,
                (index) => Container(
                  width: index % 3 == 0 ? 4 : 2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: NeoBrutalColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
