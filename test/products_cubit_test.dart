import 'package:ecommerce/core/helpers/networking/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products.dart';
import 'package:ecommerce/core/helpers/sqlite_helper.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:mockito/mockito.dart';

class MockGetProducts extends Mock implements GetProducts {}
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late ProductsCubit productsCubit;
  late MockGetProducts mockGetProducts;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockGetProducts = MockGetProducts();
    mockDatabaseHelper = MockDatabaseHelper();
    productsCubit = ProductsCubit(mockGetProducts, mockDatabaseHelper);
  });

  group('ProductsCubit', () {
    test('initial state is ProductsInitial', () {
      expect(productsCubit.state, ProductsInitial());
    });

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsSuccess] when getProducts is called successfully',
      build: () {
        when(mockGetProducts()).thenAnswer((_) async =>
            Success([
              Product(
                id: 1,
                title: 'Test Product',
                price: 19.99,
                description: 'A great product',
                category: 'Test Category',
                image: 'http://example.com/image.png',
                rating: 4.5,
                ratingCount: 10,
              )
            ]));
        when(mockDatabaseHelper.getFavoriteProductsIds(5)).thenAnswer((_)
        async => []);
        when(mockDatabaseHelper.getCartProductsIds(5)).thenAnswer((_) async
        => []);
        return productsCubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        ProductsLoading(),
        isA<ProductsSuccess>(),
      ],
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsFailure] when getProducts fails',
      build: () {
        when(mockGetProducts()).thenThrow(Exception('Failed to fetch products'));
        return productsCubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        ProductsLoading(),
        isA<ProductsFailure>(),
      ],
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits updated state when toggleFavorite is called',
      build: () {
        when(mockGetProducts()).thenAnswer((_) async =>
            Success([
              Product(
                id: 1,
                title: 'Test Product',
                price: 19.99,
                description: 'A great product',
                category: 'Test Category',
                image: 'http://example.com/image.png',
                rating: 4.5,
                ratingCount: 10,
                isFavourite: false,
              )
            ]));
        when(mockDatabaseHelper.getFavoriteProductsIds(5)).thenAnswer((_)
        async => []);
        when(mockDatabaseHelper.getCartProductsIds(5)).thenAnswer((_) async
        => []);
        return productsCubit;
      },
      act: (cubit) async {
        await cubit.getProducts(); // load initial products
        await cubit.toggleFavorite(Product(id: 1, title: 'Test Product', isFavourite: false, price: 19.99, description: 'A great product', category: 'Test Category', image: 'http://example.com/image.png', rating: 4.5, ratingCount: 10));
      },
      expect: () => [
        isA<ProductsSuccess>(),
        // Check that the product's favorite status is updated
        isA<ProductsSuccess>().having((state) => state.favoriteProducts.length, 'favoriteProducts length', 1),
      ],
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits updated state when toggleCart is called',
      build: () {
        when(mockGetProducts()).thenAnswer((_) async =>
            Success([
              Product(
                id: 1,
                title: 'Test Product',
                price: 19.99,
                description: 'A great product',
                category: 'Test Category',
                image: 'http://example.com/image.png',
                rating: 4.5,
                ratingCount: 10,
                isCart: false,
              )
            ]));
        when(mockDatabaseHelper.getFavoriteProductsIds(5)).thenAnswer((_)
        async => []);
        when(mockDatabaseHelper.getCartProductsIds(5)).thenAnswer((_) async
        => []);
        return productsCubit;
      },
      act: (cubit) async {
        await cubit.getProducts(); // load initial products
        await cubit.toggleCart(Product(id: 1, title: 'Test Product', isCart: false, price: 19.99, description: 'A great product', category: 'Test Category', image: 'http://example.com/image.png', rating: 4.5, ratingCount: 10));
      },
      expect: () => [
        isA<ProductsSuccess>(),
        // Check that the product's cart status is updated
        isA<ProductsSuccess>().having((state) => state.cartProducts.length, 'cartProducts length', 1),
      ],
    );

    // Add more tests for other functionalities as needed
  });
}