import '../../../data/group/api_group_repository.dart';
import '../../../di/service_locator.dart';
import '../../repositories/group_repository.dart';

class GroupModule {
  static Future<void> configureGroupModuleInjection() async {
    getIt.registerSingleton<GroupRepository>(
      ApiGroupRepository(
        getIt(),
      ),
    );
  }
}
