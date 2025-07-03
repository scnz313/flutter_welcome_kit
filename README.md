# Flutter Welcome Kit 🚀

A lightweight, **highly-customisable onboarding / feature-tour solution** for Flutter.  
It lets you spotlight widgets, show contextual tooltips and guide users step-by-step through your app – with virtually zero boilerplate.

[![pub package](https://img.shields.io/pub/v/flutter_welcome_kit?color=blue)](https://pub.dev/packages/flutter_welcome_kit)
[![platforms](https://img.shields.io/badge/platforms-mobile%20%7C%20web%20%7C%20desktop-green)](#)
[![license](https://img.shields.io/github/license/Usman-bhat/flutter_welcome_kit)](LICENSE)

---

## ✨ Features

| Category | Capability |
|----------|------------|
| **Spotlight overlay** | Rectangle / circle / oval / custom shapes, padding, animated (fade / scale / slide / bounce / rotate), multi-spotlight support |
| **Tooltip card** | Icons, images, rich text, auto-layout, adaptive width, dark/light theme, progress indicator (“Step x of y”), swipe navigation, keyboard shortcuts, haptic feedback |
| **Controller** | Start / next / previous / jumpTo / end, listeners, random access, completion callback, `ValueNotifier` for progress |
| **Global theming** | `TourConfig` singleton – colours, curves, durations, border-radii, overlay tint, default button style, accessibility, close-on-tap |
| **Data model** | `TourStep` now supports icon, image, custom animation, padding, border radius, overlay colour, semantics, per-step progress toggle |
| **Accessibility** | Screen-reader labels + hints, semantically excluded cut-out, large-text friendliness |
| **Cross-platform** | Works on Android, iOS, macOS, Windows, Linux, Web |
| **No external deps** | Pure Flutter/Dart – small install size |

---

## 📦 Installation

```bash
flutter pub add flutter_welcome_kit
```

Minimum SDK:
```yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.0.0"
```

---

## 🚀 Quick Start

```dart
import 'package:flutter_welcome_kit/flutter_welcome_kit.dart';

class HomePageState extends State<HomePage> {
  final _logoKey = GlobalKey();
  late final TourController _tour;

  @override
  void initState() {
    super.initState();
    _tour = TourController(
      context: context,
      steps: [
        TourStep(
          key: _logoKey,
          title: 'Welcome!',
          description: 'Tap here any time for the main menu.',
          icon: Icons.menu,
          backgroundColor: Colors.blue,
        ),
        TourStep(
          key: _fabKey,
          title: 'Create',
          description: 'Add items with the floating button.',
          isLast: true,
          buttonLabel: 'Got it ✔',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: IconButton(key: _logoKey, icon: Icon(Icons.menu), onPressed: () {})),
        floatingActionButton: FloatingActionButton(key: _fabKey, onPressed: () {}),
        body: Center(
          child: ElevatedButton(
            child: const Text('Start tour'),
            onPressed: _tour.start,
          ),
        ),
      );
}
```

---

## 🎨 Advanced Customisation

### 1. Global theme with `TourConfig`

```dart
TourConfig.updateGlobal(
  TourConfig(
    backgroundColor: Colors.grey[900]!,
    textColor: Colors.white,
    overlayColor: Colors.black.withOpacity(.75),
    tooltipBorderRadius: BorderRadius.circular(20),
    animationCurve: Curves.fastOutSlowIn,
    showProgressIndicator: true,
    buttonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
  ),
);
```

### 2. Rich `TourStep`

```dart
TourStep(
  key: _cardKey,
  title: 'Payment Methods',
  description: 'Choose debit / credit / wallet.',
  image: NetworkImage('https://example.com/card.png'),
  icon: Icons.credit_card,
  padding: 12,
  borderRadius: BorderRadius.circular(24),
  animation: StepAnimation.slide,
  overlayColor: Colors.black.withOpacity(.6),
  semanticLabel: 'Payment section',
)
```

### 3. Custom spotlight shapes

```dart
Spotlight(
  targetRect: myRect,
  shape: SpotlightShape.circle,
  animate: true,
  animationType: StepAnimation.scale,
);
```

---

## 📚 API Overview

| Class | Purpose | Key Members |
|-------|---------|-------------|
| **TourStep** | Immutable data describing a single step | `key` • `title` • `description` • `icon` • `image` • `padding` • `borderRadius` • `animation` • `isLast` |
| **TourController** | Runtime orchestrator | `start()` • `next()` • `previous()` • `jumpTo(idx)` • `end()` • `currentStepNotifier` |
| **TourConfig** | Global defaults & theming | colours, curves, durations, progress text, haptics |
| **Spotlight** | Overlay with cut-out | `shape` • `padding` • `animate` • `additionalTargets` |
| **TooltipCard** | The floating card widget | auto positioning, swipe, keyboard, progress |

Inline doc comments are provided throughout the source; use **Dart IDE tooltips** or run `dart doc` for full reference.

---

## 🛠 Troubleshooting & Best Practices

| Issue | Fix |
|-------|-----|
| Overlay appears behind dialogs | Ensure `TourController.start()` is called **after** the first frame (`WidgetsBinding.instance.addPostFrameCallback`). |
| Wrong target position | Pass the correct `GlobalKey` to every widget **after** it is mounted. |
| Cut-out clipped on web | Add `debugShowCheckedModeBanner: false` and avoid ancestor `Clip*` widgets. |
| Performance | Avoid extremely large images in tooltips; keep animations < 60 fps. |

Tips:

* Prefer **short descriptions** (2-3 lines).  
* Supply contrasting `backgroundColor` & `textColor` for accessibility.  
* Disable auto-advance on steps requiring user action.  

---

## 🤝 Contributing

Contributions are welcome!

1. Fork → create branch → commit *conventional commits* → PR  
2. Write/maintain unit tests (`flutter test`)  
3. Follow `flutter_lints` – run `flutter analyze`  
4. For bigger changes, open an issue first to discuss.

Please read [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) (TBD).

---

## 📜 License

Flutter Welcome Kit is released under the **MIT License**.  
See the [LICENSE](LICENSE) file for details.
