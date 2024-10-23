import 'package:ecommerce/core/responsive/media_query_values.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes/route_configurations.dart';
import 'config/theme/app_theme.dart';
import 'core/constant/app_strings.dart';
import 'generated/l10n.dart';


class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: context.isMobile
          ? const Size(360, 690)
          : context.isTablet
              ? const Size(768, 1024)
              : const Size(1366, 768),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return BlocProvider(
          create: (context) =>
              getIt<ProductsCubit>()..getProducts(),
          child: MaterialApp.router(
            title: AppStrings.appName,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            routerConfig: RouteConfigurations.router,
            theme: AppTheme.lightTheme(),
          ),
        );
      },
    );
  }
}
