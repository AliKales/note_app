import 'dart:math';

import 'package:flutter/material.dart';

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    Point<double> topLeft = Point(0, 0);
    Point<double> topRight = Point(width, 0);
    Point<double> bottomLeft = Point(0, height);
    Point<double> bottomRight = Point(width, (height * 0.7));
    Point<double> bottomMid = Point(width / 2, (height - 20));

    path.lineTo(bottomLeft.x, bottomLeft.y);

    Point<double> anchor1 = Point(width / 4, height - 60);

    path.quadraticBezierTo(anchor1.x, anchor1.y, bottomMid.x, bottomMid.y);

    Point<double> anchor2 = Point(width * 0.75, height + 20);
    Point<double> anchor3 = Point(width, height);

    path.cubicTo(anchor2.x, anchor2.y, anchor3.x, anchor3.y, bottomRight.x,
        bottomRight.y);

    path.lineTo(topRight.x, topRight.y);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
