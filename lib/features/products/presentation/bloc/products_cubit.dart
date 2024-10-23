import 'dart:async';
import 'dart:math';

import 'package:ecommerce/core/constant/cache_keys.dart';
import 'package:ecommerce/core/helpers/cache_helper.dart';
import 'package:ecommerce/core/helpers/sqlite_helper.dart';
import 'package:ecommerce/core/util/print.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts _getProducts;
  final DatabaseHelper _databaseHelper;

  ProductsCubit(this._getProducts, this._databaseHelper)
      : super(ProductsInitial()){
    CacheHelper.setData(key: CacheKeys.userId,value: 5);

  }


ValueNotifier<double> totalCartProductsAmount = ValueNotifier(0.0);
  double getTotalAmount(List<Product>? cartProducts) {
    totalCartProductsAmount.value = 0.0;
    if(cartProducts?.isNotEmpty ?? false){
      for (var product in cartProducts!) {
        totalCartProductsAmount.value += product.price;
      }
    }
    return totalCartProductsAmount.value;
  }

  Future<void> getProducts() async {
    emit(ProductsLoading());
    try {
      final result = await _getProducts();
      await result.when(
        success: (data) async {
          var userId = await CacheHelper.getData(key: CacheKeys.userId);

            final favoriteIds = await _databaseHelper.getFavoriteProductsIds(userId);
            final cartIds = await _databaseHelper.getCartProductsIds(userId);

          final updatedProducts = data.map((product) {
            return product.copyWith(
              isFavourite: favoriteIds.contains(product.id.toString()),
              isCart:  cartIds.contains(product.id.toString()),
            );
          }).toList();

          // Filter out favorite products
          final favoriteProducts =
          updatedProducts.where((product) => product.isFavourite).toList();

          final cartProducts =
          updatedProducts.where((product) => product.isCart).toList();
getTotalAmount(cartProducts);
          emit(ProductsSuccess(
            allProducts: updatedProducts,
            filteredProducts: updatedProducts,
            favoriteProducts: favoriteProducts,
            cartProducts: cartProducts,
          ));
        },
        failure: (failure) {
          emit(ProductsFailure(message: failure.failure.message));
        },
      );
    } catch (e,st) {
      print(e.toString());
      print(st.toString());
      emit(ProductsFailure(message: e.toString()));
    }
  }

  Future<void> toggleFavorite(Product product) async {
    if (state is ProductsSuccess) {
      final currentState = state as ProductsSuccess;
      final productId = product.id;

      if (productId == null) return;

      var userId = await CacheHelper.getData(key: CacheKeys.userId);
      bool success;
      if (product.isFavourite) {
        success = await _databaseHelper.removeFromFavorites(userId, productId
            .toString());
      } else {
        success = await _databaseHelper.addToFavorites(userId, productId.toString());
     List<String> favProducts = await   _databaseHelper.getFavoriteProductsIds
          (CacheHelper.getData(key:
        CacheKeys.userId));
     print(favProducts);
      }

      if (success) {
        final updatedAllProducts = currentState.allProducts.map((p) {
          if (p.id == productId) {
            return p.copyWith(isFavourite: !p.isFavourite);
          }
          return p;
        }).toList();

        final updatedFilteredProducts = currentState.filteredProducts.map((p) {
          if (p.id == productId) {
            return p.copyWith(isFavourite: !p.isFavourite);
          }
          return p;
        }).toList();

        List<Product> updatedFavoriteProducts;
        if (product.isFavourite) {
          updatedFavoriteProducts = currentState.favoriteProducts
              .where((p) => p.id != productId)
              .toList();
        } else {
          updatedFavoriteProducts = [
            ...currentState.favoriteProducts,
            product.copyWith(isFavourite: true),
          ];
        }

        emit(currentState.copyWith(
          allProducts: updatedAllProducts,
          filteredProducts: updatedFilteredProducts,
          favoriteProducts: updatedFavoriteProducts,
        ));
      }
    }
  }


  Future<void> toggleCart(Product product) async {
    if (state is ProductsSuccess) {
      final currentState = state as ProductsSuccess;
      final productId = product.id;

      if (productId == null) return;

      var userId = await CacheHelper.getData(key: CacheKeys.userId);
      bool success;
      if (product.isCart) {
        success = await _databaseHelper.removeFromCart(userId, productId
            .toString());
      } else {
        success = await _databaseHelper.addToCart(userId, productId.toString());
        // List<String> cartProducts = await   _databaseHelper.getCartProductsIds
        //   (CacheHelper.getData(key:
        // CacheKeys.userId));
        // ePrint(cartProducts.toString());
      }

      if (success) {
        final updatedAllProducts = currentState.allProducts.map((p) {
          if (p.id == productId) {
            return p.copyWith(isCart: !p.isCart);
          }
          return p;
        }).toList();

        final updatedFilteredProducts = currentState.filteredProducts.map((p) {
          if (p.id == productId) {
            return p.copyWith(isCart: !p.isCart);
          }
          return p;
        }).toList();

        List<Product> updatedFavoriteProducts;
        if (product.isFavourite) {
          updatedFavoriteProducts = currentState.favoriteProducts
              .where((p) => p.id != productId)
              .toList();
        } else {
          updatedFavoriteProducts = [
            ...currentState.favoriteProducts,
            product.copyWith(isFavourite: true),
          ];
        }

        List<Product> updatedCartProducts;
        if (product.isCart) {
          updatedCartProducts = currentState.cartProducts
              .where((p) => p.id != productId)
              .toList();
        } else {
          updatedCartProducts = [
            ...currentState.cartProducts,
            product.copyWith(isCart: true),
          ];
        }
print(updatedCartProducts);
        emit(currentState.copyWith(
          allProducts: updatedAllProducts,
          filteredProducts: updatedFilteredProducts,
          favoriteProducts: updatedFavoriteProducts,
          cartProducts: updatedCartProducts,
        ));
        getTotalAmount(updatedCartProducts);

      }
    }
  }

  void searchProducts(String query) {
    if (state is ProductsSuccess) {
      final currentState = state as ProductsSuccess;
      final searchQuery = query.toLowerCase();

      if (searchQuery.isEmpty) {
        emit(currentState.copyWith(filteredProducts: currentState.allProducts));
      } else {
        final filteredProducts = currentState.allProducts.where((product) {
          return product.title.toLowerCase().contains(searchQuery) ||
              product.description.toLowerCase().contains(searchQuery);
        }).toList();

        emit(currentState.copyWith(filteredProducts: filteredProducts));
      }
    }
  }
}