import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_bloc.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_strategy.dart';
import 'package:sendbird_sample/routes/app_routes.dart';
import 'package:sendbird_sample/screens/channel_list/components/channel_list_item.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class GroupChannelTab extends StatefulWidget {
  const GroupChannelTab({
    super.key,
    required this.bloc,
  });

  final ChannelListBloc bloc;

  @override
  State<GroupChannelTab> createState() => _GroupChannelTabState();
}

class _GroupChannelTabState extends State<GroupChannelTab>
    with AutomaticKeepAliveClientMixin {
  _onTapChannelItem({
    required BaseChannel channel,
  }) {
    context.goNamed(
      AppRoutes.chatRoom.name,
      pathParameters: {
        'channelType': channel.channelType.name,
        'chatRoomId': channel.channelUrl,
      },
      extra: widget.bloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ChannelListBloc, ChannelListState>(
        builder: (context, state) {
      if (!state.query.loading && state.channelList.isEmpty) {
        return const Center(
          child: Text("그룹채널이 없습니다.\n 추가해주세요!"),
        );
      }
      return ListView.separated(
        itemCount: state.channelList.length + 1,
        itemBuilder: (context, index) {
          if (index == state.channelList.length) {
            if (!state.query.hasNext) {
              return const SizedBox();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          GroupChannel channel = state.channelList[index] as GroupChannel;
          return BlocBuilder<ChannelListBloc, ChannelListState>(
              builder: (context, state) {
            return ChannelListItem(
              channel: channel,
              onTap: () => _onTapChannelItem(
                channel: channel,
              ),
            );
          });
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
