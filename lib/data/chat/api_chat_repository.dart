import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/failures/chat_failure.dart';
import 'package:communico_frontend/domain/model/paginate.dart';
import 'package:communico_frontend/domain/repositories/chat_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/model/chat_json.dart';
import '../../helpers/utils.dart';

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
    return right(ChatJson.fromJson(response.data["data"]).toDomain());
  }

  @override
  Future<Either<ChatFailure, Paginate<ChatEntity>>> getMyChats(
      Paginate<ChatEntity> previousChats) async {
    final response = await networkRepository.get(url: "/chats", extraQuery: {
      "skip": previousChats.skip,
    });
    if (response.failed) {
      return left(ChatFailure(error: response.message));
    }

    final pagination = updatedPagination<ChatEntity>(
      previousData: previousChats,
      data: response.data,
      dataFromJson: ChatJson.fromJson,
    );

    return right(pagination);
  }

  @override
  Future<Either<ChatFailure, String>> encryptChatLink(int chatId) async {
    final response = await networkRepository.get(url: "/chats/link/$chatId");
    if (response.failed) {
      return left(ChatFailure(error: response.message));
    }
    return right(response.data['data']);
  }

  @override
  Future<Either<ChatFailure, ChatEntity>> decryptChatId(
      String encryptedChatId) async {
    final response =
        await networkRepository.get(url: "/chats/dcrypt", extraQuery: {
      "encryptedData": encryptedChatId,
    });
    if (response.failed) {
      return left(ChatFailure(error: response.message));
    }
    return right(ChatJson.fromJson(response.data["data"]).toDomain());
  }
}
