import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppHeader extends ConsumerWidget
    implements ObstructingPreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: showBackButton
          ? CupertinoNavigationBarBackButton(
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      trailing: actions != null && actions!.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            )
          : null,
      border: null,
      backgroundColor:
          CupertinoTheme.of(context).barBackgroundColor.withValues(alpha: 0.95),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kMinInteractiveDimensionCupertino);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.a == 1.0;
  }
}
