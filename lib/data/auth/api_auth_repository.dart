import 'package:communico_frontend/domain/failures/auth_failure.dart';
import 'package:communico_frontend/domain/repositories/auth_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';
import 'package:dartz/dartz.dart';

class ApiAuthRepository implements AuthRepository {
  final NetworkRepository networkRepository;
  ApiAuthRepository(this.networkRepository);
  @override
  Future<Either<AuthFailure, bool>> verifyToken() async {
    final response = await networkRepository.post(url: "/auth/verify");
    if (response.failed) {
      return left(AuthFailure(error: response.message));
    }
    return right(response.data["isAuthenticated"]);
  }
}
