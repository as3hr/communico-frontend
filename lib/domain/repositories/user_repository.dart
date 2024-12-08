import 'package:dartz/dartz.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/failures/user_failure.dart';

abstract class UserRepository {
  Future<Either<UserFailure, UserEntity>> getIn(String username);
}
