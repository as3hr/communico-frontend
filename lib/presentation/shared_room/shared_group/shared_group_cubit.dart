import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/group_entity.dart';
import '../../../domain/repositories/group_repository.dart';
import '../../../domain/repositories/message_repository.dart';
import 'shared_group_state.dart';

class SharedGroupCubit extends Cubit<SharedGroupState> {
  final GroupRepository groupRepository;
  final MessageRepository messageRepository;
  SharedGroupCubit(this.groupRepository, this.messageRepository)
      : super(SharedGroupState.empty());

  void loadGroup(String encryptedData) {
    emit(state.copyWith(isLoading: true));
    groupRepository
        .decryptGroupId(encryptedData)
        .then((response) => response.fold(
              (failure) => emit(state.copyWith(isLoading: false)),
              (group) {
                state.group = group;
                getGroupMessages(state.group);
              },
            ));
  }

  getGroupMessages(GroupEntity group) {
    messageRepository.getMessages(
      state.group.messagePagination,
      "/messages/groups",
      {
        "groupId": group.id,
      },
    ).then((response) => response.fold(
          (failure) => emit(state.copyWith(isLoading: false)),
          (messagePagination) {
            state.group.messagePagination = messagePagination;
            emit(state.copyWith(group: state.group, isLoading: false));
          },
        ));
  }

  Future<void> scrollAndCallMessages() async {
    if (!state.messageLoading) {
      emit(state.copyWith(messageLoading: true));
      if (state.group.messagePagination.next ||
          state.group.messagePagination.data.isEmpty) {
        await getGroupMessages(state.group);
        emit(state.copyWith(messageLoading: false));
      }
    }
  }
}
