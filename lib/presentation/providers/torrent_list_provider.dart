import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/torrent_list_viewmodel.dart';
import '../../core/service/torrent_service.dart';

final torrentServiceProvider =
    Provider<TorrentService>((ref) => TorrentService());

final torrentListViewModelProvider =
    StateNotifierProvider<TorrentListViewModel, TorrentListState>(
  (ref) => TorrentListViewModel(ref.watch(torrentServiceProvider)),
);
