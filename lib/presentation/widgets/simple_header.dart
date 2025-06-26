import 'package:flutter/cupertino.dart';

class SimpleHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const SimpleHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: showBackButton
          ? CupertinoNavigationBarBackButton(
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      border: null,
      backgroundColor:
          CupertinoTheme.of(context).barBackgroundColor.withValues(alpha: 0.95),
    );
  }
}
