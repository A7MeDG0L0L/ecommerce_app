

import 'package:ecommerce/ecommerce_app.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc_observer.dart';
import 'core/helpers/cache_helper.dart';
import 'core/helpers/connectivity.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  runApp(const EcommerceApp());
  FlutterNativeSplash.remove();
}

Future<void> init() async {
  Bloc.observer = MyBlocObserver();
  setupLocator();
  await ScreenUtil.ensureScreenSize();
  Future.delayed(const Duration(seconds: 10),
      () => ConnectivityChecker.instance.initialize());
  await CacheHelper.init();
}
