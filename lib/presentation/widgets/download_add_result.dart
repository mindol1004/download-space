import 'package:flutter/cupertino.dart';

class DownloadAddResult extends StatelessWidget {
  final String? error;
  final bool loading;
  const DownloadAddResult({super.key, this.error, this.loading = false});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CupertinoActivityIndicator(radius: 16),
        ),
      );
    }
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          error!,
          style: theme.textTheme.textStyle.copyWith(
            color: CupertinoColors.systemRed,
            fontSize: 15,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
