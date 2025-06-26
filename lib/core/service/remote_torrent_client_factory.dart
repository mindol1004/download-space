import '../models/server_info.dart';
import 'clients/qbittorrent_client.dart';
import 'clients/synology_client.dart';
import 'remote_torrent_client.dart';

class RemoteTorrentClientFactory {
  static RemoteTorrentClient create(ServerInfo serverInfo) {
    switch (serverInfo.type) {
      case ServerType.synology:
        return SynologyClient(serverInfo);
      case ServerType.qbittorrent:
        return QBittorrentClient(serverInfo);
      default:
        throw UnimplementedError(
            'Client for ${serverInfo.type} is not implemented.');
    }
  }
}
