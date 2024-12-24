import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/repositories/chat_repository.dart';
import 'package:communico_frontend/domain/repositories/user_repository.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/stores/user_store.dart';

class ChatCreationCubit extends Cubit<ChatCreationState> {
  final UserRepository userRepository;
  final ChatRepository chatRepository;
  ChatCreationCubit(this.userRepository, this.chatRepository)
      : super(ChatCreationState.empty());

  searchMembers(String value) {
    if (value.isNotEmpty) {
      final users = state.allUsers
          .where((user) =>
              user.username.toLowerCase().contains(value.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredUsers: users));
    } else {
      emit(state.copyWith(filteredUsers: [], selectedUser: UserEntity.empty()));
    }
  }

  void selectChatUser(UserEntity currentUser) {
    final users = state.filteredUsers.map((user) {
      if (user.id == currentUser.id) {
        user.isSelected = !user.isSelected;
      } else {
        user.isSelected = false;
      }
      return user;
    }).toList();

    final selectedUser =
        state.filteredUsers.where((user) => user.isSelected).toList();
    if (selectedUser.isNotEmpty) {
      state.selectedUser = selectedUser.first;
    } else {
      state.selectedUser = UserEntity.empty();
    }

    emit(
      state.copyWith(
        filteredUsers: users,
        selectedUser: state.selectedUser,
      ),
    );
  }

  fetchUsers() {
    userRepository
        .fetchUsers(url: "/users/chats/")
        .then((response) => response.fold((error) {}, (users) {
              state.allUsers = users;
            }));
  }

  Future<void> createChat() async {
    emit(state.copyWith(isLoading: true));
    final chat = ChatEntity(participants: [
      ChatParticipantsEntity(
          userId: state.selectedUser.id, user: state.selectedUser)
    ], messages: [
      MessageEntity(text: state.message, userId: user!.id),
    ]);
    await getIt<ChatCubit>().createChat(chat);
    emit(state.copyWith(isLoading: false));
  }

  void closeDialog() {
    emit(state.copyWith(selectedUser: null, filteredUsers: []));
  }

  UserEntity? get user => getIt<UserStore>().getUser();

  void onMessageChanged(String val) {
    emit(state.copyWith(message: val));
  }
}
