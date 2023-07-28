import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'message_bloc.dart';

class MessageHandler with ChannelEventHandler {
  final MessageBloc messageBloc;

  MessageHandler({
    required this.messageBloc,
  });

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    if (messageBloc.channel.channelUrl != channel.channelUrl) return;

    messageBloc.add(ReceiveMessage(channel: channel, message: message));
  }
}
