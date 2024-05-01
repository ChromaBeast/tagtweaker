import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {}

abstract class ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<DocumentSnapshot> products;
  ProductsLoaded(this.products);
}

class ProductsError extends ProductState {}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductsLoading()) {
    on<FetchProducts>((event, emit) async {
      try {
        QuerySnapshot productsSnapshot =
            await FirebaseFirestore.instance.collection('products').get();
        emit(ProductsLoaded(productsSnapshot.docs));
      } catch (e) {
        emit(ProductsError());
      }
    });
  }
}
