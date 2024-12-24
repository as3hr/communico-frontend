import 'package:communico_frontend/helpers/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/failures/user_failure.dart';
import 'package:communico_frontend/domain/model/user_json.dart';
import 'package:communico_frontend/domain/repositories/user_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';

import '../../di/service_locator.dart';
import '../../domain/stores/user_store.dart';

class ApiUserRepository implements UserRepository {
  final NetworkRepository networkRepository;
  ApiUserRepository(this.networkRepository);

  @override
  Future<Either<UserFailure, UserEntity>> getIn(
      {required String username, String? password}) async {
    final data = {
      'username': username.trim(),
      'password': password?.trim(),
    };
    final response = await networkRepository.post(url: "/users/", data: data);
    if (response.failed) {
      return left(UserFailure(error: response.message));
    }
    final user = UserJson.fromJson(response.data["data"]).toDomain();
    getIt<UserStore>().setUser(user);
    return right(user);
  }

  @override
  Future<Either<UserFailure, UserEntity>> updatePassword(
      {required String password}) async {
    final response = await networkRepository.put(url: "/users/", data: {
      'password': password.trim(),
    });
    if (response.failed) {
      return left(UserFailure(error: response.message));
    }
    final user = UserJson.fromJson(response.data["data"]).toDomain();
    getIt<UserStore>().setUser(user);
    return right(user);
  }

  @override
  Future<Either<UserFailure, List<UserEntity>>> fetchUsers(
      {String url = "/users/"}) async {
    final response = await networkRepository.get(url: url);
    if (response.failed) {
      return left(UserFailure(error: response.message));
    }
    final users = parseList(response.data["data"], UserJson.fromJson)
        .map((user) => user.toDomain())
        .toList();
    return right(users);
  }
}
