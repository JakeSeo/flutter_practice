import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'channel_list_bloc.dart';

class ChannelListHandler with ChannelEventHandler {
  final ChannelListBloc bloc;

  ChannelListHandler(this.bloc);

  _groupChannelChanged(GroupChannel channel) {
    if (channel.unreadMessageCount > 0) {
      bloc.add(ChannelChanged(
        channel: channel,
        event: ChannelChangedEvent.messageAdded,
      ));
    } else {
      bloc.add(ChannelChanged(
        channel: channel,
        event: ChannelChangedEvent.refresh,
      ));
    }
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    if (channel.channelType != bloc.channelType) return;

    switch (channel.channelType) {
      case ChannelType.group:
        _groupChannelChanged(channel as GroupChannel);
        break;
      case ChannelType.open:
        break;
    }
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {}
}
