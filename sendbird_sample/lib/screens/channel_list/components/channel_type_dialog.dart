import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sendbird_sample/components/custom_button.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChannelTypeDialog extends StatefulWidget {
  const ChannelTypeDialog({
    super.key,
    required this.onSelectChannelType,
    this.initialType = ChannelType.open,
  });

  final Function(ChannelType) onSelectChannelType;
  final ChannelType initialType;

  @override
  State<ChannelTypeDialog> createState() => _ChannelTypeDialogState();
}

class _ChannelTypeDialogState extends State<ChannelTypeDialog> {
  ChannelType _channelType = ChannelType.open;

  @override
  initState() {
    super.initState();
    _channelType = widget.initialType;
  }

  _setChannelType(ChannelType value) {
    setState(() {
      _channelType = value;
    });
  }

  _selectChannelType() {
    context.pop();
    widget.onSelectChannelType(_channelType);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "생성할 채널을 선택해주세요:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile(
              title: const Text('오픈 채널'),
              value: ChannelType.open,
              groupValue: _channelType,
              onChanged: (_) => _setChannelType(ChannelType.open),
            ),
            RadioListTile(
              title: const Text('그룹 채널'),
              value: ChannelType.group,
              groupValue: _channelType,
              onChanged: (_) => _setChannelType(ChannelType.group),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: '취소',
                    isLoading: false,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: '채널 생성',
                    isLoading: false,
                    onPressed: _selectChannelType,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
