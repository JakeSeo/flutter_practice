import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sendbird_sample/routes/app_routes.dart';
import 'package:sendbird_sample/screens/create_channel/forms/create_group_channel_form.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import '../../blocs/channel_list/channel_list_bloc.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({
    super.key,
    required this.type,
    required this.bloc,
  });

  final ChannelType type;
  final ChannelListBloc bloc;

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  late String appBarTitle;
  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case ChannelType.group:
        appBarTitle = '그룹채널 생성';
        break;
      case ChannelType.open:
        appBarTitle = '오픈채널 생성';
        break;
    }
  }

  Future<void> _createGroupChannel({required GroupChannelParams params}) async {
    try {
      // await Future.delayed(const Duration(seconds: 2));
      final channel = await GroupChannel.createChannel(params);
      widget.bloc.add(
        ChannelChanged(
          channel: channel,
          event: ChannelChangedEvent.channelAdded,
        ),
      );
      if (mounted) {
        context.pop();
        context.goNamed(
          AppRoutes.chatRoom.name,
          pathParameters: {
            'channelType': channel.channelType.name,
            'chatRoomId': channel.channelUrl,
          },
          extra: widget.bloc,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Builder(
        builder: (context) {
          switch (widget.type) {
            case ChannelType.group:
              return CreateGroupChannelForm(
                onCreate: _createGroupChannel,
              );
            case ChannelType.open:
              return const Center(child: Text("오픈채널 생성"));
          }
        },
      ),
    );
  }
}
