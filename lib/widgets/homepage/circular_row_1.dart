// import 'package:flutter/material.dart';

// import '../../models/product_model.dart';
// import '../../pages/ui/category_page.dart';
// import '../../themes/colors.dart';

// Widget circularRow(BuildContext context) {
//   final colorScheme = Theme.of(context).colorScheme;
//   final textTheme = Theme.of(context).textTheme;

//   // Define monochrome gradients for each category
//   final categoryGradients = [
//     [const Color(0xFF757575), const Color(0xFF424242)], // Smartphone - Grey
//     [const Color(0xFF9E9E9E), const Color(0xFF616161)], // Laptop - Light Grey
//     [const Color(0xFF757575), const Color(0xFF424242)], // Controller - Grey
//     [const Color(0xFF9E9E9E), const Color(0xFF616161)], // Audio - Light Grey
//     [const Color(0xFF757575), const Color(0xFF424242)], // TV - Grey
//     [
//       const Color(0xFF9E9E9E),
//       const Color(0xFF616161),
//     ], // Accessories - Light Grey
//   ];

//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     child: SizedBox(
//       height: 140,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         physics: const BouncingScrollPhysics(),
//         itemCount: Product.categories.length,
//         itemBuilder: (BuildContext context, int index) {
//           final category = Product.categories[index].toLowerCase();
//           final img = "assets/icons/$category.png";
//           final categoryProducts = Product.products
//               .where((element) => element['category'] == category)
//               .toList();
//           final productCount = categoryProducts.length;
//           final gradient = categoryGradients[index % categoryGradients.length];

//           return Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: Container(
//               width: 110,
//               decoration: BoxDecoration(
//                 color: AppColors.neumorphicBackground,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: AppColors.neumorphicLightShadow,
//                     offset: Offset(-4, -4),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   ),
//                   BoxShadow(
//                     color: AppColors.neumorphicDarkShadow,
//                     offset: Offset(4, 4),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 child: InkWell(
//                   splashColor: gradient[0].withOpacity(0.2),
//                   highlightColor: gradient[0].withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CategoryPage(
//                           categoryList: categoryProducts,
//                           category: category,
//                           text: Product.categories[index],
//                         ),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 14,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Icon container with gradient
//                         Container(
//                           width: 48,
//                           height: 48,
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: gradient,
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: gradient[0].withOpacity(0.4),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Image.asset(img, color: Colors.white),
//                         ),
//                         const SizedBox(height: 8),
//                         // Category name
//                         Flexible(
//                           child: Hero(
//                             tag: Product.categories[index].toLowerCase(),
//                             child: Material(
//                               color: Colors.transparent,
//                               child: Text(
//                                 Product.categories[index],
//                                 style: textTheme.labelLarge?.copyWith(
//                                   color: colorScheme.onSurface,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 0.5,
//                                   fontSize: 13,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         // Product count badge
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.neumorphicBackground,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: colorScheme.outline.withOpacity(0.1),
//                             ),
//                           ),
//                           child: Text(
//                             '$productCount items',
//                             style: textTheme.labelSmall?.copyWith(
//                               color: colorScheme.onSurface.withOpacity(0.7),
//                               fontWeight: FontWeight.w600,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }
