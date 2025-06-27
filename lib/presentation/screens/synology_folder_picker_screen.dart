import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/server_info.dart';
import '../../core/service/torrent_service.dart';

class SynologyFolderPickerScreen extends ConsumerStatefulWidget {
  final ServerInfo server;
  final String initialPath;

  const SynologyFolderPickerScreen({
    super.key,
    required this.server,
    this.initialPath = '/', // 기본값을 루트로 설정
  });

  @override
  ConsumerState<SynologyFolderPickerScreen> createState() =>
      _SynologyFolderPickerScreenState();
}

class _SynologyFolderPickerScreenState
    extends ConsumerState<SynologyFolderPickerScreen> {
  late String _currentPath;
  Future<List<String>>? _foldersFuture;

  @override
  void initState() {
    super.initState();
    // 초기 경로가 null이거나 비어있으면 루트로 설정
    _currentPath = widget.initialPath.isEmpty ? '/' : widget.initialPath;
    _fetchFolders();
  }

  void _fetchFolders() {
    _foldersFuture = ref
        .read(torrentServiceProvider)
        .getSynologyFolders(widget.server, _currentPath);
  }

  void _navigateToFolder(String folderPath) {
    setState(() {
      _currentPath = folderPath;
      _fetchFolders();
    });
  }

  void _selectFolder(String folderPath) {
    Navigator.of(context).pop(folderPath);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.selectDownloadFolder),
        previousPageTitle: l10n.cancel,
        border: null,
        backgroundColor: theme.barBackgroundColor.withValues(alpha: 0.95),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _selectFolder(_currentPath),
          child: Text(l10n.select),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                setState(() {
                  _fetchFolders();
                });
                await _foldersFuture;
              },
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CupertinoListSection.insetGrouped(
                    header: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        _currentPath,
                        style: theme.textTheme.textStyle.copyWith(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    children: [
                      // 최상위 경로가 아니면 상위 디렉토리로 이동하는 버튼 추가
                      if (_currentPath != '/')
                        CupertinoListTile(
                          title: Text(l10n.parentDirectory),
                          leading: const Icon(CupertinoIcons.folder_fill, color: CupertinoColors.systemGrey),
                          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
                          onTap: () {
                            final parentPath = _currentPath.contains('/') && _currentPath.lastIndexOf('/') > 0
                                ? _currentPath.substring(0, _currentPath.lastIndexOf('/'))
                                : '/';
                            _navigateToFolder(parentPath);
                          },
                        ),
                      // 폴더 목록을 FutureBuilder 밖으로 이동하여 스냅샷 데이터에 따라 조건부 렌더링
                      FutureBuilder<List<String>>(
                        future: _foldersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CupertinoListTile(
                              title: Center(child: CupertinoActivityIndicator()),
                            );
                          } else if (snapshot.hasError) {
                            return CupertinoListTile(
                              title: Text(
                                '${l10n.errorLoadingFolders}: ${snapshot.error}',
                                style: theme.textTheme.textStyle.copyWith(
                                  color: CupertinoColors.systemRed,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            // 상위 디렉토리 외에 폴더가 없을 때
                            if (_currentPath != '/' || (snapshot.hasData && snapshot.data!.isEmpty)) {
                               return CupertinoListTile(
                                title: Text(l10n.noFoldersFound),
                              );
                            } else {
                              return const SizedBox.shrink(); // 루트이면서 폴더가 없으면 아무것도 표시 안함
                            }
                          } else {
                            final folders = snapshot.data!;
                            return Column(
                              children: folders.map((folder) => CupertinoListTile(
                                title: Text(folder.split('/').last),
                                leading: const Icon(CupertinoIcons.folder_fill, color: CupertinoColors.systemYellow),
                                trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
                                onTap: () => _navigateToFolder(folder),
                              )).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
