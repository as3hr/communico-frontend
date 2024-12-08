import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/model/user_json.dart';
import 'package:universal_html/html.dart';

import '../entities/user_entity.dart';

class UserStore extends Cubit<UserEntity> {
  UserStore() : super(UserEntity.empty());

  UserEntity get appUser => state;

  void setUser(UserEntity user) async {
    window.localStorage["user"] = jsonEncode(user);
  }

  UserEntity? getUser() {
    if (state.id != 0) return state;
    final result = window.localStorage["user"];
    if (result == null) return null;
    final user = jsonDecode(result);
    return UserJson.fromJson(user).toDomain();
  }
}
