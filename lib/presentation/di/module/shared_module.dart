import 'package:communico_frontend/presentation/shared_room/shared_chat/shared_chat_cubit.dart';
import 'package:communico_frontend/presentation/shared_room/shared_group/shared_group_cubit.dart';

import '../../../di/service_locator.dart';

class SharedModule {
  static Future<void> configureSharedModuleInjection() async {
    sl.registerLazySingleton<SharedChatCubit>(
      () => SharedChatCubit(
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton<SharedGroupCubit>(
      () => SharedGroupCubit(sl(), sl()),
    );
  }
}
