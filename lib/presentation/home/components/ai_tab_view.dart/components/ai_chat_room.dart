import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/ai_streaming_message.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/empty_ai.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/ai_message.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_footer.dart';
import 'package:communico_frontend/presentation/home/components/loading_message.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../message/my_message.dart';
import '../ai_cubit.dart';
import '../ai_state.dart';

class AiChatRoom extends StatelessWidget {
  const AiChatRoom({
    super.key,
  });
  static final cubit = getIt<AiCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiCubit, AiState>(
      bloc: cubit,
      builder: (context, state) {
        return SizedBox(
          height: 0.9.sh,
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 0.6.sh,
                  ),
                  child: Stack(
                    children: [
                      BlocBuilder<HomeCubit, HomeState>(
                          bloc: getIt<HomeCubit>(),
                          builder: (context, homeState) {
                            if (homeState.currentBackground?.image.isNotEmpty ??
                                false) {
                              return Positioned.fill(
                                child: Image.asset(
                                  homeState.currentBackground!.image,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                      state.messages.isEmpty
                          ? const EmptyAi()
                          : ListView.builder(
                              reverse: true,
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                return message.aiStream
                                    ? state.isLoading
                                        ? const LoadingMessage()
                                        : const AiStreamingMessage()
                                    : message.isAi
                                        ? AiMessage(
                                            message: message,
                                            key: ValueKey(
                                              index.toString(),
                                            ),
                                          )
                                        : MyMessage(
                                            showActions: false,
                                            message: message,
                                            key: ValueKey(
                                              index.toString(),
                                            ),
                                          );
                              }),
                    ],
                  ),
                ),
              ),
              2.verticalSpace,
              ChatRoomFooter(
                onSendMessage: () {
                  cubit.sendMessage();
                },
                onChanged: (val) {
                  state.prompt = val;
                },
                textController: state.currentAiMessageController,
              ),
            ],
          ),
        );
      },
    );
  }
}
