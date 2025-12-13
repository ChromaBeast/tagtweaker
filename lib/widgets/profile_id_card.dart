import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';

class ProfileIDCard extends StatelessWidget {
  final User? user;
  final VoidCallback onEdit;
  final bool isLoading;

  const ProfileIDCard({
    super.key,
    required this.user,
    required this.onEdit,
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
                // Avatar
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NeoBrutalColors.black,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: user?.photoURL != null
                            ? CustomNetworkImage(
                                user!.photoURL!,
                                fit: BoxFit.cover,
                              )
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
                ),
                const SizedBox(width: 24),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NAME',
                        style: NeoBrutalTheme.mono.copyWith(
                          fontSize: 10,
                          color: NeoBrutalColors.mediumGrey,
                        ),
                      ),
                      Text(
                        user?.displayName?.toUpperCase() ?? 'NO NAME',
                        style: NeoBrutalTheme.heading.copyWith(
                          fontSize: 20,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
