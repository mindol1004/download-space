import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/server_info.dart';
import '../../core/service/server_service.dart';

class ServerEditState {
  final bool loading;
  final String? error;
  final ServerInfo? server;

  ServerEditState({this.loading = false, this.error, this.server});

  ServerEditState copyWith(
          {bool? loading, String? error, ServerInfo? server}) =>
      ServerEditState(
        loading: loading ?? this.loading,
        error: error,
        server: server ?? this.server,
      );
}

class ServerEditViewModel extends StateNotifier<ServerEditState> {
  final ServerService _service;
  ServerEditViewModel(this._service, [ServerInfo? initial])
      : super(ServerEditState(server: initial));

  Future<void> saveServer(
      ServerInfo server, List<ServerInfo> allServers) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final exists = allServers.any((e) => e.id == server.id);
      final newList = exists
          ? allServers.map((e) => e.id == server.id ? server : e).toList()
          : [...allServers, server];
      await _service.saveServers(newList);
      state = state.copyWith(loading: false, server: server);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
