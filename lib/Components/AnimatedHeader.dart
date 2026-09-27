import 'package:flutter/material.dart';

class Animatedheader extends StatefulWidget {
  final String title;
  const Animatedheader({Key? key, required this.title}) : super(key: key);

  @override
  State<Animatedheader> createState() => _AnimatedheaderState();
}

class _AnimatedheaderState extends State<Animatedheader>
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