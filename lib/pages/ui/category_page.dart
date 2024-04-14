import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categoryList;
  final String category, text;
  const CategoryPage(
      {super.key,
      required this.categoryList,
      required this.category,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        title: Hero(
          tag: category,
          child: Material(
            color: Colors.transparent,
            textStyle: const TextStyle(
              fontSize: 24,
            ),
            child: Text(text),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          product: categoryList[index],
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: categoryList[index]['id'].toString(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        categoryList[index]['thumbnail'].toString(),
                        fit: BoxFit.cover,
                        height: 200.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Hero(
                  tag: categoryList[index]['title'].toString(),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      categoryList[index]['title'].toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
