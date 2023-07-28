import 'dart:math' as math;

import 'package:flutter/material.dart';

class MessageBubblePointerPainter extends CustomPainter {
  final Color backgroundColor;
  MessageBubblePointerPainter(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-10, 0);
    path.lineTo(-10, 10);
    path.lineTo(0, 10);
    path.quadraticBezierTo(8, 3, 8, 2);
    path.quadraticBezierTo(8, 0, 6, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MessageBubblePointerShape extends StatelessWidget {
  const MessageBubblePointerShape(
      {super.key, required this.color, this.mirrored = false});

  final Color color;
  final bool mirrored;

  Widget getPointerShape() {
    return CustomPaint(
      size: const Size(8, 10),
      painter: MessageBubblePointerPainter(color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mirrored) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: getPointerShape(),
      );
    }

    return getPointerShape();
  }
}
