import 'package:go_router/go_router.dart';
import 'package:sendbird_sample/blocs/channel_list/channel_list_bloc.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import '../screens/screens.dart';
import 'app_routes.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRoutes.splash.completePath,
      ),
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.channels.path,
        name: AppRoutes.channels.name,
        builder: (context, state) {
          final typeString = state.pathParameters['channelType'];
          ChannelType? type;
          switch (typeString) {
            case 'open':
              type = ChannelType.open;
              break;
            case 'group':
              type = ChannelType.group;
              break;
          }
          return ChannelListScreen(
            type: type ?? ChannelType.open,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.createChannel.path,
            name: AppRoutes.createChannel.name,
            builder: (context, state) {
              final typeString = state.pathParameters['channelType'];
              ChannelType? type;
              switch (typeString) {
                case 'open':
                  type = ChannelType.open;
                  break;
                case 'group':
                  type = ChannelType.group;
                  break;
              }
              final bloc = state.extra as ChannelListBloc;
              return CreateChannelScreen(
                type: type ?? ChannelType.open,
                bloc: bloc,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.chatRoom.path,
            name: AppRoutes.chatRoom.name,
            builder: (context, state) {
              final typeString = state.pathParameters['channelType'];
              ChannelType? type;
              switch (typeString) {
                case 'open':
                  type = ChannelType.open;
                  break;
                case 'group':
                  type = ChannelType.group;
                  break;
              }
              return ChatRoomScreen(
                channelType: type ?? ChannelType.open,
                channelUrl: state.pathParameters['chatRoomId']!,
                channelListBloc: state.extra as ChannelListBloc,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (context, state) => LoginScreen(),
      ),
    ],
  );
}
