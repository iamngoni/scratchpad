//
//  scratchpad
//  app
//
//  Created by Ngonidzashe Mangudya on 02/04/2024.
//  Copyright (c) 2024 ModestNerds, Co
//

import 'package:flutter/material.dart';

import 'sketch_pad.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scratchpad',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SketchPad(),
    );
  }
}
