import 'dart:math';

import 'package:ecommerce/config/routes/app_routes.dart';
import 'package:ecommerce/core/responsive/media_query_values.dart';
import 'package:ecommerce/core/widgets/double_tap_heart_animation.dart';
import 'package:ecommerce/core/widgets/empty_search_widget.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:ecommerce/features/products/presentation/widgets/product_card.dart';
import 'package:ecommerce/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = context.width;
    double itemWidth = 250;
    double crossAxisCount = w / itemWidth;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return state.maybeWhen(
            success: (allProducts, filteredProducts, favoriteProducts,
                cartProducts) {
              return favoriteProducts.isNotEmpty
                  ? favoriteProducts.isNotEmpty
                      ? MasonryGridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: crossAxisCount.toInt(),
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          itemCount: favoriteProducts.length,
                          itemBuilder: (context, index) {
                            // Varies between 0.8, 1.0, and 1.2
                            double aspectRatio = 0.8 + (index % 3) * 0.2;
                            double height = itemWidth / aspectRatio;
                            var product = favoriteProducts[index];
                            return DoubleTapHeartAnimation(
                              onDoubleTap: () async {
                                context
                                    .read<ProductsCubit>()
                                    .toggleFavorite(product);
                              },
                              child: ProductCard(
                                item: product,
                                height: height,
                                onFavouriteTap: () =>  context
                                    .read<ProductsCubit>()
                                    .toggleFavorite(product),
                                onAddToCartTap: ()=> context
                                    .read<ProductsCubit>()
                                    .toggleCart(product) ,
                                onTap: () {
                                  context.pushNamed(
                                    AppRoutes.productItemDetailsScreen,
                                    extra: product,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const EmptySearch()
                  : Center(
                      child: Column(
                        children: [
                          Assets.lottie.cardEmpty.lottie(),
                          SizedBox(height: 8.h),
                          Text(
                            "Your favorite items will be shown here",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    );
            },
            failure: (failure) {
              return Center(
                child: Column(
                  children: [
                    const Text('Oops, something unexpected happened'),
                    SizedBox(height: 32.h),
                    Text(failure),
                    SizedBox(height: 56.h),
                  ],
                ),
              );
            },
            orElse: () {
              ProductModel product = ProductModel(id: Random().nextInt(99), title:
              BoneMock.title,
                  price: Random().nextDouble(), description: BoneMock.paragraph,
                  category:
                  BoneMock.name,
                  image: '', rating: RatingModel(rate: Random().nextDouble(),
                      count: 5));
              return Skeletonizer(
                enabled: true,
                child: MasonryGridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      item: product.toEntity(),
                      height: 200.h,
                      onTap: () {},
                      onAddToCartTap: (){} ,
                      onFavouriteTap: () {},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
