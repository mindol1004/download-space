import 'package:flutter/cupertino.dart';
import '../../core/models/server_info.dart';
import '../../core/localization/app_localizations.dart';

class ServerDropdown extends StatelessWidget {
  final List<ServerInfo> servers;
  final ServerInfo? selectedServer;
  final ValueChanged<ServerInfo> onServerSelected;

  const ServerDropdown({
    super.key,
    required this.servers,
    required this.selectedServer,
    required this.onServerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: theme.barBackgroundColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onPressed: () => _showServerSheet(context, theme, l10n),
        minimumSize: const Size(0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selectedServer != null
                    ? theme.primaryColor
                    : CupertinoColors.systemGrey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              selectedServer?.name ?? l10n.serverSelection,
              style: theme.textTheme.textStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(CupertinoIcons.chevron_down, size: 18),
          ],
        ),
      ),
    );
  }

  void _showServerSheet(
      BuildContext context, CupertinoThemeData theme, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.serverSelection),
        actions: [
          for (final s in servers)
            CupertinoActionSheetAction(
              onPressed: () {
                onServerSelected(s);
                Navigator.of(ctx).pop();
              },
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: selectedServer?.id == s.id
                          ? theme.primaryColor
                          : CupertinoColors.systemGrey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s.name,
                      style: theme.textTheme.textStyle.copyWith(
                        fontWeight: selectedServer?.id == s.id
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selectedServer?.id == s.id
                            ? theme.primaryColor
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          isDefaultAction: true,
          child: Text(l10n.cancel),
        ),
      ),
    );
  }
}
