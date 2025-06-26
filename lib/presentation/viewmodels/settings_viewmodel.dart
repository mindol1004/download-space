import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

class SettingsState {
  final Locale locale;
  final Brightness brightness;

  SettingsState({required this.locale, required this.brightness});

  SettingsState copyWith({Locale? locale, Brightness? brightness}) =>
      SettingsState(
        locale: locale ?? this.locale,
        brightness: brightness ?? this.brightness,
      );
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  SettingsViewModel()
      : super(SettingsState(
          locale: const Locale('ko', 'KR'),
          brightness: Brightness.light,
        ));

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  void setBrightness(Brightness brightness) {
    state = state.copyWith(brightness: brightness);
  }
}
