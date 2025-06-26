import 'package:flutter/cupertino.dart';
import '../../core/models/server_info.dart';
import '../../core/localization/app_localizations.dart';

class ServerListItem extends StatelessWidget {
  final ServerInfo server;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const ServerListItem({
    super.key, 
    required this.server, 
    this.onTap,
    this.onDelete,
  });

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.deleteServerConfirm),
        content: Text(l10n.deleteServerMessage(server.name)),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              onDelete?.call();
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.barBackgroundColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                server.type == ServerType.qbittorrent
                    ? CupertinoIcons.arrow_down_circle_fill
                    : CupertinoIcons.cloud_fill,
                color: theme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: theme.textTheme.navTitleTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${server.type.name} - ${server.address}:${server.port}',
                    style: theme.textTheme.textStyle.copyWith(
                      color: CupertinoColors.systemGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (server.downloadFolder != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.folder,
                          size: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            server.downloadFolder!,
                            style: theme.textTheme.textStyle.copyWith(
                              color: CupertinoColors.systemGrey,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 12),
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () => _showDeleteDialog(context),
                child: const Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.systemRed,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
