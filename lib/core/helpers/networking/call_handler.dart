import 'dart:async';

import 'package:ecommerce/core/helpers/networking/result.dart';

import 'failure_handler.dart';

 class CallerDataHandler {
  static Future<Result<T>> call<T>(Future<T> Function() call) async {
    try {
      final res = await call();
      return Result.success(res);
    } catch (e) {
      return Result.failure(FailureHandler.handle(e));
    }
  }
}


