import 'package:sendbird_sdk/sendbird_sdk.dart';

class SendbirdRepository {
  SendbirdSdk sendbirdSdk =
      SendbirdSdk(appId: '6F88352A-DCCA-4975-ACDE-A9B65B152BCB');

  addChannelEventHandler(ChannelEventHandler handler) {
    sendbirdSdk.addChannelEventHandler('channel_handler', handler);
  }
}
