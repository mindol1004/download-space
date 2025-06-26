import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../widgets/language_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);
    final settings = ref.watch(settingsViewModelProvider);
    final settingsNotifier = ref.read(settingsViewModelProvider.notifier);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.settings),
        previousPageTitle: l10n.cancel,
        border: null,
        backgroundColor: theme.barBackgroundColor.withValues(alpha: 0.95),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme.barBackgroundColor.withValues(alpha: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: LanguageSelector(
                    locale: settings.locale,
                    onLocaleChanged: settingsNotifier.setLocale,
                  ),
                ),
              ),
              // 다크모드 토글 등 추가 가능
            ],
          ),
        ),
      ),
    );
  }
}
