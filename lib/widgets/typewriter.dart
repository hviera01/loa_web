import 'dart:async';
import 'package:flutter/material.dart';

class Typewriter extends StatefulWidget {
  final List<String> lines;
  final TextStyle? style;

  const Typewriter({super.key, required this.lines, this.style});

  @override
  State<Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<Typewriter> {
  final _out = <String>[];
  int _i = 0;
  int _j = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _out.add('');
    _timer = Timer.periodic(const Duration(milliseconds: 26), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    if (_i >= widget.lines.length) {
      _timer?.cancel();
      return;
    }

    final target = widget.lines[_i];
    if (_j < target.length) {
      setState(() {
        _out[_i] = target.substring(0, _j + 1);
        _j++;
      });
      return;
    }

    if (_i < widget.lines.length - 1) {
      setState(() {
        _i++;
        _j = 0;
        _out.add('');
      });
      return;
    }

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.style ?? Theme.of(context).textTheme.bodyLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in _out)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(line, style: s),
          ),
      ],
    );
  }
}
