import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/settings_viewmodel.dart';

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>(
  (ref) => SettingsViewModel(),
);
