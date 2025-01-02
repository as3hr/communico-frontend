import 'package:communico_frontend/domain/failures/auth_failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, bool>> verifyToken();
}
