part of 'message_bloc.dart';

class MessageState {
  static const int initialLimit = 20;
  static const int limit = 10;

  final PreviousMessageListQuery query;
  final List<BaseMessage> messageList;

  const MessageState({
    required this.query,
    this.messageList = const <BaseMessage>[],
  });
}
