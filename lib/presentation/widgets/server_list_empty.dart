import 'package:flutter/cupertino.dart';
import '../../core/localization/app_localizations.dart';

class ServerListEmpty extends StatelessWidget {
  final VoidCallback onAddServer;
  const ServerListEmpty({super.key, required this.onAddServer});

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
              CupertinoIcons.cloud_upload,
              size: 64,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noServers,
            style: theme.textTheme.navTitleTextStyle.copyWith(
              color: CupertinoColors.label,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstServer,
            style: theme.textTheme.textStyle.copyWith(
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 32),
          CupertinoButton.filled(
            onPressed: onAddServer,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.add, size: 20),
                const SizedBox(width: 8),
                Text(l10n.addServer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
