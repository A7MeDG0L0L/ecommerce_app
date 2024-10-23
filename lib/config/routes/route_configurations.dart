import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:ecommerce/features/products/presentation/pages/cart_screen.dart';
import 'package:ecommerce/features/products/presentation/pages/home_screen.dart';
import 'package:ecommerce/features/products/presentation/pages/product_item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../features/products/presentation/pages/favourite_screen.dart';
import 'routes.dart';

class _AppPaths {
  _AppPaths._();

  static const String initLocation = '/';
  static const String homeScreen = '/homeScreen';
  static const String favouriteScreen = '/favouriteScreen';
  static const String cartScreen = '/cartScreen';
  static const String productItemDetailsScreen = '/productItemDetailsScreen';
}

class RouteConfigurations {
  RouteConfigurations._internal();

  static final RouteConfigurations _instance = RouteConfigurations._internal();
  factory RouteConfigurations() => _instance;

  static RouteConfigurations get instance => _instance;
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    debugLogDiagnostics: true,
    // redirect: (context, state) {
    //   return _AppPaths.homeScreen;
    // },
    navigatorKey: parentNavigatorKey,
    initialLocation: _AppPaths.homeScreen,
    routes: _routes,
  );

  static final _routes = [
    GoRoute(
      path: _AppPaths.homeScreen,
      name: AppRoutes.homeScreen,
      pageBuilder: (context, GoRouterState state) => _getPage(
        child: const HomeScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: _AppPaths.cartScreen,
      name: AppRoutes.cartScreen,
      pageBuilder: (context, state) {
        return _getPage(
          state: state,
          child: CartScreen(),
        );
      },
    ),
    GoRoute(
      path: _AppPaths.favouriteScreen,
      name: AppRoutes.favouriteScreen,
      pageBuilder: (context, state) => _getPage(
        state: state,
        child: const FavouriteScreen(),
      ),
    ),
    GoRoute(
      path: _AppPaths.productItemDetailsScreen,
      name: AppRoutes.productItemDetailsScreen,
      pageBuilder: (context, state) {
        var productItem = state.extra;
        return _getPage(
          state: state,
          child: ProductItemDetailsScreen(productItem: productItem as Product),
        );
      },
    ),
  ];

  static Page _getPage({
    required Widget child,
    required GoRouterState state,
    bool fullScreenDialog = false,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
      fullscreenDialog: fullScreenDialog,
    );
  }

  static void setPageTitle(String title, BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: title,
        primaryColor: Theme.of(context).primaryColor.value,
      ),
    );
  }
}
