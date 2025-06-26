import 'dart:convert';
import '../models/server_info.dart';
import '../storage/secure_storage.dart';

class ServerService {
  static const _serversKey = 'servers';

  Future<List<ServerInfo>> getServers() async {
    final jsonStr = await SecureStorage.read(_serversKey);
    if (jsonStr == null) return [];
    final List<dynamic> list = json.decode(jsonStr);
    return list.map((e) => ServerInfo.fromJson(e)).toList();
  }

  Future<void> saveServers(List<ServerInfo> servers) async {
    final jsonStr = json.encode(servers.map((e) => e.toJson()).toList());
    await SecureStorage.write(_serversKey, jsonStr);
  }
}
