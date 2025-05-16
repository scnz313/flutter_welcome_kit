
Flutter Welcome Kit

A lightweight and customizable onboarding experience for Flutter apps. Highlight widgets with spotlight overlays and walk users through your app with step-by-step tooltips.




---

Features

Spotlight Overlay: Dim the background and highlight any widget.

Tooltip Steps: Show step-by-step instructions near UI elements.

Custom Alignment: Top, bottom, left, right, or center.

Reusable Controller: Trigger tour programmatically.

Clean API: Simple and flexible usage.



---

Installation

Add the package to your pubspec.yaml:

dependencies:
  flutter_welcome_kit: ^1.0.0

  Then run:

  flutter pub get


  ---

  Usage

  1. Assign GlobalKey to widgets you want to highlight:

  final GlobalKey myKey = GlobalKey();

  2. Wrap your widgets with the key:

  Text('Hello!', key: myKey)

  3. Create a tour controller:

  final controller = TourController(
    context: context,
      steps: [
          TourStep(
                key: myKey,
                      title: 'Welcome',
                            description: 'This highlights the Hello text.',
                                ),
                                  ],
                                  );

                                  4. Start the tour:

                                  controller.start();


                                  ---

                                  Example

                                  To try the full example:

                                  cd example
                                  flutter run


                                  ---

                                  Screenshots

                                  Spotlight Overlay	Tooltip Step

                                  	



                                    ---

                                    Coming Soon

                                    [ ] Animated transitions

                                    [ ] Custom widget support

                                    [ ] Persisted walkthrough state



                                    ---

                                    Contributing

                                    Pull requests are welcome. For major changes, open an issue first.

                                    1. Fork the repo


                                    2. Create your branch


                                    3. Commit your changes


                                    4. Push and open PR




                                    ---

                                    License

                                    MIT License

                                    

