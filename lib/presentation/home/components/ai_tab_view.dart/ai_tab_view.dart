import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_cubit.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import '../chat_tab_view/chat_room.dart';

class AiTabView extends StatelessWidget {
  const AiTabView({super.key});

  static final cubit = getIt<AiCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiCubit, AiState>(
        bloc: cubit,
        builder: (context, state) {
          return Row(children: [
            Expanded(
                child: ChatRoom(
              onSendMessage: () {
                cubit.sendMessage();
              },
              isAi: true,
              textController: state.currentAiMessageController,
              roomTitle: "ASK YOUR AI BUDDY",
              messages: state.messages,
            )),
          ]);
        });
  }
}
