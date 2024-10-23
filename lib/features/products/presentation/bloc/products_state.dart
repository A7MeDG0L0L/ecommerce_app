import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = ProductsInitial;
  const factory ProductsState.loading() = ProductsLoading;
  const factory ProductsState.success({
    required List<Product> allProducts,
    required List<Product> filteredProducts,
    required List<Product> favoriteProducts,
    required List<Product> cartProducts,
  }) = ProductsSuccess;
  const factory ProductsState.failure({required String message}) = ProductsFailure;
}