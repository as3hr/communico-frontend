import '../../../data/message/api_message_repository.dart';
import '../../../di/service_locator.dart';
import '../../repositories/message_repository.dart';

class MessageModule {
  static Future<void> configureMessageModuleInjection() async {
    getIt.registerSingleton<MessageRepository>(
      ApiMessageRepository(getIt()),
    );
  }
}
