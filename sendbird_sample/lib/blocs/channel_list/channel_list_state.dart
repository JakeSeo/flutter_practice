part of 'channel_list_bloc.dart';

class ChannelListState {
  static const int limit = 10;

  final QueryBase query;
  final List<BaseChannel> channelList;

  const ChannelListState({
    required this.query,
    this.channelList = const <BaseChannel>[],
  });
}
