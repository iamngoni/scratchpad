//
//  scratchpad
//  canvas_painter
//
//  Created by Ngonidzashe Mangudya on 02/04/2024.
//  Copyright (c) 2024 ModestNerds, Co
//

import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/touch_point.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter({
    required this.points,
  });

  List<TouchPoint?> points;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.points,
          points[i + 1]!.points,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        offsetPoints
          ..clear()
          ..add(points[i]!.points)
          ..add(
            Offset(
              points[i]!.points.dx + 0.1,
              points[i]!.points.dy + 0.1,
            ),
          );

        canvas.drawPoints(PointMode.points, offsetPoints, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}
