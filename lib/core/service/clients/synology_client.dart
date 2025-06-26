import 'package:dio/dio.dart';
import '../../models/server_info.dart';
import '../../models/torrent_task.dart';
import '../remote_torrent_client.dart';

class SynologyClient implements RemoteTorrentClient {
  final ServerInfo _serverInfo;
  final Dio _dio = Dio();
  String? _sid;

  SynologyClient(this._serverInfo) {
    _dio.options.baseUrl =
        'http://${_serverInfo.address}:${_serverInfo.port}/webapi';
  }

  @override
  Future<void> authenticate() async {
    if (_sid != null) return;
    final response = await _dio.get('/auth.cgi', queryParameters: {
      'api': 'SYNO.API.Auth',
      'version': '7',
      'method': 'login',
      'account': _serverInfo.username,
      'passwd': _serverInfo.password,
      'session': 'DownloadStation',
      'format': 'sid',
    });
    if (response.data['success']) {
      _sid = response.data['data']['sid'];
    } else {
      throw Exception('Synology authentication failed');
    }
  }

  @override
  Future<List<TorrentTask>> fetchTasks() async {
    final response = await _dio.get('/entry.cgi', queryParameters: {
      'api': 'SYNO.DownloadStation.Task',
      'version': '1',
      'method': 'list',
      'additional': 'detail,transfer',
      '_sid': _sid,
    });

    if (response.data['success']) {
      final tasks = response.data['data']['tasks'] as List;
      return tasks.map((task) => TorrentTask.fromSynologyJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks from Synology');
    }
  }

  @override
  Future<void> addMagnet(String magnetUri, {String? downloadFolder}) async {
    final queryParams = {
      'api': 'SYNO.DownloadStation.Task',
      'version': '1',
      'method': 'create',
      'uri': magnetUri,
      '_sid': _sid,
    };
    
    if (downloadFolder != null) {
      queryParams['destination'] = downloadFolder;
    }
    
    await _dio.get('/entry.cgi', queryParameters: queryParams);
  }

  @override
  Future<void> addTorrentFile(List<int> fileBytes, String fileName, {String? downloadFolder}) async {
    final formData = FormData.fromMap({
      'api': 'SYNO.DownloadStation.Task',
      'version': '1',
      'method': 'create',
      '_sid': _sid,
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      if (downloadFolder != null) 'destination': downloadFolder,
    });

    await _dio.post('/entry.cgi', data: formData);
  }

  @override
  Future<void> removeTask(String id, bool deleteData) async {
    // Synology API는 작업 제거 시 데이터 동시 삭제를 직접 지원하지 않을 수 있음
    // 필요 시 별도 로직 추가 (e.g., 파일 스테이션 API 연동)
    await _dio.get('/entry.cgi', queryParameters: {
      'api': 'SYNO.DownloadStation.Task',
      'version': '1',
      'method': 'delete',
      'id': id,
      '_sid': _sid,
    });
  }
}
