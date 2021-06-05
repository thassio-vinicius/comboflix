import 'package:comboflix/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ComboFlix());
}

class ComboFlix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
