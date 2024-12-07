import '../../../di/service_locator.dart';
import '../../dio/dio_client.dart';
import '../../dio/interceptors/network_interceptor.dart';

class DioModule {
  static Future<void> configureDioModuleInjection() async {
    getIt.registerSingleton<NetworkInterceptor>(
      NetworkInterceptor(),
    );
    getIt.registerSingleton<DioClient>(
      DioClient(
        interceptors: [
          getIt<NetworkInterceptor>(),
        ],
      ),
    );
  }
}
