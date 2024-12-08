import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/failures/chat_failure.dart';
import 'package:communico_frontend/domain/model/paginate.dart';
import 'package:communico_frontend/domain/repositories/chat_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/model/chat_json.dart';

class ApiChatRepository implements ChatRepository {
  final NetworkRepository networkRepository;
  ApiChatRepository(this.networkRepository);

  @override
  Future<Either<ChatFailure, ChatEntity>> createChat(ChatEntity entity) async {
    final response =
        await networkRepository.post(url: "/chats/", data: entity.toJson());
    if (response.failed) {
      return left(ChatFailure(error: response.message));
    }
    return right(ChatJson.fromJson(response.data).toDomain());
  }

  @override
  Future<Either<ChatFailure, Paginate<ChatEntity>>> getMyChats() async {
    final response = await networkRepository.get(url: "/chats/");
    if (response.failed) {
      return left(ChatFailure(error: response.message));
    }
    final chat =
        Paginate<ChatEntity>.fromJson(response.data, ChatJson.fromJson);
    return right(chat);
  }
}
