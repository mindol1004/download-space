import '../../core/models/torrent_task.dart';

abstract class RemoteTorrentClient {
  Future<String?> authenticate();
  Future<List<TorrentTask>> fetchTasks();
  Future<void> addMagnet(String magnetUri, {String? downloadFolder});
  Future<void> addTorrentFile(List<int> fileBytes, String fileName, {String? downloadFolder});
  Future<void> removeTask(String id, bool deleteData);
}
