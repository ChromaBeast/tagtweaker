import 'package:flutter/material.dart';

Widget imageBanner() {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    height: 200,
    width: double.infinity,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      image: DecorationImage(
        image: AssetImage('assets/images/banner.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
