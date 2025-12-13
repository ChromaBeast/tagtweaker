// import 'package:flutter/material.dart';
// import 'package:tag_tweaker/themes/colors.dart';
// class NeumorphicSearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final Function(String) onChanged;
//   final VoidCallback onClear;

//   const NeumorphicSearchBar({
//     super.key,
//     required this.controller,
//     required this.onChanged,
//     required this.onClear,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.neumorphicBackground,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.neumorphicLightShadow,
//             offset: Offset(-4, -4),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//           BoxShadow(
//             color: AppColors.neumorphicDarkShadow,
//             offset: Offset(4, 4),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: SearchBar(
//         controller: controller,
//         hintText: 'Search Products',
//         hintStyle: WidgetStateProperty.all(
//           Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
//         ),
//         leading: Icon(Icons.search_rounded, color: colorScheme.primary),
//         trailing: controller.text.isNotEmpty
//             ? [
//                 IconButton(
//                   icon: Icon(
//                     Icons.clear_rounded,
//                     color: colorScheme.onSurfaceVariant,
//                   ),
//                   onPressed: onClear,
//                 ),
//               ]
//             : null,
//         elevation: WidgetStateProperty.all(0),
//         backgroundColor: WidgetStateProperty.all(Colors.transparent),
//         side: WidgetStateProperty.all(BorderSide.none),
//         shape: WidgetStateProperty.all(
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
