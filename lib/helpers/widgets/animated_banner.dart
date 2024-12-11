import 'package:flutter/material.dart';

class AnimatedBanner extends StatefulWidget {
  const AnimatedBanner({
    super.key,
    required this.content,
  });
  final Widget content;
  @override
  State<AnimatedBanner> createState() => _AnimatedImageBannerState();
}

class _AnimatedImageBannerState extends State<AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          content: widget.content,
        ),
      ),
    );
  }
}
