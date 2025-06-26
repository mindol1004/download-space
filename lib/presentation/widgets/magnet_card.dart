import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

class MagnetCard extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final String? errorKey;
  final VoidCallback? onPaste;
  final String labelKey;
  final String hintKey;
  final String? loadingKey;
  final String? Function(String?)? validator;

  const MagnetCard({
    super.key,
    required this.controller,
    required this.labelKey,
    required this.hintKey,
    this.loading = false,
    this.errorKey,
    this.onPaste,
    this.loadingKey,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.barBackgroundColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  CupertinoIcons.link,
                  color: theme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  _getL10nText(l10n, labelKey),
                  style: theme.textTheme.navTitleTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: loading ? null : onPaste,
                minimumSize: const Size(0, 0),
                child: const Icon(CupertinoIcons.doc_on_clipboard),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FormField<String>(
            validator: validator ?? (value) {
              if (value == null || value.trim().isEmpty) {
                return _getL10nText(l10n, 'requiredField');
              }
              if (!value.trim().startsWith('magnet:?')) {
                return _getL10nText(l10n, 'enterMagnetLink');
              }
              return null;
            },
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoTextField(
                    controller: controller,
                    enabled: !loading,
                    maxLines: 3,
                    placeholder: _getL10nText(l10n, hintKey),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: field.hasError 
                            ? CupertinoColors.systemRed.withValues(alpha: 0.6)
                            : theme.primaryColor.withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                    ),
                    style: theme.textTheme.textStyle,
                    onChanged: (value) {
                      field.didChange(value);
                    },
                  ),
                  if (field.hasError && !loading)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        field.errorText!,
                        style: theme.textTheme.textStyle.copyWith(
                          color: CupertinoColors.systemRed,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (errorKey != null && !loading)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _getL10nText(l10n, errorKey!),
                style: theme.textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemRed,
                  fontSize: 14,
                ),
              ),
            ),
          if (loading)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const CupertinoActivityIndicator(),
                  const SizedBox(width: 12),
                  Text(
                    loadingKey != null ? _getL10nText(l10n, loadingKey!) : '',
                    style: theme.textTheme.textStyle.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getL10nText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'magnetLink':
        return l10n.magnetLink;
      case 'enterMagnetLink':
        return l10n.enterMagnetLink;
      case 'addingDownload':
        return l10n.addingDownload;
      case 'requiredField':
        return l10n.requiredField;
      // 필요시 추가 키 매핑
      default:
        return key;
    }
  }
}
