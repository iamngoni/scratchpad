//
//  scratchpad
//  sketch_pad
//
//  Created by Ngonidzashe Mangudya on 02/04/2024.
//  Copyright (c) 2024 ModestNerds, Co
//

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:relative_scale/relative_scale.dart';

import 'canvas_painter.dart';
import 'extensions.dart';
import 'models/touch_point.dart';

class SketchPad extends StatefulWidget {
  const SketchPad({super.key});

  @override
  State<SketchPad> createState() => _SketchPadState();
}

class _SketchPadState extends State<SketchPad> {
  List<TouchPoint?> points = [];
  double opacity = 1;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 50;
  Color selectedColor = Colors.yellow.withOpacity(0.2);
  Color pickerColor = Colors.yellow.withOpacity(0.2);
  final GlobalKey previewContainer = GlobalKey();

  Future<void> pickStroke() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            MaterialButton(
              child: const Icon(
                Icons.brush,
                size: 16,
              ),
              onPressed: () {
                strokeWidth = 3.0;
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Icon(
                Icons.brush,
                size: 24,
              ),
              onPressed: () {
                strokeWidth = 10.0;
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Icon(
                Icons.brush,
                size: 40,
              ),
              onPressed: () {
                strokeWidth = 30.0;
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Icon(
                Icons.brush,
                size: 60,
              ),
              onPressed: () {
                strokeWidth = 50.0;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void pickColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  void unDo() {
    if (points.isNotEmpty) {
      setState(() {
        points.removeLast();
        points[points.indexOf(points.last)] = null;
      });
    }
  }

  void openColorPicker() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pick a color!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color.withOpacity(0.2);
                selectedColor = color.withOpacity(0.2);
                context.goBack();
              },
            ),
          ),
        );
      },
    );
    setState(() {
      pickColor(pickerColor);
    });
  }

  void setToEraserMode() {
    setState(() {
      selectedColor = const Color.fromARGB(250, 250, 250, 250);
    });
  }

  void clearCanvas() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return Scaffold(
          body: RepaintBoundary(
            key: previewContainer,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final RenderBox renderBox =
                      context.findRenderObject() as RenderBox;
                  final Offset localPosition =
                      renderBox.globalToLocal(details.globalPosition);

                  points.add(
                    TouchPoint(
                      points: localPosition,
                      paint: Paint()
                        ..strokeCap = strokeType
                        ..isAntiAlias = true
                        ..color = selectedColor
                        ..strokeWidth = strokeWidth,
                    ),
                  );
                });
              },
              onPanStart: (details) {
                setState(() {
                  final RenderBox? renderBox =
                      context.findRenderObject() as RenderBox?;

                  if (renderBox != null) {
                    final Offset localPosition0 =
                        renderBox.globalToLocal(details.globalPosition);
                    points.add(
                      TouchPoint(
                        points: localPosition0,
                        paint: Paint()
                          ..strokeCap = strokeType
                          ..isAntiAlias = true
                          ..color = selectedColor
                          ..strokeWidth = strokeWidth,
                      ),
                    );
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(null);
                });
              },
              child: ColoredBox(
                color: Colors.white,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CanvasPainter(
                    points: points,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.color_lens),
                label: 'Color',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.brush),
                label: 'Stroke',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.undo),
                label: 'Undo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delete),
                label: 'Clear',
              ),
            ],
            onTap: (index) {
              return switch (index) {
                0 => openColorPicker(),
                1 => pickStroke(),
                2 => unDo(),
                3 => clearCanvas(),
                _ => null,
              };
            },
          ),
        );
      },
    );
  }
}
