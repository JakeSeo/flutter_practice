import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({
    super.key,
    required this.message,
    this.isCurrentUser = false,
  });

  final BaseMessage message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    if (message is UserMessage) {
      return Text(
        message.message,
        style: TextStyle(
          color: isCurrentUser ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      );
    } else if (message is FileMessage) {
      var url = (message as FileMessage).secureUrl;
      if (url == null || url.isEmpty) {
        return Image.file((message as FileMessage).localFile!);
      }
      return Image.network(
        (message as FileMessage).secureUrl!,
      );
    } else if (message is AdminMessage) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.manage_accounts),
          Text((message as AdminMessage).message),
        ],
      );
    }

    return const SizedBox();
  }
}
