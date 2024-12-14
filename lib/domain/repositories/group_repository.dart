import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/failures/group_failure.dart';
import 'package:communico_frontend/domain/model/paginate.dart';
import 'package:dartz/dartz.dart';

abstract class GroupRepository {
  Future<Either<GroupFailure, Paginate<GroupEntity>>> getMyGroups(
      Paginate<GroupEntity> previousGroups);
  Future<Either<GroupFailure, GroupEntity>> createGroup(GroupEntity entity);
}
