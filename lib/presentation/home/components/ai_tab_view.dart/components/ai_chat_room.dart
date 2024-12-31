import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/widgets/background_image.dart';
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
  static final cubit = sl<AiCubit>();
  static final scrollController = ScrollController();

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
                          bloc: sl<HomeCubit>(),
                          builder: (context, homeState) {
                            if (homeState.currentBackground?.image.isNotEmpty ??
                                false) {
                              return Positioned.fill(
                                child: BackgroundImage(
                                  image: homeState.currentBackground!.image,
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                      state.messages.isEmpty
                          ? const EmptyAi()
                          : ListView.builder(
                              reverse: true,
                              controller: scrollController,
                              itemCount: state.messages.length,
                              physics: (state.aiMessageInitialized ||
                                      state.isLoading)
                                  ? const NeverScrollableScrollPhysics()
                                  : const AlwaysScrollableScrollPhysics(),
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
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                    );
                  }
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
