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
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _leftButtonKey = GlobalKey();
  final GlobalKey _rightButtonKey = GlobalKey();
  final GlobalKey _bottomTextKey = GlobalKey();
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
            title: "Welcome!",
            description:
                "Let's explore all possible tooltip positions and arrow directions.",
            backgroundColor: Colors.blue.shade100,
          ),
          TourStep(
            key: _titleKey,
            title: "App Bar Title",
            description:
                "When elements are at the top, the arrow automatically points upward.",
            backgroundColor: Colors.purple.shade100,
          ),
          TourStep(
            key: _searchKey,
            title: "Search Icon",
            description:
                "For elements near screen edges, the tooltip adjusts its position.",
            backgroundColor: Colors.orange.shade100,
          ),
          TourStep(
            key: _settingsKey,
            title: "Settings",
            description: "Notice how the arrow follows the target element.",
            backgroundColor: Colors.green.shade100,
          ),
          TourStep(
            key: _leftButtonKey,
            title: "Left Side",
            description:
                "For elements on the left, the tooltip appears on the right.",
            backgroundColor: Colors.red.shade100,
          ),
          TourStep(
            key: _rightButtonKey,
            title: "Right Side",
            description: "And vice versa for elements on the right side.",
            backgroundColor: Colors.teal.shade100,
          ),
          TourStep(
            key: _bottomTextKey,
            title: "Bottom Elements",
            description:
                "For elements at the bottom, the arrow points downward.",
            backgroundColor: Colors.amber.shade100,
            duration: const Duration(seconds: 4),
          ),
          TourStep(
            key: _fabKey,
            title: "Floating Action Button",
            description: "The tooltip handles corner positions gracefully!",
            backgroundColor: Colors.indigo.shade100,
            isLast: true,
            buttonLabel: "Finish Tour",
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: _logoKey,
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text('Welcome Kit Demo', key: _titleKey),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  key: _leftButtonKey,
                  onPressed: () {},
                  child: const Text("Left Side Button"),
                ),
                ElevatedButton(
                  key: _rightButtonKey,
                  onPressed: () {},
                  child: const Text("Right Side Button"),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Bottom aligned text example",
              key: _bottomTextKey,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _controller.start(),
              child: const Text("Start Demo Tour"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {},
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
