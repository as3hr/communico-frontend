import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/failures/chat_failure.dart';
import 'package:dartz/dartz.dart';

import '../model/paginate.dart';

abstract class ChatRepository {
  Future<Either<ChatFailure, Paginate<ChatEntity>>> getMyChats(
      Paginate<ChatEntity> previousChats);
  Future<Either<ChatFailure, ChatEntity>> createChat(ChatEntity chatEntity);
  Future<Either<ChatFailure, String>> encryptChatLink(int chatId);
  Future<Either<ChatFailure, ChatEntity>> decryptChatId(String encryptedChatId);
}
