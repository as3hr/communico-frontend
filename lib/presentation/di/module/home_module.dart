import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_cubit.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';

import '../../../di/service_locator.dart';

class HomeModule {
  static Future<void> configureHomeModuleInjection() async {
    getIt.registerLazySingleton<AiCubit>(
      () => AiCubit(),
    );
    getIt.registerLazySingleton<ChatCubit>(
      () => ChatCubit(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<GroupCubit>(
      () => GroupCubit(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<HomeCubit>(
      () => HomeCubit()..fetchData(),
    );
  }
}
