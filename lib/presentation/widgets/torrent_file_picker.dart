import 'package:flutter/cupertino.dart';

class TorrentFilePicker extends StatelessWidget {
  final VoidCallback onPick;
  final bool loading;
  const TorrentFilePicker(
      {super.key, required this.onPick, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: loading ? null : onPick,
        padding: const EdgeInsets.symmetric(vertical: 16),
        borderRadius: BorderRadius.circular(12),
        child: loading
            ? const CupertinoActivityIndicator(radius: 13)
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.doc, size: 20),
                  SizedBox(width: 8),
                  Text('토렌트 파일 선택'),
                ],
              ),
      ),
    );
  }
}
