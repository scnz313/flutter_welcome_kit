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
      title: 'Flutter Welcome Kit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Global keys for tour targets
  final GlobalKey _logoKey = GlobalKey();
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _primaryButtonKey = GlobalKey();
  final GlobalKey _secondaryButtonKey = GlobalKey();
  final GlobalKey _bottomTextKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _progressKey = GlobalKey();

  late TourController _tourController;
  late AnimationController _textAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _textAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardRotationAnimation;

  bool _tourCompleted = false;
  int _completedSteps = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupTour());
  }

  void _setupAnimations() {
    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _cardAnimationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _textAnimation = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeInOut),
    );

    _cardRotationAnimation = Tween<double>(begin: -0.01, end: 0.01).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeInOut),
    );
  }

  void _setupTour() {
    _tourController = TourController(
      context: context,
      enableKeyboardNavigation: true,
      onTourComplete: () {
        setState(() {
          _tourCompleted = true;
        });
        _showCompletionDialog();
      },
      onTourSkipped: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tour skipped. You can restart it anytime!')),
        );
      },
      steps: [
        TourStep(
          key: _logoKey,
          title: "👋 Welcome to Flutter Welcome Kit!",
          description: "Let's take a quick interactive tour to explore all the amazing features this package offers.",
          backgroundColor: Colors.blue.shade50,
          textColor: Colors.blue.shade800,
          animation: StepAnimation.fadeSlideDown,
          preferredSide: TooltipSide.bottomRight,
          duration: const Duration(seconds: 5),
          accessibilityLabel: "Welcome step - Introduction to the tour",
          onStepEnter: () => _updateProgress(0),
        ),
        TourStep(
          key: _titleKey,
          title: "🎯 Smart Positioning",
          description: "Notice how this tooltip automatically positioned itself optimally? The kit uses intelligent algorithms to avoid overlaps and screen edges.",
          backgroundColor: Colors.purple.shade50,
          textColor: Colors.purple.shade800,
          animation: StepAnimation.bounce,
          preferredSide: TooltipSide.bottom,
          onStepEnter: () => _updateProgress(1),
        ),
        TourStep(
          key: _searchKey,
          title: "🔍 Multiple Animations",
          description: "Each step can have different animations. This one uses a slide effect from the left side.",
          backgroundColor: Colors.orange.shade50,
          textColor: Colors.orange.shade800,
          animation: StepAnimation.fadeSlideLeft,
          preferredSide: TooltipSide.bottomLeft,
          onStepEnter: () => _updateProgress(2),
        ),
        TourStep(
          key: _settingsKey,
          title: "⚙️ Customizable Design",
          description: "Every aspect is customizable - colors, animations, positioning, and more. This step showcases the scale animation.",
          backgroundColor: Colors.green.shade50,
          textColor: Colors.green.shade800,
          animation: StepAnimation.scale,
          preferredSide: TooltipSide.left,
          pointerPadding: 12.0,
          pointerRadius: 16.0,
          onStepEnter: () => _updateProgress(3),
        ),
        TourStep(
          key: _profileKey,
          title: "👤 Accessibility First",
          description: "Full screen reader support, keyboard navigation (try arrow keys!), and RTL language support included.",
          backgroundColor: Colors.indigo.shade50,
          textColor: Colors.indigo.shade800,
          animation: StepAnimation.rotate,
          accessibilityLabel: "Accessibility features explanation",
          onStepEnter: () => _updateProgress(4),
        ),
        TourStep(
          key: _cardKey,
          title: "🎨 Beautiful Design",
          description: "Modern Material Design 3 styling with smooth shadows, proper contrast ratios, and responsive layouts.",
          backgroundColor: Colors.teal.shade50,
          textColor: Colors.teal.shade800,
          animation: StepAnimation.fadeSlideUp,
          preferredSide: TooltipSide.top,
          onStepEnter: () => _updateProgress(5),
        ),
        TourStep(
          key: _primaryButtonKey,
          title: "🚀 Easy Integration",
          description: "Just add global keys to your widgets and define tour steps. No complex setup required!",
          backgroundColor: Colors.pink.shade50,
          textColor: Colors.pink.shade800,
          animation: StepAnimation.bounce,
          onStepEnter: () => _updateProgress(6),
        ),
        TourStep(
          key: _secondaryButtonKey,
          title: "🎮 Interactive Controls",
          description: "Users can navigate with buttons, keyboard shortcuts, or tap outside to skip. Full control at their fingertips.",
          backgroundColor: Colors.amber.shade50,
          textColor: Colors.amber.shade800,
          animation: StepAnimation.fadeSlideRight,
          onStepEnter: () => _updateProgress(7),
        ),
        TourStep(
          key: _progressKey,
          title: "📊 Progress Tracking",
          description: "Built-in step tracking with callbacks for analytics. Monitor user engagement and tour completion rates.",
          backgroundColor: Colors.cyan.shade50,
          textColor: Colors.cyan.shade800,
          animation: StepAnimation.scale,
          preferredSide: TooltipSide.top,
          onStepEnter: () => _updateProgress(8),
        ),
        TourStep(
          key: _fabKey,
          title: "🎉 Tour Complete!",
          description: "You've experienced all the key features! Ready to integrate Flutter Welcome Kit into your app?",
          backgroundColor: Colors.deepPurple.shade50,
          textColor: Colors.deepPurple.shade800,
          animation: StepAnimation.bounce,
          isLast: true,
          buttonLabel: "Awesome!",
          preferredSide: TooltipSide.topLeft,
          onStepEnter: () => _updateProgress(9),
        ),
      ],
    );
  }

  void _updateProgress(int step) {
    setState(() {
      _completedSteps = step + 1;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('Congratulations!'),
          ],
        ),
        content: Text(
          'You\'ve completed the Flutter Welcome Kit tour! 🎉\n\n'
          'Check out the GitHub repository for documentation, examples, and contribution guidelines.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartTour();
            },
            child: Text('Restart Tour'),
          ),
        ],
      ),
    );
  }

  void _restartTour() {
    setState(() {
      _tourCompleted = false;
      _completedSteps = 0;
    });
    _tourController.start();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          key: _logoKey,
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          'Flutter Welcome Kit Demo',
          key: _titleKey,
        ),
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
          IconButton(
            key: _profileKey,
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[800]!, Colors.grey[850]!]
                : [Colors.grey[50]!, Colors.white, Colors.grey[100]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              _buildProgressIndicator(theme),
              const SizedBox(height: 24),

              // Main feature card
              _buildMainCard(theme, isDark),
              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(theme),
              const SizedBox(height: 32),

              // Feature highlights
              _buildFeatureGrid(theme),
              const SizedBox(height: 32),

              // Bottom information
              _buildBottomInfo(theme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: _fabKey,
        onPressed: _tourController.isActive ? null : () => _tourController.start(),
        icon: Icon(_tourController.isActive ? Icons.tour : Icons.play_arrow),
        label: Text(_tourController.isActive ? 'Tour Active' : 'Start Tour'),
        backgroundColor: _tourController.isActive ? Colors.grey : theme.primaryColor,
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      key: _progressKey,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tour Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_completedSteps / 10',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _completedSteps / 10,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          if (_tourCompleted) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Tour completed successfully!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainCard(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([_cardScaleAnimation, _cardRotationAnimation]),
      builder: (context, child) => Transform.scale(
        scale: _cardScaleAnimation.value,
        child: Transform.rotate(
          angle: _cardRotationAnimation.value,
          child: Card(
            key: _cardKey,
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.grey[850]!.withOpacity(0.9),
                              Colors.grey[900]!.withOpacity(0.9),
                            ]
                          : [
                              Colors.white.withOpacity(0.9),
                              Colors.grey[50]!.withOpacity(0.9),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildAnimatedTitle(theme),
                      const SizedBox(height: 24),
                      _buildDescription(theme),
                      const SizedBox(height: 24),
                      _buildFeatureIcons(theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(ThemeData theme) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_textAnimation.value * 0.02)
          ..translate(0.0, _floatAnimation.value, 0.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: _glowAnimation.value * 2,
                    spreadRadius: _glowAnimation.value,
                  ),
                ],
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Flutter Welcome Kit',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Beautiful Onboarding Tours Made Simple',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      'Create stunning, interactive onboarding experiences with smart positioning, '
      'smooth animations, and accessibility-first design. Perfect for guiding users '
      'through your app\'s features.',
      style: theme.textTheme.bodyLarge?.copyWith(
        height: 1.6,
        color: theme.colorScheme.onSurface.withOpacity(0.8),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFeatureIcons(ThemeData theme) {
    final features = [
      (Icons.auto_awesome, 'Smart\nPositioning'),
      (Icons.animation, 'Smooth\nAnimations'),
      (Icons.accessibility, 'Accessibility\nFirst'),
      (Icons.palette, 'Customizable\nDesign'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features.map((feature) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature.$1,
                color: theme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature.$2,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            key: _primaryButtonKey,
            onPressed: () => _tourController.start(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Interactive Tour'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            key: _secondaryButtonKey,
            onPressed: _showFeatureDialog,
            icon: const Icon(Icons.info_outline),
            label: const Text('Learn More'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(ThemeData theme) {
    final features = [
      _FeatureCard(
        icon: Icons.speed,
        title: 'Lightning Fast',
        description: 'Optimized performance with smooth 60fps animations',
        color: Colors.orange,
      ),
      _FeatureCard(
        icon: Icons.devices,
        title: 'Cross Platform',
        description: 'Works perfectly on iOS, Android, Web, and Desktop',
        color: Colors.blue,
      ),
      _FeatureCard(
        icon: Icons.code,
        title: 'Developer Friendly',
        description: 'Simple API with comprehensive documentation',
        color: Colors.green,
      ),
      _FeatureCard(
        icon: Icons.security,
        title: 'Production Ready',
        description: 'Battle-tested with proper error handling',
        color: Colors.red,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) => _buildFeatureCard(features[index], theme),
    );
  }

  Widget _buildFeatureCard(_FeatureCard feature, ThemeData theme) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: feature.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature.icon,
                color: feature.color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo(ThemeData theme) {
    return Container(
      key: _bottomTextKey,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            '🚀 Ready to Get Started?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Add Flutter Welcome Kit to your pubspec.yaml and start creating amazing onboarding experiences in minutes!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'dependencies:\n  flutter_welcome_kit: ^1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 Key Features'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFeatureItem('✨ Smart Auto-positioning'),
              _buildFeatureItem('🎨 8 Different Animation Types'),
              _buildFeatureItem('🎯 Precise Widget Targeting'),
              _buildFeatureItem('⌨️ Full Keyboard Navigation'),
              _buildFeatureItem('♿ Complete Accessibility Support'),
              _buildFeatureItem('🌍 RTL Language Support'),
              _buildFeatureItem('📱 Responsive Design'),
              _buildFeatureItem('🎮 Interactive Controls'),
              _buildFeatureItem('📊 Progress Tracking'),
              _buildFeatureItem('🔧 Highly Customizable'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _tourController.start();
            },
            child: const Text('Try It Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text),
    );
  }
}

class _FeatureCard {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
