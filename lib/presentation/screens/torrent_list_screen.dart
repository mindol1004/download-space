import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/server_list_provider.dart';
import '../providers/torrent_list_provider.dart';
import '../../core/models/torrent_task.dart';
import '../../core/models/server_info.dart';
import '../widgets/app_header.dart';
import '../widgets/server_dropdown.dart';
import '../widgets/torrent_card.dart';
import '../widgets/torrent_list_loading.dart';
import '../widgets/torrent_list_error.dart';
import '../widgets/torrent_list_empty.dart';
import 'add_download_screen.dart';
import 'server_list_screen.dart';
import 'settings_screen.dart';
import '../widgets/animated_tap_feedback.dart';

class TorrentListScreen extends ConsumerStatefulWidget {
  const TorrentListScreen({super.key});

  @override
  ConsumerState<TorrentListScreen> createState() => _TorrentListScreenState();
}

class _TorrentListScreenState extends ConsumerState<TorrentListScreen> {
  ServerInfo? _selectedServer;

  @override
  Widget build(BuildContext context) {
    final servers = ref.watch(serverListViewModelProvider).servers;
    final torrentState = ref.watch(torrentListViewModelProvider);
    final settings = ref.watch(settingsViewModelProvider);
    final settingsNotifier = ref.read(settingsViewModelProvider.notifier);
    final theme = CupertinoTheme.of(context);
    final l10n = AppLocalizations.of(context);

    // Update selected server if server list changes
    if (_selectedServer != null &&
        !servers.any((s) => s.id == _selectedServer!.id)) {
      _selectedServer = null;
    }
    if (_selectedServer == null && servers.isNotEmpty) {
      _selectedServer = servers.first;
    }

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: AppHeader(
        title: l10n.downloadList,
        actions: [
          ServerDropdown(
            servers: servers,
            selectedServer: _selectedServer,
            onServerSelected: (server) {
              setState(() {
                _selectedServer = server;
              });
              ref
                  .read(torrentListViewModelProvider.notifier)
                  .fetchTasks(_selectedServer);
            },
          ),
          const SizedBox(width: 8),
          AnimatedTapFeedback(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const ServerListScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(CupertinoIcons.square_list, size: 26),
            ),
          ),
          const SizedBox(width: 4),
          AnimatedTapFeedback(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const SettingsScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(CupertinoIcons.settings, size: 26),
            ),
          ),
          const SizedBox(width: 4),
          AnimatedTapFeedback(
            onTap: () {
              settingsNotifier.setBrightness(
                settings.brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: RotationTransition(
                      turns: Tween<double>(begin: 0.75, end: 1.0)
                          .animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  settings.brightness == Brightness.dark
                      ? CupertinoIcons.sun_max_fill
                      : CupertinoIcons.moon_fill,
                  key: ValueKey(settings.brightness),
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: () {
                    if (torrentState.loading) {
                      return const TorrentListLoading();
                    } else if (torrentState.error != null) {
                      return TorrentListError(error: torrentState.error!);
                    } else if (torrentState.tasks.isEmpty) {
                      return const TorrentListEmpty();
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: torrentState.tasks.length,
                        itemBuilder: (context, idx) {
                          final TorrentTask t = torrentState.tasks[idx];
                          return TorrentCard(torrent: t);
                        },
                      );
                    }
                  }(),
                ),
                const SizedBox(height: 70),
              ],
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: CupertinoButton.filled(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AddDownloadScreen(selectedServer: _selectedServer),
                    ),
                  );
                },
                padding: const EdgeInsets.symmetric(vertical: 18),
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.add, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      l10n.addDownload,
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
