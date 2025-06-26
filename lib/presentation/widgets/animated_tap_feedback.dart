import 'package:flutter/cupertino.dart';

class AnimatedTapFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AnimatedTapFeedback({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<AnimatedTapFeedback> createState() => _AnimatedTapFeedbackState();
}

class _AnimatedTapFeedbackState extends State<AnimatedTapFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _controller.reverse();
      }
    });
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
