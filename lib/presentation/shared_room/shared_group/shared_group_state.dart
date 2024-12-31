import '../../../domain/entities/group_entity.dart';

class SharedGroupState {
  GroupEntity group;
  bool isLoading;
  bool messageLoading;
  String encryptedData;

  SharedGroupState({
    required this.group,
    this.isLoading = false,
    this.messageLoading = false,
    this.encryptedData = "",
  });

  factory SharedGroupState.empty() => SharedGroupState(
        group: GroupEntity.empty(),
      );

  SharedGroupState copyWith({
    GroupEntity? group,
    bool? isLoading,
    bool? messageLoading,
    String? encryptedData,
  }) {
    return SharedGroupState(
      group: group ?? this.group,
      isLoading: isLoading ?? this.isLoading,
      messageLoading: messageLoading ?? this.messageLoading,
      encryptedData: encryptedData ?? this.encryptedData,
    );
  }
}
