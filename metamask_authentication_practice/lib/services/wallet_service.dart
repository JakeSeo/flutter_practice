import 'package:get/get.dart';
import 'package:metamask_authentication_practice/services/auth_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';

class WalletService extends GetxService {
  late WalletConnect connector;

  @override
  void onInit() {
    super.onInit();
    initWallet();
  }

  Future<WalletConnectSession?> _getSecureStorageSession() async {
    try {
      return await WalletConnectSecureStorage().getSession();
    } catch (e) {
      print('WalletService _getSecureStorageSession() error: $e');
    }
    return null;
  }

  initWallet() async {
    final sessionStorage = WalletConnectSecureStorage();
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      session: await _getSecureStorageSession(),
      sessionStorage: sessionStorage,
      clientMeta: const PeerMeta(
        name: 'Pottery',
        description: 'Polygon Lottery!',
        url: 'https://walletconnect.org',
        icons: [
          'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    print("connected: ${connector.connected}");

    Get.find<AuthService>().isLoggedIn.value = connector.connected;

    connector.on('connect', _onConnect);
    connector.on('session_update', _onSessionUpdate);
    connector.on('disconnect', _onDisconnect);
  }

  _onConnect(SessionStatus session) {
    connector.session.accounts[0];
    print('onConnect');
  }

  _onSessionUpdate(WCSessionUpdateResponse payload) {
    print('onSessionUpdate');
  }

  _onDisconnect(Map<String, dynamic> payload) {
    print('onDisconnect');
  }

  connectToMetamask() async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          print(uri);
          await launchUrlString('metamask://wc?uri=$uri',
              mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
      } catch (exp) {
        print(exp);
      }
    }
  }
}
