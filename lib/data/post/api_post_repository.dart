import 'package:dartz/dartz.dart';
import 'package:communico_frontend/domain/entities/post_entity.dart';
import 'package:communico_frontend/domain/failures/post_failure.dart';
import 'package:communico_frontend/domain/model/post_json.dart';
import 'package:communico_frontend/domain/repositories/post_repository.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/network/network_repository.dart';

class ApiPostRepository implements PostRepository {
  final NetworkRepository networkRepository;
  ApiPostRepository(this.networkRepository);

  @override
  Future<Either<PostFailure, List<PostEntity>>> getPosts(String url) async {
    final response = await networkRepository.get(url: url);
    if (response.failed) {
      return left(PostFailure(error: response.message));
    }
    final posts = parseList(response.data, PostJson.fromJson)
        .map((post) => post.toDomain())
        .cast<PostEntity>()
        .toList();
    return right(posts);
  }
}
