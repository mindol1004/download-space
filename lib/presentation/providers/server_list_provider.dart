import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/server_list_viewmodel.dart';
import '../../core/service/server_service.dart';

final serverServiceProvider = Provider<ServerService>((ref) => ServerService());

final serverListViewModelProvider =
    StateNotifierProvider<ServerListViewModel, ServerListState>(
  (ref) => ServerListViewModel(ref.watch(serverServiceProvider)),
);
