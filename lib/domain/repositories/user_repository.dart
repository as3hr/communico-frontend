import 'package:dartz/dartz.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/failures/user_failure.dart';

abstract class UserRepository {
  Future<Either<UserFailure, UserEntity>> getIn(
      {required String username, String? password});
  Future<Either<UserFailure, UserEntity>> updatePassword(
      {required String password});
  Future<Either<UserFailure, List<UserEntity>>> fetchUsers(
      {String url = "/users/"});
}
