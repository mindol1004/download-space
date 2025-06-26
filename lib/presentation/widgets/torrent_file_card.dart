import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class TorrentFileCard extends StatelessWidget {
  final VoidCallback onPick;
  final bool loading;
  final String label;
  final String? fileName;
  const TorrentFileCard({
    super.key,
    required this.onPick,
    required this.label,
    this.loading = false,
    this.fileName,
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
                  CupertinoIcons.doc,
                  color: theme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  l10n.torrentFile,
                  style: theme.textTheme.navTitleTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CupertinoButton.filled(
            onPressed: loading ? null : onPick,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.arrow_down_doc, size: 20),
                const SizedBox(width: 8),
                Text(l10n.selectFile),
              ],
            ),
          ),
          if (fileName != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                fileName!,
                style: theme.textTheme.textStyle.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
