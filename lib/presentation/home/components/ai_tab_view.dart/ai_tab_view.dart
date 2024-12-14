import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_cubit.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import 'components/ai_chat_room.dart';

class AiTabView extends StatelessWidget {
  const AiTabView({super.key});

  static final cubit = getIt<AiCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiCubit, AiState>(
        bloc: cubit,
        builder: (context, state) {
          String aiResponse = "";
          cubit.stream.listen((streamState) {
            aiResponse = streamState.aiResponse;
          });
          return Row(children: [
            Expanded(
                child: AiChatRoom(
              onSendMessage: () {
                cubit.sendMessage();
              },
              response: aiResponse,
              isLoading: state.isLoading,
              textController: state.currentAiMessageController,
              roomTitle: "ASK YOUR AI BUDDY",
              messages: state.messages,
            )),
          ]);
        });
  }
}
