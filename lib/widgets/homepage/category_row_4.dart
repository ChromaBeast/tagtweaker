// import 'package:flutter/material.dart';

// import '../../models/product_model.dart';
// import '../../pages/ui/product_page.dart';
// import '../../pages/ui/trending_now_page.dart';
// import '../../themes/colors.dart';
// import 'package:tag_tweaker/widgets/neumorphic_product_card.dart';

// Widget categoryRow(String text, String leading, BuildContext context) {
//   final colorScheme = Theme.of(context).colorScheme;
//   final textTheme = Theme.of(context).textTheme;

//   List products = Product.products
//       .where((element) => element['ui']["is$text"] == true)
//       .toList();
//   int len = products.length;

//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 16),
//     child: Column(
//       children: [
//         // Header Container - Neumorphic
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.neumorphicBackground,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: AppColors.neumorphicLightShadow,
//                 offset: Offset(-4, -4),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//               BoxShadow(
//                 color: AppColors.neumorphicDarkShadow,
//                 offset: Offset(4, 4),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.trending_up_rounded,
//                       color: colorScheme.primary,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "$text $leading",
//                       style: textTheme.titleMedium?.copyWith(
//                         color: colorScheme.onSurface,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             TrendingNowPage(products: products),
//                       ),
//                     );
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'View All',
//                         style: textTheme.labelLarge?.copyWith(
//                           color: colorScheme.primary,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(
//                         Icons.arrow_forward_rounded,
//                         size: 18,
//                         color: colorScheme.primary,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         // Products Row
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.30,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             shrinkWrap: true,
//             physics: const BouncingScrollPhysics(),
//             itemCount: len < 5 ? len : 5,
//             itemBuilder: (BuildContext context, int index) {
//               return SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.42,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     right: 12,
//                     bottom: 8,
//                     top: 8,
//                   ), // Added padding for shadow
//                   child: NeumorphicProductCard(
//                     product: products[index],
//                     showCategory: true,
//                     showBrandInRow: true,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
