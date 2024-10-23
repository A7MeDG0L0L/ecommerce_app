
import 'package:ecommerce/core/helpers/networking/result.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:ecommerce/features/products/domain/repositories/i_products_repository.dart';


class  GetProducts {
  final IProductsRepository repository;
  GetProducts(this.repository);

  Future<Result<List<Product>>> call() async {
    return await repository.getProducts();
  }
}
