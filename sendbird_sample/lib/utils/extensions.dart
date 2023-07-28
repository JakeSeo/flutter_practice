import 'package:intl/intl.dart';

extension TimestampParsing on int {
  String parseTimestamp() {
    var now = DateTime.now();
    var format = DateFormat('a HH:mm', 'ko');
    var date = DateTime.fromMicrosecondsSinceEpoch(this * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      time = '${diff.inDays}일 전';
    }

    return time;
  }
}
