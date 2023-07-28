import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sendbird_sample/utils/extensions.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'message_bubble_pointer_shape.dart';
import '../message_content.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.showUser = false,
    required this.showTimestamp,
  });

  final BaseMessage message;
  final bool isCurrentUser;
  final bool showUser;
  final bool showTimestamp;

  Widget getTimestampWidget(Color color) {
    return Text(
      message.createdAt.parseTimestamp(),
      style: TextStyle(
        fontSize: 12,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCurrentUser) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                showTimestamp
                    ? getTimestampWidget(Colors.grey)
                    : const SizedBox(),
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: MessageContent(
                      message: message,
                      isCurrentUser: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: MessageBubblePointerShape(
              color: Colors.blue,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MessageBubblePointerShape(
              color: Colors.grey.shade300,
              mirrored: true,
            ),
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: MessageContent(message: message),
                  ),
                ),
                const SizedBox(width: 4),
                Row(
                  children: [
                    showTimestamp
                        ? getTimestampWidget(Colors.grey)
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
