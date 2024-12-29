import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/failures/group_failure.dart';
import 'package:communico_frontend/domain/model/group_json.dart';
import 'package:communico_frontend/domain/model/paginate.dart';
import 'package:communico_frontend/domain/model/user_json.dart';
import 'package:communico_frontend/domain/repositories/group_repository.dart';
import 'package:communico_frontend/network/network_repository.dart';
import 'package:dartz/dartz.dart';

import '../../helpers/utils.dart';

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
    return right(GroupJson.fromJson(response.data["data"]).toDomain());
  }

  @override
  Future<Either<GroupFailure, Paginate<GroupEntity>>> getMyGroups(
      Paginate<GroupEntity> previousGroups) async {
    final response = await networkRepository.get(url: "/groups", extraQuery: {
      "skip": previousGroups.skip,
    });
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }

    final pagination = updatedPagination<GroupEntity>(
      previousData: previousGroups,
      data: response.data,
      dataFromJson: GroupJson.fromJson,
    );

    return right(pagination);
  }

  @override
  Future<Either<GroupFailure, GroupEntity>> updateGroup(
    GroupEntity entity,
  ) async {
    final response = await networkRepository.put(
        url: "/groups/${entity.id}", data: entity.toJson());
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }
    return right(GroupJson.fromJson(response.data["data"]).toDomain());
  }

  @override
  Future<Either<GroupFailure, List<UserEntity>>> getMembers(
    int groupId,
  ) async {
    final response = await networkRepository.get(
      url: "/groups/${groupId.toString()}/members",
    );
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }
    final users = parseList(response.data["data"], UserJson.fromJson)
        .map((json) => json.toDomain())
        .toList();
    return right(users);
  }

  @override
  Future<Either<GroupFailure, String>> encryptGroupLink(int groupId) async {
    final response = await networkRepository.get(url: "/groups/link/$groupId");
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }
    return right(response.data['data']);
  }

  @override
  Future<Either<GroupFailure, GroupEntity>> decryptGroupId(
      String encryptedGroupId) async {
    final response =
        await networkRepository.get(url: "/groups/dcrypt", extraQuery: {
      "encryptedData": encryptedGroupId,
    });
    if (response.failed) {
      return left(GroupFailure(error: response.message));
    }
    return right(GroupJson.fromJson(response.data["data"]).toDomain());
  }
}
