import 'package:freezed_annotation/freezed_annotation.dart';

part 'products.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required double rating,
    required int ratingCount,
    @Default(false)
    bool isFavourite,
    @Default(false)
    bool isCart,
  }) = _Product;
}