import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/failures/group_failure.dart';
import 'package:communico_frontend/domain/model/group_json.dart';
import 'package:communico_frontend/domain/model/paginate.dart';
import 'package:communico_frontend/domain/repositories/group_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';
import 'package:dartz/dartz.dart';

class ApiGroupRepository implements GroupRepository {
  final NetworkRepository networkRepository;
  ApiGroupRepository(this.networkRepository);

  @override
  Future<Either<GroupFailure, GroupEntity>> createGroup(
    GroupEntity entity,
  ) async {
    final response =
        await networkRepository.post(url: "/groups/", data: entity.toJson());
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }
    return right(GroupJson.fromJson(response.data).toDomain());
  }

  @override
  Future<Either<GroupFailure, Paginate<GroupEntity>>> getMyGroups() async {
    final response = await networkRepository.get(url: "/groups/");
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }
    final group =
        Paginate<GroupEntity>.fromJson(response.data, GroupJson.fromJson);
    return right(group);
  }
}
