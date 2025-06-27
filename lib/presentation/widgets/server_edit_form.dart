import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/server_info.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/service/torrent_service.dart';
import '../screens/synology_folder_picker_screen.dart';

class ServerEditForm extends ConsumerStatefulWidget {
  final ServerInfo? server;
  final void Function(ServerInfo) onSubmit;
  final bool loading;
  const ServerEditForm({
    super.key,
    this.server,
    required this.onSubmit,
    this.loading = false,
  });

  @override
  ConsumerState<ServerEditForm> createState() => _ServerEditFormState();
}

class _ServerEditFormState extends ConsumerState<ServerEditForm> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  ServerType _type = ServerType.synology;
  String? _nameError;
  String? _addressError;
  String? _portError;
  String? _downloadFolder;
  bool _isTestingConnection = false;
  String? _connectionStatus;
  String? _synologySid; // 시놀로지 SID 저장

  @override
  void initState() {
    super.initState();
    final s = widget.server;
    _nameController = TextEditingController(text: s?.name ?? '');
    _addressController = TextEditingController(text: s?.address ?? '');
    _portController = TextEditingController(text: s?.port.toString() ?? '');
    _usernameController = TextEditingController(text: s?.username ?? '');
    _passwordController = TextEditingController(text: s?.password ?? '');
    _type = s?.type ?? ServerType.synology;
    _downloadFolder = s?.downloadFolder;
    
    // isConnected 상태에 따른 _connectionStatus 초기화 로직을 didChangeDependencies로 이동
    _synologySid = s?.sessionId; // sessionId는 그대로 initState에서 초기화 가능
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context가 완전히 초기화된 후 AppLocalizations에 접근
    final l10n = AppLocalizations.of(context);
    final s = widget.server;

    if (s != null) {
      if (s.isConnected == true) {
        _connectionStatus = l10n.connectionSuccess;
      } else if (s.isConnected == false) {
        // 연결 실패 상태도 저장되어 있다면 표시
        _connectionStatus = l10n.connectionFailed;
      } else {
        _connectionStatus = null;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _nameError = null;
      _addressError = null;
      _portError = null;
    });
  }

  void _showTypeSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.serverType),
        actions: [
          for (final t in ServerType.values)
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() => _type = t);
                Navigator.of(ctx).pop();
              },
              child: Text(
                t.name,
                style: theme.textTheme.textStyle.copyWith(
                  fontWeight: _type == t ? FontWeight.bold : FontWeight.normal,
                  color: _type == t ? theme.primaryColor : null,
                ),
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

  bool _validate(AppLocalizations l10n) {
    _clearErrors();
    bool isValid = true;

    // 서버 이름 벨리데이션
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = l10n.serverNameRequired);
      isValid = false;
    }

    // 주소 벨리데이션
    if (_addressController.text.trim().isEmpty) {
      setState(() => _addressError = l10n.serverAddressRequired);
      isValid = false;
    }

    // 포트 벨리데이션
    final portText = _portController.text.trim();
    if (portText.isEmpty) {
      setState(() => _portError = l10n.portRequired);
      isValid = false;
    } else {
      final port = int.tryParse(portText);
      if (port == null) {
        setState(() => _portError = l10n.portMustBeNumber);
        isValid = false;
      } else if (port < 1 || port > 65535) {
        setState(() => _portError = l10n.portRangeError);
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _testConnection() async {
    if (!_validate(AppLocalizations.of(context))) {
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _connectionStatus = null;
      _synologySid = null; // 연결 테스트 시작 시 SID 초기화
    });

    try {
      final server = ServerInfo(
        id: widget.server?.id ?? '',
        name: _nameController.text.trim(),
        type: _type,
        address: _addressController.text.trim(),
        port: int.tryParse(_portController.text.trim()) ?? 0,
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        downloadFolder: _downloadFolder,
        // 테스트 연결 시점에 isConnected와 sessionId는 아직 알 수 없음. null로 전달.
        isConnected: null, 
        sessionId: null,
      );

      final service = ref.read(torrentServiceProvider);
      final sid = await service.testConnection(server);

      setState(() {
        _connectionStatus = AppLocalizations.of(context).connectionSuccess;
        _synologySid = sid; // SID 저장
      });
    } catch (e) {
      setState(() {
        _connectionStatus = '${AppLocalizations.of(context).connectionFailed}: $e';
        _synologySid = null; // 연결 실패 시 SID 초기화
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  Future<void> _selectDownloadFolder() async {
    // 시놀로지 서버인 경우에만 폴더 선택 화면으로 이동
    if (_type == ServerType.synology) {
      // 현재 폼의 입력값으로 ServerInfo 생성 (ID는 기존 서버의 ID를 사용)
      final server = ServerInfo(
        id: widget.server?.id ?? '',
        name: _nameController.text.trim(),
        type: _type,
        address: _addressController.text.trim(),
        port: int.tryParse(_portController.text.trim()) ?? 0,
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        downloadFolder: _downloadFolder,
        // 현재 연결 테스트 성공 상태의 isConnected와 sessionId를 전달
        isConnected: _connectionStatus == AppLocalizations.of(context).connectionSuccess ? true : false, 
        sessionId: _synologySid,
      );

      final selectedFolder = await Navigator.of(context).push<String?>(
        CupertinoPageRoute(
          builder: (context) => SynologyFolderPickerScreen(
            server: server,
            initialPath: _downloadFolder ?? '/', // 현재 설정된 폴더 또는 루트부터 시작
          ),
        ),
      );

      if (selectedFolder != null) {
        setState(() {
          _downloadFolder = selectedFolder;
        });
      }
    } else {
      // 그 외의 경우 기존 파일 피커 사용
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        setState(() {
          _downloadFolder = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);

    // 연결 성공 여부 확인 (SYNO.API.Auth의 성공 코드 0)
    bool isConnectionSuccess = _connectionStatus != null &&
        (_connectionStatus!.contains(l10n.connectionSuccess) || _connectionStatus!.contains('Success'));
    
    // 시놀로지 서버 타입일 경우에만 폴더 선택 가능하도록
    bool canSelectSynologyFolder = isConnectionSuccess && _type == ServerType.synology && _synologySid != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CupertinoLabeledField(
          label: l10n.serverName,
          child: CupertinoTextField(
            controller: _nameController,
            placeholder: l10n.serverName,
            enabled: !widget.loading,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context), // Changed for dark mode visibility
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _nameError != null
                    ? CupertinoColors.systemRed.withValues(alpha: 0.6)
                    : theme.primaryColor.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            style: theme.textTheme.textStyle,
          ),
        ),
        if (_nameError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _nameError!,
              style: theme.textTheme.textStyle.copyWith(
                color: CupertinoColors.systemRed,
                fontSize: 14,
              ),
            ),
          ),
        const SizedBox(height: 16),
        _CupertinoLabeledField(
          label: l10n.serverType,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            color: theme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            onPressed: widget.loading ? null : () => _showTypeSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _type.name,
                  style: theme.textTheme.textStyle,
                ),
                const Icon(CupertinoIcons.chevron_down, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _CupertinoLabeledField(
          label: l10n.address,
          child: CupertinoTextField(
            controller: _addressController,
            placeholder: l10n.address,
            enabled: !widget.loading,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context), // Changed for dark mode visibility
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _addressError != null
                    ? CupertinoColors.systemRed.withValues(alpha: 0.6)
                    : theme.primaryColor.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            style: theme.textTheme.textStyle,
          ),
        ),
        if (_addressError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _addressError!,
              style: theme.textTheme.textStyle.copyWith(
                color: CupertinoColors.systemRed,
                fontSize: 14,
              ),
            ),
          ),
        const SizedBox(height: 16),
        _CupertinoLabeledField(
          label: l10n.port,
          child: CupertinoTextField(
            controller: _portController,
            placeholder: l10n.port,
            enabled: !widget.loading,
            keyboardType: TextInputType.number,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context), // Changed for dark mode visibility
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _portError != null
                    ? CupertinoColors.systemRed.withValues(alpha: 0.6)
                    : theme.primaryColor.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            style: theme.textTheme.textStyle,
          ),
        ),
        if (_portError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _portError!,
              style: theme.textTheme.textStyle.copyWith(
                color: CupertinoColors.systemRed,
                fontSize: 14,
              ),
            ),
          ),
        const SizedBox(height: 16),
        _CupertinoLabeledField(
          label: l10n.username,
          child: CupertinoTextField(
            controller: _usernameController,
            placeholder: l10n.username,
            enabled: !widget.loading,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context), // Changed for dark mode visibility
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            style: theme.textTheme.textStyle,
          ),
        ),
        const SizedBox(height: 16),
        _CupertinoLabeledField(
          label: l10n.password,
          child: CupertinoTextField(
            controller: _passwordController,
            placeholder: l10n.password,
            enabled: !widget.loading,
            obscureText: true,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context), // Changed for dark mode visibility
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            style: theme.textTheme.textStyle,
          ),
        ),
        const SizedBox(height: 24),
        // 연결 테스트 버튼
        CupertinoButton.filled(
          onPressed: widget.loading || _isTestingConnection ? null : _testConnection,
          padding: const EdgeInsets.symmetric(vertical: 14),
          borderRadius: BorderRadius.circular(12),
          child: _isTestingConnection
              ? const CupertinoActivityIndicator(color: CupertinoColors.white)
              : Text(l10n.testConnection),
        ),
        if (_connectionStatus != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isConnectionSuccess
                  ? CupertinoColors.systemGreen.withValues(alpha: 0.1)
                  : CupertinoColors.systemRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isConnectionSuccess
                    ? CupertinoColors.systemGreen.withValues(alpha: 0.3)
                    : CupertinoColors.systemRed.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _connectionStatus!,
              style: theme.textTheme.textStyle.copyWith(
                color: isConnectionSuccess
                    ? CupertinoColors.systemGreen
                    : CupertinoColors.systemRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        // 다운로드 폴더 선택
        _CupertinoLabeledField(
          label: l10n.downloadFolder,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            color: theme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            // 시놀로지 서버에 연결 성공한 경우에만 폴더 선택 가능
            onPressed: widget.loading || (_type == ServerType.synology && !canSelectSynologyFolder)
                ? null
                : _selectDownloadFolder,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _downloadFolder ?? l10n.selectDownloadFolder,
                    style: theme.textTheme.textStyle.copyWith(
                      color: _downloadFolder != null ? null : CupertinoColors.systemGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(CupertinoIcons.folder, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            onPressed: widget.loading
                ? null
                : () {
                    if (_validate(l10n)) {
                      final info = ServerInfo(
                        id: widget.server?.id ?? '',
                        name: _nameController.text.trim(),
                        type: _type,
                        address: _addressController.text.trim(),
                        port: int.tryParse(_portController.text.trim()) ?? 0,
                        username: _usernameController.text.trim(),
                        password: _passwordController.text.trim(),
                        downloadFolder: _downloadFolder,
                        isConnected: isConnectionSuccess, // 현재 연결 성공 상태를 저장
                        sessionId: _synologySid, // 현재 SID를 저장
                      );
                      widget.onSubmit(info);
                    }
                  },
            padding: const EdgeInsets.symmetric(vertical: 16),
            borderRadius: BorderRadius.circular(12),
            child: widget.loading
                ? const CupertinoActivityIndicator(radius: 13)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.check_mark, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.server == null ? l10n.addServer : l10n.save,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _CupertinoLabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _CupertinoLabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.textStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
