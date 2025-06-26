import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/server_info.dart';
import '../../core/service/server_service.dart';

class ServerListState {
  final List<ServerInfo> servers;
  final bool loading;
  final String? error;

  ServerListState({required this.servers, this.loading = false, this.error});

  ServerListState copyWith(
          {List<ServerInfo>? servers, bool? loading, String? error}) =>
      ServerListState(
        servers: servers ?? this.servers,
        loading: loading ?? this.loading,
        error: error,
      );
}

class ServerListViewModel extends StateNotifier<ServerListState> {
  final ServerService _service;
  ServerListViewModel(this._service) : super(ServerListState(servers: []));

  Future<void> loadServers() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final servers = await _service.getServers();
      state = state.copyWith(servers: servers, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> addServer(ServerInfo server) async {
    final newList = [...state.servers, server];
    await _service.saveServers(newList);
    state = state.copyWith(servers: newList);
  }

  Future<void> updateServer(ServerInfo server) async {
    final newList =
        state.servers.map((e) => e.id == server.id ? server : e).toList();
    await _service.saveServers(newList);
    state = state.copyWith(servers: newList);
  }

  Future<void> deleteServer(String id) async {
    final newList = state.servers.where((e) => e.id != id).toList();
    await _service.saveServers(newList);
    state = state.copyWith(servers: newList);
  }
}
