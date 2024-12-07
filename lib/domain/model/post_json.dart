import 'package:communico_frontend/domain/entities/post_entity.dart';

class PostJson {
  String? title;
  String? body;

  PostJson({
    this.body,
    this.title,
  });

  factory PostJson.fromJson(Map<String, dynamic> json) => PostJson(
        title: json["title"],
        body: json["body"],
      );

  PostEntity toDomain() => PostEntity(
        title: title,
        body: body,
      );
}
