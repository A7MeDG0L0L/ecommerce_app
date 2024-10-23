import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required RatingModel rating,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  // Conversion to Entity

}
extension Conv on ProductModel {
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.rate,
      ratingCount: rating.count,
    );
  }
}
@freezed
class RatingModel with _$RatingModel {
  const factory RatingModel({
    required double rate,
    required int count,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);
}