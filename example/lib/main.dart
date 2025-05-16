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
      title: 'Welcome',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
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
  final GlobalKey _logoKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  late TourController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = TourController(
        context: context,
        steps: [
          TourStep(
            key: _logoKey,
            title: "Welcome to Flutter Tour!",
            description: "This app uses an interactive onboarding tour.",
            arrowAlignment: ArrowAlignment(ArrowPosition.top, ArrowDirection.up),
            backgroundColor: Colors.deepPurple.shade100,
          ),
          TourStep(
            key: _textKey,
            title: "Helpful Text",
            description: "Here’s some info users should notice.",
            arrowAlignment: ArrowAlignment(ArrowPosition.top, ArrowDirection.up),
            backgroundColor: Colors.orange.shade100,
          ),
          TourStep(
            key: _searchKey,
            title: "Search Button",
            description: "Tap here to search through the app.",
            arrowAlignment: ArrowAlignment(ArrowPosition.top, ArrowDirection.up),
            backgroundColor: Colors.green.shade100,
          ),
          TourStep(
            key: _settingsKey,
            title: "Settings",
            description: "Customize your experience here.",
            arrowAlignment: ArrowAlignment(ArrowPosition.top, ArrowDirection.up),
            backgroundColor: Colors.red.shade100,
          ),
          TourStep(
            key: _fabKey,
            title: "Quick Action",
            description: "Use this button for quick actions.",
            arrowAlignment: ArrowAlignment(ArrowPosition.bottom, ArrowDirection.down),
            backgroundColor: Colors.blue.shade100,
            isLast: true,
            buttonLabel: "Got it!",
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Kit Example'),
        actions: [
          IconButton(
            key: _searchKey,
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            key: _settingsKey,
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 80, key: _logoKey),
            const SizedBox(height: 24),
            Text(
              "Welcome to the guided tour demo!",
              key: _textKey,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _controller.start(),
              child: const Text("Start Tour"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}