import '../../../../domain/entities/message_entity.dart';

class MessageActionsParams {
  final void Function(MessageEntity entity)? onDelete;
  final void Function(MessageEntity entity)? onUpdate;

  MessageActionsParams({
    this.onDelete,
    this.onUpdate,
  });
}
