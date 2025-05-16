
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RailDivider extends StatelessWidget {
  const RailDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: CustomPaint(
        painter: _RailPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _RailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint railPaint =
    Paint()..color = Colors.grey.shade600..strokeWidth = 4;
    Paint tiePaint =
    Paint()..color = Colors.grey.shade400..strokeWidth = 2;
    double y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), railPaint);
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), tiePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
