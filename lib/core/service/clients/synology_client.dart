import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/server_info.dart';
import '../../models/torrent_task.dart';
import '../remote_torrent_client.dart';

class SynologyClient implements RemoteTorrentClient {
  final ServerInfo _serverInfo;
  final Dio _dio = Dio();
  String? _sid;

  SynologyClient(this._serverInfo) {
    _setupDio();
  }

  void _setupDio() {
    if (kIsWeb) {
      // 웹 환경에서는 CORS 문제를 해결하기 위해 프록시 사용
      _dio.options.baseUrl = 'http://localhost:3001/api/synology';
      _dio.options.headers['X-Target-Server'] =
          '${_serverInfo.address}:${_serverInfo.port}';
      _dio.options.extra['withCredentials'] = true;
    } else {
      // 네이티브 환경에서는 직접 연결
      _dio.options.baseUrl =
          'http://${_serverInfo.address}:${_serverInfo.port}/webapi';
    }

    // 공통 설정
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 10);

    // 에러 처리
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('Synology API Error: ${error.message}');
        if (error.response?.statusCode == 403) {
          print('CORS Error detected. Please check proxy configuration.');
        }
        handler.next(error);
      },
    ));
  }

  @override
  Future<void> authenticate() async {
    if (_sid != null) return;

    try {
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
        throw Exception(
            'Synology authentication failed: ${response.data['error']?['code']}');
      }
    } catch (e) {
      if (e.toString().contains('CORS') ||
          e.toString().contains('XMLHttpRequest')) {
        throw Exception('CORS 오류가 발생했습니다. 프록시 서버를 실행하거나 브라우저 확장 프로그램을 사용하세요.');
      } else if (e.toString().contains('Failed to connect') ||
          e.toString().contains('Connection refused')) {
        throw Exception('서버에 연결할 수 없습니다. 주소와 포트를 확인하세요.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('연결 시간이 초과되었습니다. 네트워크 상태를 확인하세요.');
      }
      rethrow;
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
  Future<void> addTorrentFile(List<int> fileBytes, String fileName,
      {String? downloadFolder}) async {
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
