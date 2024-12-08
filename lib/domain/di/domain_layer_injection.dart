import 'package:communico_frontend/domain/di/module/chat_module.dart';
import 'package:communico_frontend/domain/di/module/group_module.dart';
import 'package:communico_frontend/domain/di/module/message_module.dart';

import 'module/user_module.dart';

class DomainLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await UserModule.configureUserModuleInjection();
    await ChatModule.configureChatModuleInjection();
    await GroupModule.configureGroupModuleInjection();
    await MessageModule.configureMessageModuleInjection();
  }
}
