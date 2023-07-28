import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_bloc.dart';
import 'package:sendbird_sample/blocs/message/message_handler.dart';
import 'package:sendbird_sample/screens/chat_room/components/message_bubble/message_bubble.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/message/message_bloc.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.channelType,
    required this.channelUrl,
    required this.channelListBloc,
  });

  final ChannelType channelType;
  final String channelUrl;
  final ChannelListBloc channelListBloc;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();

  late final AuthBloc authBloc;
  BaseChannel? channel;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initChannel();
    });
  }

  _initChannel() async {
    switch (widget.channelType) {
      case ChannelType.group:
        channel = await GroupChannel.getChannel(widget.channelUrl);
        break;
      case ChannelType.open:
        channel = await OpenChannel.getChannel(widget.channelUrl);
        break;
    }
    if (mounted) {
      setState(() {});
    }
  }

  _sendMessage(BuildContext context) {
    final message = _inputController.text;

    if (message.isEmpty) {
      return;
    }

    final messageParams = UserMessageParams(message: message);
    BlocProvider.of<MessageBloc>(context)
        .add(SendMessage(messageParams: messageParams));

    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channel?.name ?? widget.channelUrl),
      ),
      body: Builder(builder: (context) {
        if (channel == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return BlocProvider<MessageBloc>(
          create: (context) {
            MessageState initialState = MessageState(
              query: PreviousMessageListQuery(
                channelType: widget.channelType,
                channelUrl: widget.channelUrl,
              )
                ..reverse = true
                ..limit = MessageState.initialLimit,
            );
            MessageBloc bloc = MessageBloc(
              initialState,
              repository: authBloc.repository,
              channel: channel!,
              channelListBloc: widget.channelListBloc,
            )..add(FetchPreviousMessages(query: initialState.query));

            return bloc;
          },
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      return ListView.separated(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: state.messageList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.messageList.length) {
                            if (state.query.hasNext) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return const SizedBox();
                          }
                          final message = state.messageList[index];
                          BaseMessage? prevMessage;
                          if (index > 0) {
                            prevMessage = state.messageList[index - 1];
                          }
                          final showTimestamp = prevMessage == null ||
                              prevMessage.sender?.userId !=
                                  message.sender?.userId;
                          final isCurrentUser = message.sender?.userId ==
                              BlocProvider.of<AuthBloc>(context)
                                  .repository
                                  .sendbirdSdk
                                  .currentUser
                                  ?.userId;
                          return MessageBubble(
                            message: message,
                            isCurrentUser: isCurrentUser,
                            showTimestamp: showTimestamp,
                          );
                        },
                        separatorBuilder: (context, index) {
                          if (index + 1 == state.messageList.length) {
                            return const SizedBox(height: 24);
                          }
                          final message = state.messageList[index];
                          final nextMessage = state.messageList[index + 1];
                          if (message.sender?.userId ==
                              nextMessage.sender?.userId) {
                            return const SizedBox(height: 8);
                          }
                          return const SizedBox(height: 24);
                        },
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<MessageBloc, MessageState>(
                            builder: (context, state) {
                          return TextField(
                            controller: _inputController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () => _sendMessage(context),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
