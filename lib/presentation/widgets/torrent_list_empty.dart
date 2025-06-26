import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class TorrentListEmpty extends StatelessWidget {
  const TorrentListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              CupertinoIcons.cloud_download,
              size: 64,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noTorrentTasks,
            style: theme.textTheme.navTitleTextStyle.copyWith(
              color: CupertinoColors.label,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addNewDownload,
            style: theme.textTheme.textStyle.copyWith(
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
