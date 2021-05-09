import 'dart:core';
import 'dart:math';

import 'package:eyes/src/region.dart';
import 'package:flutter/material.dart';

class Eye extends StatefulWidget {
  final double size;
  final Color color;
  final Color eyeballColor;

  const Eye({this.size = 168, this.color = Colors.black, this.eyeballColor = Colors.white});

  @override
  _EyeState createState() => _EyeState();
}

class _EyeState extends State<Eye> {
  final containerKey = GlobalKey();
  Offset? center;

  Offset get relaviteCenter => Offset(widget.size / 2, widget.size / 2);

  static const double SCALE_EYE = 0.25;
  static const double SCALE_HIDE = 0.45;
  double get overflowRadius => widget.size * 1.5;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Offset?>(
        stream: ListenableMouseRegion.of(context)!.position,
        builder: (context, snapshot) {
          Offset position;
          if (snapshot.hasData) {
            position = _updateLocation(snapshot.data!);
          } else {
            position = relaviteCenter;
          }
          return SizedBox.fromSize(
              key: containerKey,
              size: Size.square(widget.size),
              child: Stack(children: [
                Icon(Icons.visibility, color: widget.color, size: widget.size),
                Center(
                    child: CustomPaint(
                        painter: CirclePainter(widget.size * SCALE_HIDE / 2, widget.eyeballColor))),
                Positioned(
                    bottom: position.dy,
                    right: position.dx,
                    child: CustomPaint(
                        painter: CirclePainter(widget.size * SCALE_EYE / 2, widget.color)))
              ]));
        });
  }

  Offset findCenter() {
    final RenderBox renderObject = containerKey.currentContext!.findRenderObject() as RenderBox;
    return renderObject
        .localToGlobal(Offset(renderObject.size.width / 2, renderObject.size.height / 2));
  }

  Offset _updateLocation(Offset details) {
    final double allowedRadius = widget.size * SCALE_EYE / 2;
    final double shift = widget.size / 2;
    Offset result = Offset(shift, shift);

    center ??= findCenter();
    final double diffX = center!.dx - details.dx;
    final double diffY = center!.dy - details.dy;

    final toPointer = sqrt((pow(diffX, 2) as double) + (pow(diffY, 2) as double));
    Offset diff = Offset(diffX, diffY);
    if (toPointer > allowedRadius) {
      diff *= (allowedRadius / toPointer);
    }

    if (toPointer <= overflowRadius) {
      diff *= toPointer / overflowRadius;
    }

    return result += Offset(diff.dx, diff.dy);
  }
}

class CirclePainter extends CustomPainter {
  final double radius;
  final Color color;

  const CirclePainter(this.radius, this.color);

  @override
  void paint(Canvas canvas, _) {
    canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_) => true;
}
