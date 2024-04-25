import 'package:bloc/bloc.dart';

abstract class ProductEvent {}

class ProductAddedToFavourites extends ProductEvent {
  final Map<String, dynamic> product;
  ProductAddedToFavourites(this.product);
}

class ProductRemovedFromFavourites extends ProductEvent {
  final Map<String, dynamic> product;
  ProductRemovedFromFavourites(this.product);
}

class ProductPriceUpdated extends ProductEvent {
  final Map<String, dynamic> product;
  ProductPriceUpdated(this.product);
}

class FavouriteProductState {
  final List<Map<String, dynamic>> favourites;
  const FavouriteProductState(this.favourites);
}

class CatalogProductState {
  final List<Map<String, dynamic>> catalog;
  const CatalogProductState(this.catalog);
}

class ProductBloc extends Bloc<ProductEvent, FavouriteProductState> {
  ProductBloc() : super(const FavouriteProductState([])) {
    on<ProductAddedToFavourites>((event, emit) {
      final updatedFavourites =
          List<Map<String, dynamic>>.from(state.favourites)..add(event.product);
      emit(FavouriteProductState(updatedFavourites));
    });
    on<ProductRemovedFromFavourites>((event, emit) {
      final updatedFavourites =
          List<Map<String, dynamic>>.from(state.favourites)
            ..remove(event.product);
      emit(FavouriteProductState(updatedFavourites));
    });
    on<ProductPriceUpdated>((event, emit) {
      final catalog = List<Map<String, dynamic>>.from(state.favourites);
      final updatedCatalog = catalog.map((product) {
        if (product["id"] == event.product["id"]) {
          return event.product;
        }
        return product;
      }).toList();
      emit(FavouriteProductState(updatedCatalog));
    });
  }
}
