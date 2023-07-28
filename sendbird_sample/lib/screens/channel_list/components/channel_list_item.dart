import 'package:flutter/material.dart';
import 'package:sendbird_sample/utils/extensions.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChannelListItem extends StatelessWidget {
  const ChannelListItem({
    super.key,
    required this.channel,
    required this.onTap,
  });

  final BaseChannel channel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      title: Text(channel.name ?? ''),
      subtitle: Text((channel as GroupChannel).lastMessage?.message ?? ''),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              '${(channel as GroupChannel).lastMessage?.createdAt.parseTimestamp() ?? channel.createdAt?.parseTimestamp()}'),
          ((channel as GroupChannel).unreadMessageCount != 0)
              ? Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade400,
                  ),
                  child: Center(
                    child: Text(
                      '${(channel as GroupChannel).unreadMessageCount < 100 ? (channel as GroupChannel).unreadMessageCount : '99+'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 20, width: 20),
        ],
      ),
    );
  }
}
