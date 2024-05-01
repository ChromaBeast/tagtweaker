import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../blocs/product_bloc.dart';
import '../../../widgets/homepage/category_row_4.dart';
import '../../../widgets/homepage/circular_row_1.dart';
import '../../../widgets/homepage/corousel_2.dart';
import '../../../widgets/homepage/image_banner_3.dart';
import '../../auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()..add(FetchProducts()),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          forceMaterialTransparency: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Tag Tweaker',
            style: TextStyle(fontFamily: 'Lobster'),
          ),
          actions: [
            FirebaseAuth.instance.currentUser == null
                ? IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser?.photoURL ??
                              'https://via.placeholder.com/150',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          if (FirebaseAuth.instance.currentUser != null) {
                            if (FirebaseAuth
                                .instance.currentUser!.isAnonymous) {
                              await FirebaseAuth.instance.currentUser!.delete();
                            } else {
                              await GoogleSignIn().signOut();
                              await FirebaseAuth.instance.signOut();
                            }
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Please wait while we load the products"),
                    Image.asset('assets/animations/splash_screen.gif',
                        height: 200, width: 200),
                  ],
                ),
              );
            } else if (state is ProductsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    circularRow(context),
                    const SizedBox(height: 10),
                    carouselSlider(context),
                    const SizedBox(height: 10),
                    imageBanner(),
                    const SizedBox(height: 10),
                    categoryRow("Trending", "Now", context),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Error loading products'));
            }
          },
        ),
      ),
    );
  }
}
