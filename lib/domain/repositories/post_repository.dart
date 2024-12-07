import 'package:dartz/dartz.dart';
import 'package:communico_frontend/domain/entities/post_entity.dart';
import 'package:communico_frontend/domain/failures/post_failure.dart';

abstract class PostRepository {
  Future<Either<PostFailure, List<PostEntity>>> getPosts(String url);
}
