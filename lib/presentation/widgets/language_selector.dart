import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.globe,
                color: CupertinoColors.activeBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.language,
                style: theme.textTheme.navTitleTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildLanguageOption(
          context,
          locale,
          l10n.korean,
          const Locale('ko', 'KR'),
          CupertinoIcons.flag,
        ),
        const SizedBox(height: 12),
        _buildLanguageOption(
          context,
          locale,
          l10n.english,
          const Locale('en', 'US'),
          CupertinoIcons.flag,
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    Locale currentLocale,
    String title,
    Locale locale,
    IconData icon,
  ) {
    final isSelected = currentLocale.languageCode == locale.languageCode;
    final theme = CupertinoTheme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: () {
          onLocaleChanged(locale);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primaryColor.withValues(alpha: 0.08)
                : theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? theme.primaryColor
                  : CupertinoColors.systemGrey4.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.13),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primaryColor
                      : CupertinoColors.systemGrey4.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color:
                      isSelected ? CupertinoColors.white : theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.textStyle.copyWith(
                    color: isSelected
                        ? theme.primaryColor
                        : theme.textTheme.textStyle.color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.check_mark,
                    color: CupertinoColors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
