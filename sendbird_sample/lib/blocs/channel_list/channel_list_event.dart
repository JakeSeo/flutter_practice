part of 'channel_list_bloc.dart';

class ChannelListEvent {}

class FetchChannelList extends ChannelListEvent {}

enum ChannelChangedEvent {
  messageAdded,
  channelAdded,
  refresh,
}

class ChannelChanged extends ChannelListEvent {
  final BaseChannel channel;
  final ChannelChangedEvent event;

  ChannelChanged({
    required this.channel,
    required this.event,
  });
}

class RefreshChannelList extends ChannelListEvent {}
