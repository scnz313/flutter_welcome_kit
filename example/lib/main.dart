// File: example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/flutter_welcome_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Kit Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();

  late TourController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = TourController(
        context: context,
        steps: [
          TourStep(
            key: _textKey,
            title: "Welcome!",
            description: "This is an introductory message.",
          ),
          TourStep(
            key: _buttonKey,
            title: "Start Button",
            description: "Click this button to begin your journey.",
            alignment: TourAlignment.top,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome Kit Example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Hello there!", key: _textKey),
            const SizedBox(height: 20),
            ElevatedButton(
              key: _buttonKey,
              onPressed: () => _controller.start(),
              child: const Text("Show Tour"),
            ),
          ],
        ),
      ),
    );
  }
}
