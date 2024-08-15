import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomHomePageShimmer extends StatelessWidget {
  const CustomHomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Shimmer effect for the category row
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 80,
                    height: 100,
                    color: Colors.grey[800],
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),

            // Shimmer effect for the banner
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),

            // Shimmer effect for the sale announcement
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 150,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),

            // Shimmer effect for the trending products section
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Shimmer effect for product images
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return Container(
                      width: 150,
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.grey[800],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
