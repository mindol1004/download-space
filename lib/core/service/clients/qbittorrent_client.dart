import 'package:dio/dio.dart';
import '../../models/server_info.dart';
import '../../models/torrent_task.dart';
import '../remote_torrent_client.dart';

class QBittorrentClient implements RemoteTorrentClient {
  final ServerInfo _serverInfo;
  final Dio _dio = Dio();
  bool _isAuthenticated = false;

  QBittorrentClient(this._serverInfo) {
    _dio.options.baseUrl =
        'http://${_serverInfo.address}:${_serverInfo.port}/api/v2';
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };
  }

  @override
  Future<void> authenticate() async {
    if (_isAuthenticated) return;
    final response = await _dio.post(
      '/auth/login',
      data: 'username=${_serverInfo.username}&password=${_serverInfo.password}',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );

    if (response.statusCode == 200 &&
        response.data.toString().trim() == 'Ok.') {
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        _dio.options.headers['cookie'] = cookies[0];
        _isAuthenticated = true;
      } else {
        throw Exception(
            'qBittorrent authentication failed: No cookie received');
      }
    } else {
      throw Exception('qBittorrent authentication failed');
    }
  }

  @override
  Future<List<TorrentTask>> fetchTasks() async {
    final response = await _dio.get('/torrents/info');
    if (response.statusCode == 200) {
      final tasks = response.data as List;
      return tasks
          .map((task) => TorrentTask.fromQBittorrentJson(task))
          .toList();
    } else {
      throw Exception('Failed to fetch tasks from qBittorrent');
    }
  }

  @override
  Future<void> addMagnet(String magnetUri, {String? downloadFolder}) async {
    final formData = FormData.fromMap({
      'urls': magnetUri,
      if (downloadFolder != null) 'savepath': downloadFolder,
    });
    await _dio.post('/torrents/add', data: formData);
  }

  @override
  Future<void> addTorrentFile(List<int> fileBytes, String fileName, {String? downloadFolder}) async {
    final formData = FormData.fromMap({
      'torrents': MultipartFile.fromBytes(fileBytes, filename: fileName),
      if (downloadFolder != null) 'savepath': downloadFolder,
    });
    await _dio.post('/torrents/add', data: formData);
  }

  @override
  Future<void> removeTask(String id, bool deleteData) async {
    await _dio.post(
      '/torrents/delete',
      data: 'hashes=$id&deleteFiles=$deleteData',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );
  }
}
