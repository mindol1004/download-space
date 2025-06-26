import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/server_info.dart';
import '../../core/service/torrent_service.dart';

class AddDownloadState {
  final bool loading;
  final String? error;
  final String? errorType;

  AddDownloadState({this.loading = false, this.error, this.errorType});

  AddDownloadState copyWith({bool? loading, String? error, String? errorType}) => AddDownloadState(
    loading: loading ?? this.loading,
    error: error,
    errorType: errorType,
  );
}

class AddDownloadViewModel extends StateNotifier<AddDownloadState> {
  final TorrentService _service;
  AddDownloadViewModel(this._service) : super(AddDownloadState());

  void setError(String error, {String? errorType}) {
    state = state.copyWith(error: error, errorType: errorType);
  }

  void clearError() {
    state = state.copyWith(error: null, errorType: null);
  }

  Future<void> addMagnet(String magnet, ServerInfo server) async {
    state = state.copyWith(loading: true, error: null, errorType: null);
    try {
      await _service.addMagnet(magnet, server);
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), errorType: 'magnet');
    }
  }

  Future<void> addTorrentFile(
      List<int> bytes, String name, ServerInfo server) async {
    state = state.copyWith(loading: true, error: null, errorType: null);
    try {
      await _service.addTorrentFile(bytes, name, server);
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), errorType: 'file');
    }
  }
}
