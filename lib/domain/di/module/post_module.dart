import '../../../data/post/api_post_repository.dart';
import '../../../di/service_locator.dart';
import '../../repositories/post_repository.dart';

class PostModule {
  static Future<void> configurePostModuleInjection() async {
    getIt.registerSingleton<PostRepository>(
      ApiPostRepository(
        getIt(),
      ),
    );
  }
}
