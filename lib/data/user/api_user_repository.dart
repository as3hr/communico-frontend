import 'package:dartz/dartz.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/failures/post_failure.dart';
import 'package:communico_frontend/domain/model/user_json.dart';
import 'package:communico_frontend/domain/repositories/user_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';

class ApiUserRepository implements UserRepository {
  final NetworkRepository networkRepository;
  ApiUserRepository(this.networkRepository);

  @override
  Future<Either<UserFailure, UserEntity>> getIn(String username) async {
    final response = await networkRepository.post(url: "/users/", data: {
      "username": username,
    });
    if (response.failed) {
      return left(UserFailure(error: response.message));
    }
    final user = UserJson.fromJson(response.data["data"]).toDomain();
    return right(user);
  }
}
