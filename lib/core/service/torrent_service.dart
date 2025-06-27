import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 임포트
import '../models/server_info.dart';
import '../models/torrent_task.dart';
// import 'remote_torrent_client_factory.dart'; // 더 이상 필요 없음
import 'clients/synology_client.dart';
import 'clients/qbittorrent_client.dart';
import 'remote_torrent_client.dart';

// TorrentService 프로바이더 정의
final torrentServiceProvider = Provider<TorrentService>((ref) {
  return TorrentService(ref); // TorrentService에 ref 전달
});

class TorrentService {
  final Ref _ref; // Ref를 인스턴스 변수로 저장

  TorrentService(this._ref);

  // 서버 타입에 따라 적절한 클라이언트를 가져오는 헬퍼 메서드
  RemoteTorrentClient _getClient(ServerInfo server) {
    switch (server.type) {
      case ServerType.qbittorrent:
        return _ref.read(qbittorrentClientProvider(server));
      case ServerType.synology:
        return _ref.read(synologyClientProvider(server));
      default:
        throw Exception("지원하지 않는 서버 타입입니다.");
    }
  }

  Future<List<TorrentTask>> fetchTasks(ServerInfo server) async {
    final client = _getClient(server);
    await client.authenticate();
    return await client.fetchTasks();
  }

  Future<void> addMagnet(String magnet, ServerInfo server) async {
    final client = _getClient(server);
    await client.authenticate();
    if (server.downloadFolder != null) {
      await client.addMagnet(magnet, downloadFolder: server.downloadFolder);
    } else {
      await client.addMagnet(magnet);
    }
  }

  Future<void> addTorrentFile(
      List<int> bytes, String name, ServerInfo server) async {
    final client = _getClient(server);
    await client.authenticate();
    if (server.downloadFolder != null) {
      await client.addTorrentFile(bytes, name, downloadFolder: server.downloadFolder);
    } else {
      await client.addTorrentFile(bytes, name);
    }
  }

  Future<String?> testConnection(ServerInfo server) async {
    final client = _getClient(server);
    try {
      final sid = await client.authenticate();
      return sid;
    } catch (e) {
      if (kDebugMode) {
        print('Connection test failed: $e');
      }
      rethrow;
    }
  }

  Future<List<String>> getSynologyFolders(ServerInfo server, String path) async {
    final client = _getClient(server);
    if (client is SynologyClient) {
      return await client.fetchFolders(path);
    } else {
      throw Exception("이 서버 유형은 폴더 검색을 지원하지 않습니다.");
    }
  }
}
