import 'package:sendbird_sample/blocs/channel_list/channel_list_bloc.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_handler.dart';
import 'package:sendbird_sample/repositories/sendbird_repository.dart';
import 'package:sendbird_sdk/query/base_query.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

abstract class ChannelListStrategy {
  final QueryBase defaultQuery;

  ChannelListStrategy({required this.defaultQuery});

  addEventHandler(SendbirdRepository repository, ChannelListBloc bloc);
  removeEventHandler(SendbirdRepository repository);

  Future<List<BaseChannel>> getChannels(QueryBase query);
  Future<BaseChannel> refreshChannel(String channelUrl);
}

class OpenChannelListStrategy extends ChannelListStrategy {
  OpenChannelListStrategy({required super.defaultQuery});

  @override
  Future<List<BaseChannel>> getChannels(QueryBase query) async {
    return (await (query as OpenChannelListQuery).loadNext());
  }

  @override
  Future<BaseChannel> refreshChannel(String channelUrl) async {
    return await OpenChannel.refresh(channelUrl);
  }

  @override
  addEventHandler(SendbirdRepository repository, ChannelListBloc bloc) {
    repository.sendbirdSdk.addChannelEventHandler(
        'open_channel_list_handler', ChannelListHandler(bloc));
  }

  @override
  removeEventHandler(SendbirdRepository repository) {
    repository.sendbirdSdk
        .removeChannelEventHandler('open_channel_list_handler');
  }
}

class GroupChannelListStrategy extends ChannelListStrategy {
  GroupChannelListStrategy({required super.defaultQuery});

  @override
  Future<List<BaseChannel>> getChannels(QueryBase query) async {
    final newChannelList =
        (await (query as PublicGroupChannelListQuery).loadNext());

    for (GroupChannel channel in newChannelList) {
      print("${channel.name} ${channel.isPublic} ${channel.isDiscoverable}");
    }
    return newChannelList;
  }

  @override
  Future<BaseChannel> refreshChannel(String channelUrl) async {
    return await GroupChannel.refresh(channelUrl);
  }

  @override
  addEventHandler(SendbirdRepository repository, ChannelListBloc bloc) {
    repository.sendbirdSdk.addChannelEventHandler(
        'group_channel_list_handler', ChannelListHandler(bloc));
  }

  @override
  removeEventHandler(SendbirdRepository repository) {
    repository.sendbirdSdk
        .removeChannelEventHandler('group_channel_list_handler');
  }
}
