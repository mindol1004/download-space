import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/server_info.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/server_list_provider.dart';
import '../widgets/server_list_item.dart';
import '../widgets/server_list_empty.dart';
import 'server_edit_screen.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  void _navigateToAddServer(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ServerEditScreen(),
      ),
    );
    if (result == true) {
      ref.read(serverListViewModelProvider.notifier).loadServers();
    }
  }

  void _navigateToEditServer(BuildContext context, WidgetRef ref, ServerInfo server) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ServerEditScreen(server: server),
      ),
    );
    if (result == true) {
      ref.read(serverListViewModelProvider.notifier).loadServers();
    }
  }

  void _deleteServer(WidgetRef ref, ServerInfo server) async {
    await ref.read(serverListViewModelProvider.notifier).deleteServer(server.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serverListViewModelProvider);
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.serverManagement),
        previousPageTitle: l10n.cancel,
        border: null,
        backgroundColor: theme.barBackgroundColor.withValues(alpha: 0.95),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: () {
                    if (state.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.servers.isEmpty) {
                      return ServerListEmpty(
                        onAddServer: () => _navigateToAddServer(context, ref),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: state.servers.length,
                        itemBuilder: (context, index) {
                          final server = state.servers[index];
                          return ServerListItem(
                            server: server,
                            onTap: () => _navigateToEditServer(context, ref, server),
                            onDelete: () => _deleteServer(ref, server),
                          );
                        },
                      );
                    }
                  }(),
                ),
                const SizedBox(height: 70),
              ],
            ),
            if (state.servers.isNotEmpty)
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: CupertinoButton.filled(
                  onPressed: () => _navigateToAddServer(context, ref),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.add, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        l10n.addServer,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
