import 'package:flutter/material.dart';

class AnimatedHeader extends StatefulWidget {
  final String title;
  const AnimatedHeader({super.key, required this.title});

  @override
  State<AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.title, style: Theme.of(context).textTheme.headlineLarge);
  }
}
