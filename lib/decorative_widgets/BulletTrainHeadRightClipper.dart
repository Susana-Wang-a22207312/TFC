import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class BulletTrainHeadRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double noseW = size.width * 0.4;
    var noseRect =
    Rect.fromLTWH(size.width - noseW * 2, 0, noseW * 2, size.height);
    path.moveTo(size.width - noseW, 0);
    path.arcTo(noseRect, -pi / 2, pi, false);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
