import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/server_edit_viewmodel.dart';
import 'server_list_provider.dart';
import '../../core/models/server_info.dart';

final serverEditViewModelProvider = StateNotifierProvider.family<
    ServerEditViewModel, ServerEditState, ServerInfo?>(
  (ref, initial) =>
      ServerEditViewModel(ref.read(serverServiceProvider), initial),
);
