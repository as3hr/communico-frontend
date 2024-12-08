import '../../../data/chat/api_chat_repository.dart';
import '../../../di/service_locator.dart';
import '../../repositories/chat_repository.dart';

class ChatModule {
  static Future<void> configureChatModuleInjection() async {
    getIt.registerSingleton<ChatRepository>(
      ApiChatRepository(
        getIt(),
      ),
    );
  }
}
