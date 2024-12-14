import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/failures/message_failure.dart';
import 'package:dartz/dartz.dart';

import '../model/paginate.dart';

abstract class MessageRepository {
  Future<Either<MessageFailure, Paginate<MessageEntity>>> getMessages(
    Paginate<MessageEntity> previousMessages,
    String url,
    Map<String, dynamic>? extraQuery,
  );

  Stream<Either<MessageFailure, String>> getAiResponse(String prompt);
}
