import 'package:ecommerce/core/helpers/networking/result.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';

abstract class IProductsRepository {
  Future<Result<List<Product>>> getProducts();
}
