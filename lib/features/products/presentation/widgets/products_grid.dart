import 'dart:math';

import 'package:ecommerce/core/responsive/media_query_values.dart';
import 'package:ecommerce/core/util/print.dart';
import 'package:ecommerce/core/widgets/snackbar.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:ecommerce/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/routes/route_configurations.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/double_tap_heart_animation.dart';
import '../../../../core/widgets/empty_search_widget.dart';
import '../../../../generated/assets.gen.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    double w = context.width;
    double itemWidth = 200;
    double crossAxisCount = w / itemWidth;
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async =>
              context.read<ProductsCubit>().getProducts(),
          child: state.maybeWhen(
            success:(allProducts, filteredProducts, favoriteProducts,
                cartProducts) {
              return allProducts.isNotEmpty
                  ? filteredProducts.isNotEmpty
                  ? MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: crossAxisCount.toInt(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  // Varies between 0.8, 1.0, and 1.2
                  double aspectRatio = 0.8 + (index % 3) * 0.2;
                  double height = itemWidth / aspectRatio;
                  var product = allProducts[index];
                  return DoubleTapHeartAnimation(
                    onDoubleTap: () async {
                      context
                          .read<ProductsCubit>()
                          .toggleFavorite(product);
                    },
                    child: ProductCard(
                      item: product,
                      height: height,
                      onAddToCartTap: ()=> context
                          .read<ProductsCubit>()
                          .toggleCart(product) ,
                      onFavouriteTap: () => context
                          .read<ProductsCubit>().toggleFavorite(product),
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
                    Assets.lottie.emptyBox.lottie(),
                    CustomButtonText(
                      title: "Refresh",
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      onPressed: () => context
                          .read<ProductsCubit>()
                          .getProducts(),
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
                    CustomButtonText(
                      title: "Retry",
                      onPressed: () async => context
                          .read<ProductsCubit>()
                          .getProducts(),
                    ),
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
                      onFavouriteTap: () {},
                      onAddToCartTap: () {},
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
