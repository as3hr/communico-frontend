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
      String url,
      Map<String, dynamic>? extraQuery) async {
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

  @override
  Stream<Either<MessageFailure, String>> getAiResponse(String prompt) async* {
    // final stream = Gemini.instance
    //     .promptStream(parts: [Part.text(prompt)], model: "gemini-1.5-flash-8b");
    // await for (var data in stream) {
    //   dynamic output = data?.content?.parts?.first;
    //   if (output != null) {
    //     yield right(output.text.toString());
    //   }
    // }
    // final dio = Dio(
    //   BaseOptions(
    //     baseUrl: baseApiUrl,
    //     connectTimeout: const Duration(seconds: 10),
    //     receiveTimeout: const Duration(seconds: 20),
    //   ),
    // );

    // try {
    //   String? token = window.localStorage['authToken'];
    //   final response = await dio.post(
    //     "/ai",
    //     data: {
    //       "prompt": prompt,
    //     },
    //     options: Options(
    //       responseType: ResponseType.stream,
    //       headers: {"Authorization": "Bearer $token"},
    //     ),
    //   );

    //   await for (List<int> chunk in (response.data as ResponseBody).stream) {
    //     final stringChunk = utf8.decode(chunk);
    //     if (stringChunk.isNotEmpty) {
    //       yield right(stringChunk);
    //     }
    //   }
    // } on DioException catch (e) {
    //   yield left(MessageFailure(error: e.message ?? ""));
    // } catch (e) {
    //   yield left(MessageFailure(error: e.toString()));
    // }
  }
}
