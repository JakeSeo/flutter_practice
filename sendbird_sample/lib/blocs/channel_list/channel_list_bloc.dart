import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_strategy.dart';
import 'package:sendbird_sample/repositories/sendbird_repository.dart';
import 'package:sendbird_sdk/query/base_query.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

part 'channel_list_event.dart';
part 'channel_list_state.dart';

class ChannelListBloc extends Bloc<ChannelListEvent, ChannelListState> {
  SendbirdRepository repository;
  ChannelListStrategy strategy;
  ChannelType channelType;

  ChannelListBloc(
    super.initialState, {
    required this.strategy,
    required this.repository,
    required this.channelType,
  }) {
    strategy.addEventHandler(repository, this);

    on<FetchChannelList>(_onFetchChannelList);
    on<RefreshChannelList>(_onRefreshChannelList);
    on<ChannelChanged>(_onChannelChanged);
  }

  _onFetchChannelList(
      FetchChannelList event, Emitter<ChannelListState> emit) async {
    List<BaseChannel> loadedChannelList =
        await strategy.getChannels(state.query);

    final newChannelList =
        state.channelList.followedBy(loadedChannelList).toList();

    emit(ChannelListState(
      channelList: newChannelList,
      query: state.query,
    ));
  }

  _onChannelChanged(
      ChannelChanged event, Emitter<ChannelListState> emit) async {
    final channelIndex = state.channelList.indexWhere(
        (channel) => channel.channelUrl == event.channel.channelUrl);

    if (channelIndex == -1) {
      _addNewChannel(event.channel, emit);
      return;
    }

    if (event.event == ChannelChangedEvent.messageAdded) {
      await _onMessageAdded(channelIndex, emit);
      return;
    }

    await _onRefreshChannel(channelIndex, emit);
  }

  _addNewChannel(BaseChannel channel, Emitter<ChannelListState> emit) {
    emit(
      ChannelListState(
        query: state.query,
        channelList: [
          channel,
          ...state.channelList,
        ],
      ),
    );
  }

  _onMessageAdded(int channelIndex, Emitter<ChannelListState> emit) async {
    final changedChannel = await strategy
        .refreshChannel(state.channelList[channelIndex].channelUrl);

    emit(
      ChannelListState(
        query: state.query,
        channelList: [
          changedChannel,
          ...state.channelList.getRange(0, channelIndex).toList(),
          ...state.channelList
              .getRange(channelIndex + 1, state.channelList.length)
        ],
      ),
    );
  }

  _onRefreshChannel(int channelIndex, Emitter<ChannelListState> emit) async {
    final changedChannel = await strategy
        .refreshChannel(state.channelList[channelIndex].channelUrl);

    emit(
      ChannelListState(
        query: state.query,
        channelList: [
          ...state.channelList.getRange(0, channelIndex).toList(),
          changedChannel,
          ...state.channelList
              .getRange(channelIndex + 1, state.channelList.length)
        ],
      ),
    );
  }

  _onRefreshChannelList(
      RefreshChannelList event, Emitter<ChannelListState> emit) {}

  @override
  Future<void> close() {
    strategy.removeEventHandler(repository);
    return super.close();
  }
}
