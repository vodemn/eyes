import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

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
  Offset _offset = Offset.zero;
  double _scrollY = 0.0;
  BehaviorSubject<Offset?> _updates = BehaviorSubject<Offset?>();
  Stream<Offset?> get position => _updates.stream;

  @override
  void dispose() {
    _updates.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          _scrollY = notification.metrics.extentBefore;
          _setPosition();
          return true;
        },
        child: MouseRegion(
            onHover: (event) {
              _offset = event.position;
              _setPosition();
            },
            onExit: (event) {
              _updates.add(null);
            },
            child: widget.child));
  }

  void _setPosition() {
    _updates.add(_offset + Offset(0, _scrollY));
  }
}
