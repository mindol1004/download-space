import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 임포트
import '../../models/server_info.dart';
import '../../models/torrent_task.dart';
import '../remote_torrent_client.dart';

// QBittorrentClient 프로바이더 정의
final qbittorrentClientProvider = Provider.family<QBittorrentClient, ServerInfo>((ref, serverInfo) {
  return QBittorrentClient(serverInfo);
});

class QBittorrentClient implements RemoteTorrentClient {
  final ServerInfo _serverInfo;
  final Dio _dio = Dio();
  bool _isAuthenticated = false;

  QBittorrentClient(this._serverInfo) {
    _setupDio();
  }

  void _setupDio() {
    if (kIsWeb) {
      // 웹 환경에서는 CORS 문제를 해결하기 위해 프록시 사용
      _dio.options.baseUrl = 'http://localhost:3001/api/qbittorrent';
      _dio.options.headers['X-Target-Server'] =
          '${_serverInfo.address}:${_serverInfo.port}';
    } else {
      // 네이티브 환경에서는 직접 연결
      _dio.options.baseUrl =
          'http://${_serverInfo.address}:${_serverInfo.port}/api/v2';
    }

    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    // 에러 처리
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (kDebugMode) {
          print('QBittorrent API Error: ${error.message}');
          print('Error Response: ${error.response?.statusCode} - ${error.response?.data}');
        }
        if (error.response?.statusCode == 403) {
          if (kDebugMode) {
            print('CORS Error detected. Please check proxy configuration.');
          }
        }
        handler.next(error);
      },
    ));
  }

  @override
  Future<String?> authenticate() async {
    if (_isAuthenticated) return null;

    try {
      final response = await _dio.post(
        '/auth/login',
        data: 'username=${_serverInfo.username}&password=${_serverInfo.password}',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (kDebugMode) print('QBittorrent Authentication Response: ${response.data}');

      if (response.statusCode == 200 && response.data == 'Ok.') {
        _isAuthenticated = true;
        return null;
      } else if (response.statusCode == 403) {
        throw Exception('QBittorrent authentication failed: Invalid username or password.');
      } else {
        throw Exception(
            'QBittorrent authentication failed: ${response.data ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e.toString().contains('CORS') ||
          e.toString().contains('XMLHttpRequest')) {
        throw Exception('CORS 오류가 발생했습니다. 프록시 서버를 실행하거나 브라우저 확장 프로그램을 사용하세요.');
      }
      else if (e.toString().contains('Failed to connect') ||
          e.toString().contains('Connection refused')) {
        throw Exception('서버에 연결할 수 없습니다. 주소와 포트를 확인하세요.');
      }
      else if (e.toString().contains('timeout')) {
        throw Exception('연결 시간이 초과되었습니다. 네트워크 상태를 확인하세요.');
      }
      rethrow;
    }
  }

  @override
  Future<List<TorrentTask>> fetchTasks() async {
    final response = await _dio.get('/torrents/info');
    if (response.statusCode == 200) {
      final tasks = response.data as List;
      return tasks.map((task) => TorrentTask.fromQBittorrentJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks from qBittorrent: ${response.statusCode}');
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
  Future<void> addTorrentFile(List<int> fileBytes, String fileName,
      {String? downloadFolder}) async {
    final formData = FormData.fromMap({
      'torrents': MultipartFile.fromBytes(fileBytes, filename: fileName),
      if (downloadFolder != null) 'savepath': downloadFolder,
    });
    await _dio.post('/torrents/add', data: formData);
  }

  @override
  Future<void> removeTask(String id, bool deleteData) async {
    final formData = FormData.fromMap({
      'hashes': id,
      'deleteFiles': deleteData ? 'true' : 'false',
    });
    await _dio.post('/torrents/delete', data: formData);
  }
}
