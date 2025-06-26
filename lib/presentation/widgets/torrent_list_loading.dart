import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class TorrentListLoading extends StatelessWidget {
  const TorrentListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CupertinoActivityIndicator(radius: 18),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.loadingTorrentList,
            style: theme.textTheme.textStyle.copyWith(
              color: CupertinoColors.systemGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
