
import 'package:ecommerce/core/helpers/networking/api_constant.dart';
import 'package:ecommerce/core/helpers/networking/api_service.dart';
import 'package:ecommerce/core/helpers/networking/error/exception.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';

abstract class IProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductsRemoteDataSource implements IProductsRemoteDataSource {
  final ApiService _apiService;

  ProductsRemoteDataSource(this._apiService);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get(ApiConstant.products);
      if (response.statusCode == 200) {
        final List decodedJson = response.data;
        final List<ProductModel> postModels = decodedJson
            .map<ProductModel>(
                (jsonPostModel) => ProductModel.fromJson(jsonPostModel))
            .toList();
        return postModels;
      } else {
        throw ServerException(
            message: response.statusMessage ?? 'Response != 200');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
