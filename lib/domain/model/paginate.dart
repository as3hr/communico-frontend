import 'package:flutter/material.dart';

import '../../helpers/utils.dart';
import 'base_model.dart';

class Paginate<T> {
  int skip;
  List<T> data;
  bool next;
  ScrollController scrollController;

  Paginate({
    this.skip = 0,
    bool? next,
    ScrollController? scrollController,
    List<T>? data,
  })  : data = data ?? List<T>.empty(growable: true),
        scrollController = scrollController ?? ScrollController(),
        next = next ?? ((data?.isNotEmpty ?? false) && data?.length == 25);

  factory Paginate.empty() => Paginate();

  Paginate<T> copyWith({
    bool? next,
    int? skip,
    List<T>? data,
  }) {
    return Paginate<T>(
      next: next ?? this.next,
      skip: skip ?? this.skip,
      data: data ?? this.data,
    );
  }

  factory Paginate.fromJson(
    Map<String, dynamic> json,
    Function(Map<String, dynamic>) dataFromJson,
  ) {
    return Paginate<T>(
      data: json['data'] is List && json['data'] != null
          ? parseList(json['data'], dataFromJson)
              .map((json) {
                final data = json as BaseModel;
                return data.toDomain();
              })
              .toList()
              .cast<T>()
          : [],
    );
  }
}
