import 'dart:async';

import 'package:flutter/material.dart';

class ListenableMouseRegion extends StatefulWidget {
  final Widget child;

  const ListenableMouseRegion({required this.child});

  static ListenableMouseRegionState? of(BuildContext context) {
    return context.findAncestorStateOfType<ListenableMouseRegionState>();
  }

  @override
  ListenableMouseRegionState createState() => ListenableMouseRegionState();
}

class ListenableMouseRegionState extends State<ListenableMouseRegion> {
  StreamController<Offset?> _updates = StreamController<Offset?>.broadcast();

  Stream<Offset?> get position => _updates.stream;

  @override
  void dispose() {
    _updates.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onHover: (event) {
          _updates.add(event.position);
        },
        onExit: (event) {
          _updates.add(null);
        },
        child: widget.child);
  }
}
