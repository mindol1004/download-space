import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/add_download_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../widgets/magnet_card.dart';
import '../widgets/divider_with_text.dart';
import '../widgets/torrent_file_card.dart';
import '../../core/models/server_info.dart';

class AddDownloadScreen extends ConsumerStatefulWidget {
  const AddDownloadScreen(
      {super.key, this.initialMagnet, required this.selectedServer});
  final String? initialMagnet;
  final ServerInfo? selectedServer;

  @override
  ConsumerState<AddDownloadScreen> createState() => _AddDownloadScreenState();
}

class _AddDownloadScreenState extends ConsumerState<AddDownloadScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _magnetController = TextEditingController();
  String? _pickedFileName;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // 페이지 초기화 시 에러 상태 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final notifier = ref.read(addDownloadViewModelProvider.notifier);
        notifier.clearError();
      }
    });
    
    if (widget.initialMagnet != null) {
      _magnetController.text = widget.initialMagnet!;
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _magnetController.dispose();
    // ref는 dispose에서 사용할 수 없으므로 제거
    super.dispose();
  }

  Future<void> _addMagnet() async {
    if (widget.selectedServer == null) {
      // 서버가 선택되지 않았을 때 에러 메시지 표시
      final l10n = AppLocalizations.of(context);
      final notifier = ref.read(addDownloadViewModelProvider.notifier);
      notifier.setError(l10n.selectServerFirst, errorType: 'server');
      return;
    }
    
    // 다운로드 폴더가 설정되어 있는지 확인
    if (widget.selectedServer!.downloadFolder == null) {
      final l10n = AppLocalizations.of(context);
      final notifier = ref.read(addDownloadViewModelProvider.notifier);
      notifier.setError(l10n.selectFolderFirst, errorType: 'server');
      return;
    }
    
    final notifier = ref.read(addDownloadViewModelProvider.notifier);
    await notifier.addMagnet(
        _magnetController.text.trim(), widget.selectedServer!);
    final state = ref.read(addDownloadViewModelProvider);
    if (state.error == null && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickTorrentFile() async {
    if (widget.selectedServer == null) {
      final l10n = AppLocalizations.of(context);
      final notifier = ref.read(addDownloadViewModelProvider.notifier);
      notifier.setError(l10n.selectServerFirst, errorType: 'server');
      return;
    }
    
    // 다운로드 폴더가 설정되어 있는지 확인
    if (widget.selectedServer!.downloadFolder == null) {
      final l10n = AppLocalizations.of(context);
      final notifier = ref.read(addDownloadViewModelProvider.notifier);
      notifier.setError(l10n.selectFolderFirst, errorType: 'server');
      return;
    }
    
    if (kIsWeb) {
      // 웹 환경에서는 웹 전용 파일 선택 사용
      await _pickTorrentFileWeb();
    } else {
      // 네이티브 환경에서는 기존 FilePicker 사용
      await _pickTorrentFileNative();
    }
  }

  Future<void> _pickTorrentFileNative() async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['torrent']);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _pickedFileName = result.files.single.name;
        });
        final notifier = ref.read(addDownloadViewModelProvider.notifier);
        await notifier.addTorrentFile(result.files.single.bytes!,
            result.files.single.name, widget.selectedServer!);
        final state = ref.read(addDownloadViewModelProvider);
        if (state.error == null && mounted) {
          Navigator.pop(context, true);
        }
      } else {
        if (kDebugMode) {
          print('파일이 선택되지 않았거나 bytes가 null');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('FilePicker 에러: $e');
      }
      final notifier = ref.read(addDownloadViewModelProvider.notifier);
      notifier.setError('파일 선택 중 오류가 발생했습니다: $e', errorType: 'file');
    }
  }

  Future<void> _pickTorrentFileWeb() async {
    try {
      // 웹에서는 FilePicker를 직접 사용
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['torrent']);
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.bytes != null) {
          setState(() {
            _pickedFileName = file.name;
          });
          final notifier = ref.read(addDownloadViewModelProvider.notifier);
          await notifier.addTorrentFile(file.bytes!, file.name, widget.selectedServer!);
          final state = ref.read(addDownloadViewModelProvider);
          if (state.error == null && mounted) {
            Navigator.pop(context, true);
          }
        } else {
          if (kDebugMode) {
            print('웹 파일 bytes가 null');
          }
          final notifier = ref.read(addDownloadViewModelProvider.notifier);
          notifier.setError('파일을 읽을 수 없습니다.', errorType: 'file');
        }
      } else {
        if (kDebugMode) {
          print('웹에서 파일이 선택되지 않음');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('웹 파일 선택 에러: $e');
      }
      final notifier = ref.read(addDownloadViewModelProvider.notifier);
      notifier.setError('웹에서 파일 선택 중 오류가 발생했습니다: $e', errorType: 'file');
    }
  }

  void _handlePaste() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      setState(() {
        _magnetController.text = data!.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);
    final state = ref.watch(addDownloadViewModelProvider);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.addDownload),
        previousPageTitle: l10n.cancel,
        border: null,
        backgroundColor: theme.barBackgroundColor.withValues(alpha: 0.95),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MagnetCard(
                      controller: _magnetController,
                      labelKey: 'magnetLink',
                      hintKey: 'enterMagnetLink',
                      loading: state.loading,
                      errorKey: (state.error != null && state.errorType == 'magnet') ? 'requiredField' : null,
                      onPaste: _handlePaste,
                      loadingKey: 'addingDownload',
                    ),
                    const SizedBox(height: 32),
                    const DividerWithText(textKey: 'or'),
                    const SizedBox(height: 32),
                    TorrentFileCard(
                      onPick: _pickTorrentFile,
                      label: l10n.torrentFile,
                      loading: state.loading,
                      fileName: _pickedFileName,
                    ),
                    const SizedBox(height: 40),
                    if (state.error != null && state.errorType == 'server') ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          state.error!,
                          style: TextStyle(
                            color:
                                CupertinoColors.systemRed.resolveFrom(context),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    if (state.error != null && state.errorType == 'file') ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          state.error!,
                          style: TextStyle(
                            color:
                                CupertinoColors.systemRed.resolveFrom(context),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    CupertinoButton.filled(
                      onPressed: state.loading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() == true) {
                                _addMagnet();
                              } else {
                                setState(() {});
                              }
                            },
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      borderRadius: BorderRadius.circular(16),
                      child: state.loading
                          ? const CupertinoActivityIndicator()
                          : Text(
                              l10n.addDownload,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
