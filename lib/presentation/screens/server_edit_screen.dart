import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/server_info.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/server_edit_provider.dart';
import '../providers/server_list_provider.dart';
import '../widgets/server_edit_form.dart';

class ServerEditScreen extends ConsumerStatefulWidget {
  final ServerInfo? server;
  const ServerEditScreen({super.key, this.server});

  @override
  ConsumerState<ServerEditScreen> createState() => _ServerEditScreenState();
}

class _ServerEditScreenState extends ConsumerState<ServerEditScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  Future<void> _onSubmit(ServerInfo info) async {
    final allServers = ref.read(serverListViewModelProvider).servers;
    final notifier =
        ref.read(serverEditViewModelProvider(widget.server).notifier);
    await notifier.saveServer(
      widget.server == null ? info.copyWith(id: const Uuid().v4()) : info,
      allServers,
    );
    final state = ref.read(serverEditViewModelProvider(widget.server));
    if (state.error == null && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = CupertinoTheme.of(context);
    final state = ref.watch(serverEditViewModelProvider(widget.server));

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.server == null ? l10n.addServer : l10n.editServer),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ServerEditForm(
                    server: widget.server,
                    onSubmit: _onSubmit,
                    loading: state.loading,
                  ),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        state.error!,
                        style: theme.textTheme.textStyle.copyWith(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
