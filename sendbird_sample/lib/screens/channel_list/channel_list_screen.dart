import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sendbird_sample/blocs/auth/auth_bloc.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_bloc.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_strategy.dart';
import 'package:sendbird_sample/routes/app_routes.dart';
import 'package:sendbird_sample/screens/channel_list/components/channel_type_dialog.dart';
import 'package:sendbird_sample/screens/channel_list/tabs/group_channel_tab.dart';
import 'package:sendbird_sample/screens/channel_list/tabs/open_channel_tab.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({super.key, this.type = ChannelType.open});

  final ChannelType type;

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late AuthBloc _authBloc;

  late ChannelListBloc groupChannelListBloc;
  late ChannelListBloc openChannelListBloc;

  @override
  initState() {
    super.initState();
    int initialTabIndex = 0;
    if (widget.type == ChannelType.group) {
      initialTabIndex = 1;
    }
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialTabIndex,
    );

    _initChannelListBlocs();
  }

  _initChannelListBlocs() async {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    final openChannelListStrategy = OpenChannelListStrategy(
      defaultQuery: OpenChannelListQuery()..limit = ChannelListState.limit,
    );
    openChannelListBloc = ChannelListBloc(
      ChannelListState(query: openChannelListStrategy.defaultQuery),
      strategy: openChannelListStrategy,
      repository: _authBloc.repository,
      channelType: ChannelType.open,
    )..add(FetchChannelList());

    final groupChannelListStrategy = GroupChannelListStrategy(
      defaultQuery: PublicGroupChannelListQuery()
        ..includeEmptyChannel = true
        ..membershipFilter = PublicGroupChannelMembershipFilter.all
        ..order = PublicGroupChannelListOrder.chronological
        ..limit = ChannelListState.limit,
    );
    groupChannelListBloc = ChannelListBloc(
      ChannelListState(query: groupChannelListStrategy.defaultQuery),
      strategy: groupChannelListStrategy,
      repository: _authBloc.repository,
      channelType: ChannelType.group,
    )..add(FetchChannelList());
  }

  _logout() {
    BlocProvider.of<AuthBloc>(context).add(Logout());
  }

  _goToCreateChannelScreen(ChannelType type) {
    ChannelListBloc bloc;
    switch (type) {
      case ChannelType.group:
        bloc = groupChannelListBloc;
        break;
      case ChannelType.open:
        bloc = openChannelListBloc;
        break;
    }
    context.goNamed(
      AppRoutes.createChannel.name,
      pathParameters: {
        'channelType': type.name,
      },
      extra: bloc,
    );
  }

  _openCreateChannelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ChannelTypeDialog(
          initialType: widget.type,
          onSelectChannelType: _goToCreateChannelScreen,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedOut) {
          context.goNamed(AppRoutes.login.name);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '채널 목록 ${_authBloc.repository.sendbirdSdk.currentUser?.userId ?? ''}'),
          actions: [
            IconButton(
              onPressed: () => _logout(),
              icon: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    );
                  }
                  return const Icon(Icons.logout);
                },
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(child: Text("오픈")),
              Tab(child: Text("그룹")),
            ],
            onTap: (value) {
              switch (value) {
                case 0:
                  context.goNamed(
                    AppRoutes.channels.name,
                    pathParameters: {
                      'channelType': 'open',
                    },
                  );
                  break;
                case 1:
                  context.goNamed(
                    AppRoutes.channels.name,
                    pathParameters: {
                      'channelType': 'group',
                    },
                  );
                  break;
              }
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BlocProvider<ChannelListBloc>(
              create: (context) => openChannelListBloc,
              child: const OpenChannelTab(),
            ),
            BlocProvider<ChannelListBloc>(
              create: (context) => groupChannelListBloc,
              child: GroupChannelTab(bloc: groupChannelListBloc),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openCreateChannelDialog(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
