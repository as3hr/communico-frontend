import 'dart:async';

import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/failures/message_failure.dart';
import 'package:communico_frontend/domain/repositories/message_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/model/message_json.dart';
import '../../domain/model/paginate.dart';
import '../../helpers/utils.dart';

class ApiMessageRepository implements MessageRepository {
  final NetworkRepository networkRepository;
  ApiMessageRepository(this.networkRepository);

  @override
  Future<Either<MessageFailure, Paginate<MessageEntity>>> getMessages(
    Paginate<MessageEntity> previousMessages,
    String url, {
    Map<String, dynamic>? extraQuery,
  }) async {
    final response = await networkRepository.get(
      url: url,
      extraQuery: {...?extraQuery, "skip": previousMessages.skip},
    );
    if (response.failed) {
      return left(MessageFailure(error: response.message));
    }

    final pagination = updatedPagination<MessageEntity>(
      previousData: previousMessages,
      data: response.data,
      dataFromJson: MessageJson.fromJson,
    );

    return right(pagination);
  }
}
