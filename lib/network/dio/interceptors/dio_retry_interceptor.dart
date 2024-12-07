import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final RetryOptions options;
  final bool shouldLog;

  RetryInterceptor(
      {required this.dio, RetryOptions? options, this.shouldLog = true})
      : options = options ?? const RetryOptions();

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    var extra = RetryOptions.fromExtra(err.requestOptions, options);

    var shouldRetry = extra.retries > 0 && await options.retryEvaluator(err);
    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    if (extra.retryInterval.inMilliseconds > 0) {
      await Future.delayed(extra.retryInterval);
    }

    extra = extra.copyWith(retries: extra.retries - 1);
    err.requestOptions.extra = err.requestOptions.extra
      ..addAll(extra.toExtra());

    log('[${err.requestOptions.uri}] An error occurred during request, trying again (remaining tries: ${extra.retries}, error: ${err.error})');

    try {
      final response = await dio.request(
        err.requestOptions.path,
        cancelToken: err.requestOptions.cancelToken,
        data: err.requestOptions.data,
        onReceiveProgress: err.requestOptions.onReceiveProgress,
        onSendProgress: err.requestOptions.onSendProgress,
        queryParameters: err.requestOptions.queryParameters,
        options: err.requestOptions.toOptions(),
      );
      handler.resolve(response);
    } catch (error) {
      if (error is DioException) {
        if (extra.retries > 0) {
          return onError(error, handler);
        } else {
          handler.next(error);
        }
      } else {
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: error,
        ));
      }
    }
  }
}

typedef RetryEvaluator = FutureOr<bool> Function(DioException error);

extension RequestOptionsExtensions on RequestOptions {
  Options toOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
    );
  }
}

class RetryOptions {
  final int retries;
  final Duration retryInterval;
  RetryEvaluator get retryEvaluator => _retryEvaluator ?? defaultRetryEvaluator;

  final RetryEvaluator? _retryEvaluator;

  const RetryOptions(
      {this.retries = 3,
      RetryEvaluator? retryEvaluator,
      this.retryInterval = const Duration(seconds: 1)})
      : _retryEvaluator = retryEvaluator;

  factory RetryOptions.noRetry() {
    return const RetryOptions(
      retries: 0,
    );
  }

  static const extraKey = "cache_retry_request";

  static FutureOr<bool> defaultRetryEvaluator(DioException error) {
    final cancelError = error.type != DioExceptionType.cancel;
    final shouldRetry = cancelError;
    return shouldRetry;
  }

  factory RetryOptions.fromExtra(
      RequestOptions request, RetryOptions defaultOptions) {
    return request.extra[extraKey] ?? defaultOptions;
  }

  RetryOptions copyWith({
    int? retries,
    Duration? retryInterval,
  }) =>
      RetryOptions(
        retries: retries ?? this.retries,
        retryInterval: retryInterval ?? this.retryInterval,
      );

  Map<String, dynamic> toExtra() => {extraKey: this};

  Options toOptions() => Options(extra: toExtra());

  Options mergeIn(Options options) {
    return options.copyWith(
        extra: <String, dynamic>{}
          ..addAll(options.extra ?? {})
          ..addAll(toExtra()));
  }

  @override
  String toString() {
    return 'RetryOptions{retries: $retries, retryInterval: $retryInterval, _retryEvaluator: $_retryEvaluator}';
  }
}
