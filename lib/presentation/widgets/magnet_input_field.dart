import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class MagnetInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelKey;
  final String? Function(String?)? validator;
  final bool enabled;

  const MagnetInputField({
    super.key,
    required this.controller,
    required this.labelKey,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getL10nText(l10n, labelKey),
          style: theme.textTheme.textStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          enabled: enabled,
          placeholder: _getL10nText(l10n, labelKey),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.15),
              width: 1.2,
            ),
          ),
          style: theme.textTheme.textStyle,
        ),
        // validator는 별도 처리 필요시 추가 구현
      ],
    );
  }

  String _getL10nText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'magnetLink':
        return l10n.magnetLink;
      case 'enterMagnetLink':
        return l10n.enterMagnetLink;
      default:
        return key;
    }
  }
}
