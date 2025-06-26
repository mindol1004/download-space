import 'package:flutter/cupertino.dart';

class AddDownloadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool loading;
  final String label;
  const AddDownloadButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: loading ? null : onPressed,
        padding: const EdgeInsets.symmetric(vertical: 18),
        borderRadius: BorderRadius.circular(16),
        child: loading
            ? const CupertinoActivityIndicator()
            : Text(
                label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
