import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sample/repositories/sendbird_repository.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import '../channel_list/channel_list_bloc.dart';
import '../channel_list/channel_list_strategy.dart';
import 'message_handler.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SendbirdRepository repository;
  final BaseChannel channel;
  final ChannelListBloc channelListBloc;

  MessageBloc(
    super.initialState, {
    required this.repository,
    required this.channel,
    required this.channelListBloc,
  }) {
    _initBloc();

    on<FetchPreviousMessages>(_fetchPreviousMessage);
    on<ReceiveMessage>(_receiveMessage);
    on<SendMessage>(_sendMessage);
  }

  _initBloc() async {
    repository.sendbirdSdk.addChannelEventHandler(
      'channel_handler_${channel.channelUrl}',
      MessageHandler(messageBloc: this),
    );
    if (channel.channelType == ChannelType.group) {
      if ((channel as GroupChannel).unreadMessageCount > 0) {
        _readGroupMessage(channel as GroupChannel);
      }
    } else if (channel.channelType == ChannelType.open) {}
  }

  _fetchPreviousMessage(
      FetchPreviousMessages event, Emitter<MessageState> emit) async {
    List<BaseMessage> newMessageList = [];
    if (event.query == state.query) {
      newMessageList = state.messageList;
    }

    List<BaseMessage> loadedMessageList = await event.query.loadNext();

    emit(
      MessageState(
        query: event.query,
        messageList: newMessageList.followedBy(loadedMessageList).toList(),
      ),
    );
  }

  Timer? _readMessageDebounce;

  _addMessage(Emitter<MessageState> emit, BaseMessage message) {
    emit(
      MessageState(
        query: state.query,
        messageList: [message, ...state.messageList],
      ),
    );
  }

  _readGroupMessage(GroupChannel groupChannel) async {
    if (_readMessageDebounce?.isActive ?? false) _readMessageDebounce!.cancel();
    _readMessageDebounce = Timer(const Duration(milliseconds: 500), () async {
      await groupChannel.markAsRead();
      channelListBloc.add(ChannelChanged(
        channel: groupChannel,
        event: ChannelChangedEvent.refresh,
      ));
    });
  }

  _receiveMessage(ReceiveMessage event, Emitter<MessageState> emit) async {
    _addMessage(emit, event.message);
    if (channel.channelType == ChannelType.group) {
      await _readGroupMessage(channel as GroupChannel);
    }
  }

  _sendMessage(SendMessage event, Emitter<MessageState> emit) async {
    print(
        'channel list bloc ${channelListBloc.strategy is GroupChannelListStrategy}');
    UserMessage message = channel.sendUserMessage(
      event.messageParams,
      onCompleted: ((message, error) => {
            channelListBloc.add(ChannelChanged(
              channel: channel,
              event: ChannelChangedEvent.messageAdded,
            )),
          }),
    );

    _addMessage(emit, message);
  }

  @override
  Future<void> close() {
    repository.sendbirdSdk
        .removeChannelEventHandler('channel_handler_${channel.channelUrl}');
    return super.close();
  }
}
