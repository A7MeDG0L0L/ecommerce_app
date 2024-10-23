import 'package:ecommerce/bloc_observer.dart';
import 'package:ecommerce/config/routes/app_routes.dart';
import 'package:ecommerce/config/routes/route_configurations.dart';
import 'package:ecommerce/core/helpers/cache_helper.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/products_grid.dart';
import '../widgets/search_fav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          BlocBuilder<ProductsCubit,ProductsState>(
            builder: (context, state) {
              if(state is ProductsSuccess){
                return IconButton(
                  icon: Badge.count(count: state.cartProducts.length,child:
                  const Icon
                    (Icons
                      .shopping_cart),),
                  onPressed: ()  =>
                    context.pushNamed(AppRoutes.cartScreen),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          SearchFavBar(),
          Expanded(child: ProductsGrid()),
        ],
      ),
    );
  }
}
