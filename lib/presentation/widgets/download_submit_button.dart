import 'package:flutter/cupertino.dart';

class DownloadSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool loading;
  final String label;
  const DownloadSubmitButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: loading ? null : onPressed,
        padding: const EdgeInsets.symmetric(vertical: 16),
        borderRadius: BorderRadius.circular(12),
        child: loading
            ? const CupertinoActivityIndicator(radius: 13)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.add, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
