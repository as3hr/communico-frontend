import '../../../di/service_locator.dart';
import '../../dio/dio_client.dart';
import '../../dio/interceptors/network_interceptor.dart';

class DioModule {
  static Future<void> configureDioModuleInjection() async {
    sl.registerSingleton<NetworkInterceptor>(
      NetworkInterceptor(),
    );
    sl.registerSingleton<DioClient>(
      DioClient(
        interceptors: [
          sl<NetworkInterceptor>(),
        ],
      ),
    );
  }
}
