import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class DividerWithText extends StatelessWidget {
  final String textKey;
  const DividerWithText({super.key, required this.textKey});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.2,
            color: CupertinoColors.systemGrey4.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _getLocalizedText(l10n, textKey),
            style: theme.textTheme.textStyle.copyWith(
              color: CupertinoColors.systemGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.2,
            color: CupertinoColors.systemGrey4.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  String _getLocalizedText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'or':
        return l10n.or;
      // 필요시 추가 키 매핑
      default:
        return key;
    }
  }
}
