import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure_handler.dart';

part 'result.freezed.dart';

@Freezed()
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(FailureHandler failure) = Failure<T>;
}
