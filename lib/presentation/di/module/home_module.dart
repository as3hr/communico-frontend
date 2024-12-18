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
    getIt.registerLazySingleton<HomeNavigator>(
      () => HomeNavigator(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<AiCubit>(
      () => AiCubit(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<ChatCubit>(
      () => ChatCubit(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<ChatCreationCubit>(
      () => ChatCreationCubit(
        getIt(),
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GroupCreationCubit>(
      () => GroupCreationCubit(getIt()),
    );
    getIt.registerLazySingleton<GroupCubit>(
      () => GroupCubit(
        getIt(),
        getIt(),
        getIt(),
      ),
    );
    getIt.registerLazySingleton<HomeCubit>(
      () => HomeCubit(),
    );
  }
}
