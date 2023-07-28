enum AppRoutes {
  splash(
    path: '/splash',
    completePath: '/splash',
    name: 'splash',
  ),
  channels(
    path: '/channels/:channelType',
    completePath: '/channels/:channelType',
    name: 'channels',
  ),
  login(
    path: '/login',
    completePath: '/login',
    name: 'login',
  ),
  chatRoom(
    path: ':chatRoomId',
    completePath: '/channels/:channelType/:chatRoomId',
    name: 'chatRoom',
  ),
  createChannel(
    path: 'create',
    completePath: '/channels/:channelType/create',
    name: 'createChannel',
  );

  final String path, completePath, name;
  const AppRoutes({
    required this.path,
    required this.completePath,
    required this.name,
  });
}
