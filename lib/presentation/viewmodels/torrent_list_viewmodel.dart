import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/server_info.dart';
import '../../core/models/torrent_task.dart';
import '../../core/service/torrent_service.dart';

class TorrentListState {
  final List<TorrentTask> tasks;
  final bool loading;
  final String? error;

  TorrentListState({required this.tasks, this.loading = false, this.error});

  TorrentListState copyWith(
          {List<TorrentTask>? tasks, bool? loading, String? error}) =>
      TorrentListState(
        tasks: tasks ?? this.tasks,
        loading: loading ?? this.loading,
        error: error,
      );
}

class TorrentListViewModel extends StateNotifier<TorrentListState> {
  final TorrentService _service;
  TorrentListViewModel(this._service) : super(TorrentListState(tasks: []));

  Future<void> fetchTasks(ServerInfo? server) async {
    if (server == null) {
      state = state.copyWith(tasks: [], loading: false, error: null);
      return;
    }
    state = state.copyWith(loading: true, error: null);
    try {
      final tasks = await _service.fetchTasks(server);
      state = state.copyWith(tasks: tasks, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  // 필요시 addMagnet, addTorrentFile 등도 여기에 추가
}
