import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/repositories/chat_repository.dart';
import 'package:communico_frontend/domain/repositories/group_repository.dart';
import 'package:communico_frontend/domain/repositories/message_repository.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';

import '../../di/service_locator.dart';
import '../../domain/stores/user_store.dart';

class HomeCubit extends Cubit<HomeState> {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final GroupRepository groupRepository;
  HomeCubit(
    this.chatRepository,
    this.groupRepository,
    this.messageRepository,
  ) : super(HomeState.empty());

  Future<void> fetchData() async {
    emit(state.copyWith(isLoading: true));
    await Future.wait([
      getChats(),
      getGroups(),
    ]);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> getChats() async {
    chatRepository.getMyChats().then(
          (response) => response.fold(
            (error) {},
            (chatPagination) {
              emit(state.copyWith(
                chatPagination: chatPagination,
                currentChat: chatPagination.data.first,
              ));
            },
          ),
        );
  }

  Future<void> getGroups() async {
    groupRepository.getMyGroups().then(
          (response) => response.fold(
            (error) {},
            (groupPagination) {
              emit(state.copyWith(
                groupPagination: groupPagination,
                currentGroup: groupPagination.data.first,
              ));
            },
          ),
        );
  }

  getChatMessages() {
    messageRepository.getMessages("/messages/", {
      "chatId": state.currentChat.id,
    });
  }

  getGroupMessages() {
    messageRepository.getMessages("/messages/", {
      "groupId": state.currentGroup.id,
    });
  }

  void updateCurrentChat(ChatEntity chat) {
    emit(state.copyWith(currentChat: chat));
  }

  void updateCurrentGroup(GroupEntity group) {
    emit(state.copyWith(currentGroup: group));
  }

  bool isMyMessage(MessageEntity message) {
    return getIt<UserStore>().getUser() != null &&
            (getIt<UserStore>().getUser()!.id == message.userId)
        ? true
        : false;
  }
}
