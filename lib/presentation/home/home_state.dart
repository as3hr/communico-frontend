import '../../domain/entities/post_entity.dart';

class HomeState {
  bool isLoading;
  List<PostEntity> posts;

  HomeState({
    this.isLoading = true,
    required this.posts,
  });

  factory HomeState.empty() => HomeState(posts: []);

  copyWith({bool? isLoading, List<PostEntity>? posts}) => HomeState(
        posts: posts ?? this.posts,
        isLoading: isLoading ?? this.isLoading,
      );
}
