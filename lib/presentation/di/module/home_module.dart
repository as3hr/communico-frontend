import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation_cubit.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_cubit.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:communico_frontend/presentation/home/home_navigator.dart';

import '../../../di/service_locator.dart';
import '../../home/components/group_tab_view/components/group_creation.dart/group_creation_cubit.dart';

class HomeModule {
  static Future<void> configureHomeModuleInjection() async {
    sl.registerLazySingleton<HomeNavigator>(
      () => HomeNavigator(
        sl(),
      ),
    );
    sl.registerLazySingleton<AiCubit>(
      () => AiCubit(
        sl(),
      ),
    );
    sl.registerLazySingleton<ChatCubit>(
      () => ChatCubit(sl(), sl(), sl()),
    );
    sl.registerLazySingleton<ChatCreationCubit>(
      () => ChatCreationCubit(
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton<GroupCreationCubit>(
      () => GroupCreationCubit(sl()),
    );
    sl.registerLazySingleton<GroupCubit>(
      () => GroupCubit(
        sl(),
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton<HomeCubit>(
      () => HomeCubit(
        sl(),
      ),
    );
  }
}
