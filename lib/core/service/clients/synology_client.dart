import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/server_info.dart';
import '../../models/torrent_task.dart';
import '../remote_torrent_client.dart';

// API 이름과 세션 타입을 상수로 관리하여 오타 방지 및 가독성 향상
class _ApiConstants {
  static const String auth = 'SYNO.API.Auth';
  static const String fileStationList = 'SYNO.FileStation.List';
  static const String downloadStationTask = 'SYNO.DownloadStation.Task';

  static const String fileStationSession = 'FileStation';
  static const String downloadStationSession = 'DownloadStation';
}

final synologyClientProvider = Provider.family<SynologyClient, ServerInfo>((ref, serverInfo) {
  return SynologyClient(serverInfo);
});

class SynologyClient implements RemoteTorrentClient {
  final ServerInfo _serverInfo;
  final Dio _dio = Dio();
  // 세션 타입을 Key로 사용하여 여러 SID를 효율적으로 관리
  final Map<String, String?> _sids = {};

  SynologyClient(this._serverInfo) {
    _setupDio();
  }

  void _setupDio() {
    // 웹 환경에서는 CORS 프록시 사용
    if (kIsWeb) {
      _dio.options.baseUrl = 'https://3001-firebase-download-space-app-1750923546730.cluster-bg6uurscprhn6qxr6xwtrhvkf6.cloudworkstations.dev/api/synology';
      _dio.options.headers['X-Target-Server'] = '${_serverInfo.address}:${_serverInfo.port}';
      _dio.options.extra['withCredentials'] = true;
    } else {
      // 네이티브 환경에서는 직접 연결
      _dio.options.baseUrl = 'https://${_serverInfo.address}:${_serverInfo.port}/webapi';
    }

    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (kDebugMode) {
          print('Synology API Error: ${error.message}');
          print('Error Response: ${error.response?.statusCode} - ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }

  /// 모든 API 요청을 처리하는 중앙 헬퍼 메서드
  Future<Map<String, dynamic>> _makeRequest({
    required String sessionType,
    required String api,
    required String method,
    required int version,
    Map<String, dynamic> params = const {},
    bool isPost = false,
    FormData? formData,
  }) async {
    // 1. 세션 확인 및 획득
    if (_sids[sessionType] == null) {
      _sids[sessionType] = await _authenticateForSession(sessionType);
    }

    // 2. 요청 파라미터 구성
    final allParams = {
      'api': api,
      'method': method,
      'version': version.toString(),
      '_sid': _sids[sessionType],
      ...params,
    };

    try {
      // 3. API 요청 실행
      final response = isPost
          ? await _dio.post('/entry.cgi', data: formData, queryParameters: allParams)
          : await _dio.get('/entry.cgi', queryParameters: allParams);

      // 4. 응답 파싱 및 반환
      final Map<String, dynamic> data = _parseResponseData(response.data);

      if (data['success'] == true) {
        return data['data'] ?? <String, dynamic>{};
      } else {
        final error = data['error'];
        final errorCode = error?['code']?.toString() ?? 'Unknown error';
        // 세션 만료 에러(119) 처리
        if (errorCode == '119') {
          _sids[sessionType] = null; // 만료된 세션 초기화
          // 재시도를 위해 특정 예외 발생
          throw Exception('Session expired (119)'); 
        }
        throw Exception('API Error for $api: $errorCode');
      }
    } on Exception catch (e) {
       // 세션 만료 시, 자동으로 1회 재시도
      if (e.toString().contains('Session expired')) {
         if (kDebugMode) print('Session for $sessionType expired. Re-authenticating and retrying...');
         _sids[sessionType] = await _authenticateForSession(sessionType);
         // 재시도 로직을 위해 다시 호출 (재귀 깊이 주의)
         return _makeRequest(sessionType: sessionType, api: api, method: method, version: version, params: params, isPost: isPost, formData: formData);
      }
      rethrow;
    }
  }

  /// 세션별 인증을 처리하는 내부 메서드
  Future<String?> _authenticateForSession(String sessionType) async {
    if (kDebugMode) print('Authenticating for session: $sessionType');
    try {
      final response = await _dio.get('/entry.cgi', queryParameters: {
        'api': _ApiConstants.auth,
        'version': '7',
        'method': 'login',
        'account': _serverInfo.username,
        'passwd': _serverInfo.password,
        'session': sessionType,
        'format': 'sid',
      });
      final data = _parseResponseData(response.data);
      if (data['success'] == true) {
        final sid = data['data']['sid'] as String;
        if (kDebugMode) print('Authentication successful for $sessionType, SID: $sid');
        return sid;
      } else {
        final error = data['error'];
        final errorCode = error?['code']?.toString() ?? 'Unknown';
        throw Exception('Authentication failed for $sessionType: $errorCode');
      }
    } catch (e) {
      if (kDebugMode) print('Error during authentication for $sessionType: $e');
      rethrow;
    }
  }

  /// DownloadStation 인증 (RemoteTorrentClient 인터페이스 구현)
  @override
  Future<String?> authenticate() {
    return _authenticateForSession(_ApiConstants.downloadStationSession);
  }

  /// 폴더 목록 조회
  Future<List<String>> fetchFolders(String path) async {
    final isRoot = path == '/' || path.isEmpty;
    final data = await _makeRequest(
      sessionType: _ApiConstants.fileStationSession,
      api: _ApiConstants.fileStationList,
      method: isRoot ? 'list_share' : 'list',
      version: 2,
      params: isRoot ? {} : {'folder_path': path},
    );

    final List<dynamic> items = data[isRoot ? 'shares' : 'files'] ?? [];
    final List<String> folders = [];
    for (var item in items) {
      if (item['isdir'] == true) {
        folders.add(item['path'] as String);
      }
    }
    return folders;
  }

  @override
  Future<List<TorrentTask>> fetchTasks() async {
    final data = await _makeRequest(
      sessionType: _ApiConstants.downloadStationSession,
      api: _ApiConstants.downloadStationTask,
      method: 'list',
      version: 3, // 최신 버전 사용 권장
      params: {'additional': 'detail,transfer'},
    );
    final tasks = data['tasks'] as List? ?? [];
    return tasks.map((task) => TorrentTask.fromSynologyJson(task)).toList();
  }

  @override
  Future<void> addMagnet(String magnetUri, {String? downloadFolder}) {
    return _makeRequest(
      sessionType: _ApiConstants.downloadStationSession,
      api: _ApiConstants.downloadStationTask,
      method: 'create',
      version: 3,
      params: {
        'uri': magnetUri,
        if (downloadFolder != null) 'destination': downloadFolder,
      },
    );
  }

  @override
  Future<void> addTorrentFile(List<int> fileBytes, String fileName, {String? downloadFolder}) {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });
    return _makeRequest(
      sessionType: _ApiConstants.downloadStationSession,
      api: _ApiConstants.downloadStationTask,
      method: 'create',
      version: 3,
      params: {
        if (downloadFolder != null) 'destination': downloadFolder,
      },
      isPost: true,
      formData: formData,
    );
  }

  @override
  Future<void> removeTask(String id, bool deleteData) {
    return _makeRequest(
      sessionType: _ApiConstants.downloadStationSession,
      api: _ApiConstants.downloadStationTask,
      method: 'delete',
      version: 3,
      params: {
        'id': id,
        'force_complete': deleteData.toString(),
      },
    );
  }

  /// 응답 데이터를 안전하게 JSON으로 파싱하는 헬퍼
  Map<String, dynamic> _parseResponseData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    if (responseData is String) {
      try {
        return jsonDecode(responseData) as Map<String, dynamic>;
      } catch (e) {
        if (kDebugMode) print('Failed to parse response string as JSON: $e');
        throw Exception('Invalid JSON response format from server.');
      }
    }
    throw Exception('Unsupported response data type: ${responseData.runtimeType}');
  }

  /// 모든 세션 로그아웃
  Future<void> logout() async {
    for (final sessionType in _sids.keys) {
      if (_sids[sessionType] != null) {
        try {
          await _dio.get('/auth.cgi', queryParameters: {
            'api': _ApiConstants.auth,
            'method': 'logout',
            'version': '1',
            'session': sessionType,
            '_sid': _sids[sessionType],
          });
          if (kDebugMode) print('Logged out from $sessionType session.');
        } catch (e) {
          if (kDebugMode) print('Error logging out from $sessionType: $e');
        }
      }
    }
    _sids.clear();
  }
}
