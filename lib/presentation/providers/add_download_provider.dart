import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/add_download_viewmodel.dart';
import 'torrent_list_provider.dart';

final addDownloadViewModelProvider =
    StateNotifierProvider<AddDownloadViewModel, AddDownloadState>(
  (ref) => AddDownloadViewModel(ref.read(torrentServiceProvider)),
);
