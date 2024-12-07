import 'dart:async';

import 'package:dio/dio.dart';

import '../service/network_monitor.dart';
import 'dio/dio_client.dart';
import 'network_response.dart';

class NetworkRepository {
  final DioClient dioClient;
  final NetworkMonitor networkMonitor;
  NetworkRepository(this.dioClient, this.networkMonitor);

  Future<NetworkResponse> request({
    required String method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await networkMonitor.checkConnection()) {
      throw NetworkResponse(
        message: "No internet connection",
        data: null,
        code: 500,
        success: "false",
      );
    }

    final completer = Completer<NetworkResponse>();
    late NetworkResponse networkResponse;
    StreamSubscription? networkSubscription;

    networkSubscription = networkMonitor.onConnectivityChanged.listen(
      (hasConnection) {
        if (!hasConnection && !completer.isCompleted) {
          networkResponse = NetworkResponse(
            message: "Internet connection lost",
            data: null,
            failed: true,
            code: 500,
            success: "false",
          );
          completer.completeError(networkResponse);
        }
      },
    );
    try {
      final response = await dioClient.dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      networkResponse = _handleResponse(response);
      completer.complete(networkResponse);
    } on DioException catch (e) {
      if (!completer.isCompleted) {
        networkResponse = DioClient.handleDioError(e);
        networkResponse.failed = true;
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } on NetworkResponse catch (e) {
      if (!completer.isCompleted) {
        networkResponse = e;
        networkResponse.failed = true;
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } catch (e) {
      if (!completer.isCompleted) {
        networkResponse = NetworkResponse(
          message: "An unexpected error occurred",
          data: null,
          code: 500,
          success: "false",
          failed: true,
        );
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } finally {
      await networkSubscription.cancel();
    }

    return networkResponse;
  }

  Future<NetworkResponse> get({
    required String url,
    Map<String, dynamic>? extraQuery,
  }) =>
      request(
        method: 'GET',
        url: url,
        queryParameters: extraQuery,
      );

  Future<NetworkResponse> post({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'POST',
        url: url,
        data: data,
      );

  Future<NetworkResponse> patch({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'PATCH',
        url: url,
        data: data,
      );

  Future<NetworkResponse> put({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'PUT',
        url: url,
        data: data,
      );

  Future<NetworkResponse> delete({required String url}) => request(
        method: 'DELETE',
        url: url,
      );

  NetworkResponse _handleResponse(Response response) {
    final body = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        data: body,
      );
    }
    throw NetworkResponse(failed: true);
  }
}
