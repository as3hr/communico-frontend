import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/failures/chat_failure.dart';
import 'package:dartz/dartz.dart';

import '../model/paginate.dart';

abstract class ChatRepository {
  Future<Either<ChatFailure, Paginate<ChatEntity>>> getMyChats();
  Future<Either<ChatFailure, ChatEntity>> createChat(ChatEntity chatEntity);
}
