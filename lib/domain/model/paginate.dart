import '../../helpers/utils.dart';
import 'base_model.dart';

class Paginate<T> {
  String? previous;
  String? next;
  int count;
  List<T> data;

  Paginate({
    this.previous,
    this.next,
    this.count = 0,
    List<T>? data,
  }) : data = data ?? List<T>.empty(growable: true);

  factory Paginate.empty() => Paginate();

  Paginate<T> copyWith({
    String? previous,
    String? next,
    int? count,
    List<T>? data,
  }) {
    return Paginate<T>(
      previous: previous ?? this.previous,
      next: next ?? this.next,
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }

  factory Paginate.fromJson(
    Map<String, dynamic> json,
    Function(Map<String, dynamic>) dataFromJson,
  ) {
    return Paginate<T>(
      // count: json['count'],
      // previous: json['previous'],
      // next: json['next'],
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

  Map<String, dynamic> toJson(List<Map<String, dynamic>> mappedIssues) => {
        'count': count,
        'previous': previous,
        'next': next,
        'data': mappedIssues,
      };
}
