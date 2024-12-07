import 'package:universal_html/html.dart';
import 'package:dio/dio.dart';

class NetworkInterceptor extends Interceptor {
  NetworkInterceptor();
  String _tokenValue = "";

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var body = response.data;
    if (body != null) {
      if (body["token"] != null) {
        _tokenValue = body['token'];
        window.localStorage['authToken'] = _tokenValue;
      }
    }
    return handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token = window.localStorage['authToken'];
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    return handler.next(options);
  }
}
