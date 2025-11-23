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
      title: 'Flutter Welcome Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
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

class _HomePageState extends State<HomePage> {
  // Global keys for tour targets
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _feature1Key = GlobalKey();
  final GlobalKey _feature2Key = GlobalKey();
  final GlobalKey _feature3Key = GlobalKey();
  final GlobalKey _ctaKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  TourController? _tourController;
  int _currentStep = 0;
  bool _tourCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupTour());
  }

  void _setupTour() {
    _tourController = TourController(
      context: context,
      enableKeyboardNavigation: true,
      onTourComplete: () {
        setState(() {
          _tourCompleted = true;
        });
        _showCompletionSnackbar();
      },
      onTourSkipped: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tour skipped - Restart anytime!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      steps: [
        TourStep(
          key: _heroKey,
          title: "Welcome! 👋",
          description: "Let's take a quick tour of Flutter Welcome Kit - your modern onboarding solution.",
          backgroundColor: const Color(0xFF6366F1),
          textColor: Colors.white,
          animation: StepAnimation.fadeSlideDown,
          preferredSide: TooltipSide.bottom,
          onStepEnter: () => _updateStep(0),
        ),
        TourStep(
          key: _searchKey,
          title: "Smart Positioning",
          description: "Tooltips automatically position themselves to avoid screen edges and overlaps.",
          backgroundColor: const Color(0xFF8B5CF6),
          textColor: Colors.white,
          animation: StepAnimation.fadeSlideLeft,
          preferredSide: TooltipSide.bottomLeft,
          onStepEnter: () => _updateStep(1),
        ),
        TourStep(
          key: _notificationKey,
          title: "Beautiful Animations",
          description: "Choose from 8 different smooth animations to match your app's style.",
          backgroundColor: const Color(0xFFEC4899),
          textColor: Colors.white,
          animation: StepAnimation.scale,
          preferredSide: TooltipSide.left,
          onStepEnter: () => _updateStep(2),
        ),
        TourStep(
          key: _feature1Key,
          title: "Fully Responsive",
          description: "Works perfectly on all screen sizes - mobile, tablet, and desktop.",
          backgroundColor: const Color(0xFF10B981),
          textColor: Colors.white,
          animation: StepAnimation.fadeSlideUp,
          preferredSide: TooltipSide.top,
          onStepEnter: () => _updateStep(3),
        ),
        TourStep(
          key: _feature2Key,
          title: "Easy Integration",
          description: "Just add global keys to your widgets and define tour steps. That's it!",
          backgroundColor: const Color(0xFFF59E0B),
          textColor: Colors.white,
          animation: StepAnimation.bounce,
          onStepEnter: () => _updateStep(4),
        ),
        TourStep(
          key: _feature3Key,
          title: "Accessibility First",
          description: "Built with screen readers, keyboard navigation, and RTL support in mind.",
          backgroundColor: const Color(0xFF3B82F6),
          textColor: Colors.white,
          animation: StepAnimation.fadeSlideRight,
          onStepEnter: () => _updateStep(5),
        ),
        TourStep(
          key: _ctaKey,
          title: "Get Started Today",
          description: "Add it to your project and create amazing onboarding experiences in minutes!",
          backgroundColor: const Color(0xFF6366F1),
          textColor: Colors.white,
          animation: StepAnimation.bounce,
          onStepEnter: () => _updateStep(6),
        ),
        TourStep(
          key: _fabKey,
          title: "Tour Complete! 🎉",
          description: "You're ready to integrate Flutter Welcome Kit into your app. Happy coding!",
          backgroundColor: const Color(0xFF059669),
          textColor: Colors.white,
          animation: StepAnimation.scale,
          isLast: true,
          buttonLabel: "Done",
          preferredSide: TooltipSide.topLeft,
          onStepEnter: () => _updateStep(7),
        ),
      ],
    );
  }

  void _updateStep(int step) {
    setState(() {
      _currentStep = step + 1;
    });
  }

  void _showCompletionSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.celebration_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('Tour completed! 🎉')),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Restart',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _tourCompleted = false;
              _currentStep = 0;
            });
            _tourController?.start();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 900;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(theme, isDark),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeroSection(theme, isDark, screenWidth),
                _buildProgressSection(theme, isDark),
                _buildFeaturesSection(theme, isDark, isLargeScreen, isMediumScreen),
                _buildCTASection(theme, isDark),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(theme),
    );
  }

  Widget _buildAppBar(ThemeData theme, bool isDark) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tour_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Welcome Kit',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildIconButton(
                      icon: Icons.search_rounded,
                      globalKey: _searchKey,
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.notifications_rounded,
                      globalKey: _notificationKey,
                      theme: theme,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required GlobalKey globalKey,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      key: globalKey,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        onPressed: () {},
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, bool isDark, double screenWidth) {
    final isSmallScreen = screenWidth < 600;

    return Container(
      key: _heroKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? 80 : (isSmallScreen ? 24 : 40),
        vertical: isSmallScreen ? 48 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0A0A0A),
                  const Color(0xFF1A1A2E).withOpacity(0.5),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF3F4F6),
                ],
        ),
      ),
      child: Column(
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Modern • Minimal • Responsive',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 24 : 32),

          // Hero Title
          Text(
            'Beautiful Onboarding\nMade Simple',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: isSmallScreen ? 32 : (screenWidth > 1200 ? 56 : 48),
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Subtitle
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Create stunning, interactive tours with smart positioning, smooth animations, and accessibility-first design.',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: isSmallScreen ? 16 : 18,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isSmallScreen ? 32 : 40),

          // CTA Button
          FilledButton.icon(
            onPressed: () => _tourController?.start(),
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text('Start Interactive Tour'),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24 : 32,
                vertical: isSmallScreen ? 16 : 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF6366F1),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),

          // Stats Row
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildStat('8+', 'Animations', theme),
              _buildStat('100%', 'Responsive', theme),
              _buildStat('A11y', 'Built-in', theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(ThemeData theme, bool isDark) {
    if (_currentStep == 0 && !_tourCompleted) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _tourCompleted ? 'Tour Completed! 🎉' : 'Tour Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$_currentStep / 8',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: _currentStep / 8,
              minHeight: 8,
              backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(
    ThemeData theme,
    bool isDark,
    bool isLargeScreen,
    bool isMediumScreen,
  ) {
    final features = [
      _Feature(
        icon: Icons.auto_awesome_rounded,
        title: 'Smart Positioning',
        description: 'Tooltips automatically adapt to avoid screen edges and overlaps.',
        color: const Color(0xFF6366F1),
        globalKey: _feature1Key,
      ),
      _Feature(
        icon: Icons.animation,
        title: 'Smooth Animations',
        description: 'Choose from 8 beautiful animations with 60fps performance.',
        color: const Color(0xFF8B5CF6),
        globalKey: _feature2Key,
      ),
      _Feature(
        icon: Icons.accessibility_rounded,
        title: 'Accessibility First',
        description: 'Screen readers, keyboard navigation, and RTL support included.',
        color: const Color(0xFFEC4899),
        globalKey: _feature3Key,
      ),
      _Feature(
        icon: Icons.palette_rounded,
        title: 'Fully Customizable',
        description: 'Control every aspect - colors, timing, positioning, and more.',
        color: const Color(0xFF10B981),
        globalKey: null,
      ),
      _Feature(
        icon: Icons.devices_rounded,
        title: 'Cross Platform',
        description: 'Works seamlessly on iOS, Android, Web, and Desktop.',
        color: const Color(0xFFF59E0B),
        globalKey: null,
      ),
      _Feature(
        icon: Icons.code_rounded,
        title: 'Developer Friendly',
        description: 'Simple API with comprehensive docs and examples.',
        color: const Color(0xFF3B82F6),
        globalKey: null,
      ),
    ];

    final crossAxisCount = isLargeScreen ? 3 : (isMediumScreen ? 2 : 1);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Why Choose Welcome Kit?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isLargeScreen ? 1.3 : (isMediumScreen ? 1.2 : 1.5),
            ),
            itemCount: features.length,
            itemBuilder: (context, index) => _buildFeatureCard(features[index], theme, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(_Feature feature, ThemeData theme, bool isDark) {
    return Container(
      key: feature.globalKey,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              feature.icon,
              color: feature.color,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            feature.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(ThemeData theme, bool isDark) {
    return Container(
      key: _ctaKey,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rocket_launch_rounded,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to Get Started?',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Add Flutter Welcome Kit to your project and start creating amazing experiences.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: SelectableText(
              'dependencies:\n  flutter_welcome_kit: ^1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: Colors.white,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description_rounded),
            label: const Text('View Documentation'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(ThemeData theme) {
    final isActive = _tourController?.isActive ?? false;

    return FloatingActionButton.extended(
      key: _fabKey,
      onPressed: isActive ? null : () => _tourController?.start(),
      icon: Icon(isActive ? Icons.tour_rounded : Icons.play_arrow_rounded),
      label: Text(isActive ? 'Tour Active' : 'Start Tour'),
      backgroundColor: isActive ? Colors.grey : const Color(0xFF6366F1),
      foregroundColor: Colors.white,
      elevation: 4,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final GlobalKey? globalKey;

  _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.globalKey,
  });
}
