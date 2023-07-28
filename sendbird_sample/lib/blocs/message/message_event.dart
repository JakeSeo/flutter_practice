part of 'message_bloc.dart';

class MessageEvent {}

class ReceiveMessage extends MessageEvent {
  final BaseChannel channel;
  final BaseMessage message;

  ReceiveMessage({required this.channel, required this.message});
}

class FetchPreviousMessages extends MessageEvent {
  final PreviousMessageListQuery query;

  FetchPreviousMessages({required this.query});
}

class SendMessage extends MessageEvent {
  final UserMessageParams messageParams;

  SendMessage({required this.messageParams});
}
