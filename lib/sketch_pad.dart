//
//  scratchpad
//  sketch_pad
//
//  Created by Ngonidzashe Mangudya on 02/04/2024.
//  Copyright (c) 2024 ModestNerds, Co
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:handy_extensions/handy_extensions.dart';
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
          bottomNavigationBar: BottomAppBar(
            child: Container(
              width: context.width,
              height: sy(50),
              margin: EdgeInsets.symmetric(
                horizontal: sx(10),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage('assets/images/background-tablet.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -1),
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.goBack();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            size: sy(30),
                            color: Colors.white,
                          ),
                          Text(
                            'HOME',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Pick a color!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: sy(15),
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
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage(
                                'assets/icons/color-wheel.png'),
                            height: sy(30),
                            width: sy(30),
                          ),
                          Text(
                            'COLORS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: pickStroke,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage('assets/icons/brush.png'),
                            color: Colors.white,
                            height: sy(30),
                            width: sy(30),
                          ),
                          Text(
                            'BRUSH',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor =
                              const Color.fromARGB(250, 250, 250, 250);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage('assets/icons/eraser.png'),
                            color: Colors.white,
                            height: sy(30),
                            width: sy(30),
                          ),
                          Text(
                            'ERASER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: unDo,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage('assets/icons/undo.png'),
                            color: Colors.white,
                            height: sy(30),
                            width: sy(30),
                          ),
                          Text(
                            'UNDO CHANGES',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage('assets/icons/reload.png'),
                            color: Colors.white,
                            height: sy(30),
                            width: sy(30),
                          ),
                          Text(
                            'RELOAD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          points.clear();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.delete_left_fill,
                            size: sy(30),
                            color: Colors.white,
                          ),
                          Text(
                            'CLEAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image:
                                const AssetImage('assets/icons/download.png'),
                            color: Colors.white,
                            height: sy(30),
                            width: sy(30),
                          ),
                          Text(
                            'SAVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: sy(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
