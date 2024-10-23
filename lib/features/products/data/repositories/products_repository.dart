import 'package:ecommerce/core/helpers/networking/call_handler.dart';
import 'package:ecommerce/core/helpers/networking/result.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:ecommerce/features/products/domain/repositories/i_products_repository.dart';

import '../datasources/products_remote_data_source/products_remote_data_source.dart';

class ProductsRepository extends IProductsRepository {
  final IProductsRemoteDataSource _remoteDataSource;
  ProductsRepository(this._remoteDataSource);

  @override
  Future<Result<List<Product>>> getProducts() async {
    return await CallerDataHandler.call(() async {
      var productModel = await _remoteDataSource.getProducts();
      List<Product> products = productModel.map((e) => e.toEntity()).toList();
      return products;
    });
  }
}
