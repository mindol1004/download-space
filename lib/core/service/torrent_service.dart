import '../models/server_info.dart';
import '../models/torrent_task.dart';
import 'remote_torrent_client_factory.dart';

class TorrentService {
  Future<List<TorrentTask>> fetchTasks(ServerInfo server) async {
    final client = RemoteTorrentClientFactory.create(server);
    await client.authenticate();
    return await client.fetchTasks();
  }

  Future<void> addMagnet(String magnet, ServerInfo server) async {
    final client = RemoteTorrentClientFactory.create(server);
    await client.authenticate();
    if (server.downloadFolder != null) {
      await client.addMagnet(magnet, downloadFolder: server.downloadFolder);
    } else {
      await client.addMagnet(magnet);
    }
  }

  Future<void> addTorrentFile(
      List<int> bytes, String name, ServerInfo server) async {
    final client = RemoteTorrentClientFactory.create(server);
    await client.authenticate();
    if (server.downloadFolder != null) {
      await client.addTorrentFile(bytes, name, downloadFolder: server.downloadFolder);
    } else {
      await client.addTorrentFile(bytes, name);
    }
  }

  Future<void> testConnection(ServerInfo server) async {
    final client = RemoteTorrentClientFactory.create(server);
    await client.authenticate();
    // 연결 테스트를 위해 간단한 API 호출 (예: 서버 정보 가져오기)
    await client.fetchTasks();
  }
}
