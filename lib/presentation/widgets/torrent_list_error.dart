import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class TorrentListError extends StatelessWidget {
  final Object error;
  const TorrentListError({super.key, required this.error});

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
              color: CupertinoColors.systemRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              size: 48,
              color: CupertinoColors.systemRed,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.errorOccurred,
            style: theme.textTheme.navTitleTextStyle.copyWith(
              color: CupertinoColors.systemRed,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error.toString(),
              style: theme.textTheme.textStyle.copyWith(
                color: CupertinoColors.systemGrey,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
