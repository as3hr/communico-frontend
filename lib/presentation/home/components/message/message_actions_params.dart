import '../../../../domain/entities/message_entity.dart';

class MessageActionsParams {
  final void Function(MessageEntity entity) onReply;
  final void Function(MessageEntity entity)? onDelete;
  final void Function(MessageEntity entity)? onUpdate;

  MessageActionsParams({
    required this.onReply,
    this.onDelete,
    this.onUpdate,
  });
}
