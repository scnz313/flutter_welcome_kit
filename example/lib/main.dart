import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/flutter_welcome_kit.dart';
import 'dart:math' as math;
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF303030),
          surface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey _logoKey = GlobalKey();
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _leftButtonKey = GlobalKey();
  final GlobalKey _rightButtonKey = GlobalKey();
  final GlobalKey _bottomTextKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  late TourController _controller;
  final double cardWidth = 280.0;

  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = TourController(
        context: context,
        steps: [
          TourStep(
            key: _logoKey,
            title: "👋 Welcome to the Demo!",
            description:
                "Let me show you around this awesome demo application.",
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
          ),
          TourStep(
            key: _titleKey,
            title: "App Navigation",
            description:
                "This is where you'll find the main navigation controls.",
            backgroundColor: Colors.purple,
            //animation: StepAnimation.fadeSlideUp,
          ),
          TourStep(
            key: _searchKey,
            title: "Quick Search",
            description: "Search functionality is always at your fingertips.",
            backgroundColor: Colors.orange,
            //animation: StepAnimation.fadeSlideLeft,
          ),
          TourStep(
            key: _settingsKey,
            title: "Customize Settings",
            description: "Configure the app to match your preferences.",
            backgroundColor: Colors.green,
            //animation: StepAnimation.bounce,
          ),
          TourStep(
            key: _leftButtonKey,
            title: "Primary Actions",
            description: "Quick access to your most important tasks.",
            backgroundColor: Colors.pink,
            //animation: StepAnimation.fadeSlideRight,
          ),
          TourStep(
            key: _rightButtonKey,
            title: "Secondary Actions",
            description: "Additional options for advanced users.",
            backgroundColor: Colors.teal,
            //animation: StepAnimation.scale,
          ),
          TourStep(
            key: _bottomTextKey,
            title: "Status Updates",
            description: "Important notifications appear here.",
            backgroundColor: Colors.amber,
            //animation: StepAnimation.fadeSlideUp,
          ),
          TourStep(
            key: _fabKey,
            title: "Quick Actions",
            description: "Access frequently used features with a single tap!",
            backgroundColor: Colors.indigo,
            isLast: true,
            buttonLabel: "Got it!",
            //animation: StepAnimation.rotate,
          ),
        ],
      );
    });

    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _textAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          key: _logoKey,
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Feature Tour Demo',
          key: _titleKey,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            key: _searchKey,
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            key: _settingsKey,
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              const Color(0xFF1A1A1A),
              const Color(0xFF202020),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    key: _leftButtonKey,
                    onPressed: () {},
                    icon: const Icon(Icons.star),
                    label: const Text("Primary"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF303030),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  ElevatedButton.icon(
                    key: _rightButtonKey,
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark),
                    label: const Text("Secondary"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF303030),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Card(
                elevation: 20,
                shadowColor: Colors.black.withOpacity(0.5),
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: _textAnimationController,
                              builder: (context, child) {
                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateX(_textAnimation.value * 0.05)
                                    ..translate(0.0, _floatAnimation.value, 0.0),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: _glowAnimation.value * 1,
                                              spreadRadius: _glowAnimation.value,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.3),
                                              blurRadius: _glowAnimation.value * 5,
                                              spreadRadius: _glowAnimation.value,
                                            ),
                                          ],
                                        ),
                                        child: ShaderMask(
                                          shaderCallback: (bounds) => LinearGradient(
                                            colors: [
                                              const Color(0xFF4A4A4A),
                                              const Color(0xFFE0E0E0),
                                              const Color(0xFF707070),
                                              const Color(0xFFD8D8D8),
                                              const Color(0xFF505050),
                                            ],
                                            stops: const [
                                              0.0,
                                              0.25,
                                              0.5,
                                              0.75,
                                              1.0,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            transform: GradientRotation(math.pi / 4),
                                          ).createShader(bounds),
                                          child: Text(
                                            'Flutter Welcome Kit',
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white.withOpacity(0.2),
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 5 + _glowAnimation.value,
                                                ),
                                                Shadow(
                                                  color: Colors.white.withOpacity(0.9),
                                                  offset: const Offset(-2, -2),
                                                  blurRadius: 5 + _glowAnimation.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'by Mohammad Usman',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[300],
                                          letterSpacing: 0.5,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.3),
                                              offset: const Offset(1, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            Text(
                              "Welcome to the Demo",
                              key: _bottomTextKey,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                                                    ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => _controller.start(),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Start Interactive Tour"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {},
        backgroundColor: const Color(0xFF303030),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
