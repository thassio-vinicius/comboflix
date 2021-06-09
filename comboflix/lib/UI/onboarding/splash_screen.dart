import 'dart:async';

import 'package:comboflix/UI/home/home_screen.dart';
import 'package:comboflix/UI/onboarding/authentication_screen.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/curved_text.dart';
import 'package:comboflix/utils/custom_faderoute.dart';
import 'package:comboflix/utils/images.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final bool loggedIn;

  const SplashScreen(this.loggedIn);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool animationCompleted = false;
  double opacity = 0;
  late AnimationController animationController;

  @override
  void initState() {
    Timer(Duration(milliseconds: 300), () {
      setState(() {
        opacity = 1;
      });
    });
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250),
        reverseDuration: Duration(milliseconds: 250));
    super.initState();

    animationController.addListener(() {
      /*
      if (animationCompleted) {
        setState(() {
          animationController.reverse();
          animationCompleted = false;
        });
      } else {
        setState(() {
          animationController.forward();
          animationCompleted = true;
        });
      }
       */
      setState(() {});
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (animationCompleted) {
        if (mounted)
          setState(() {
            animationController.reverse();
            animationCompleted = false;
          });
      } else {
        if (mounted)
          setState(() {
            animationController.forward();
            animationCompleted = true;
          });
      }
    });
    animationController.repeat();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CustomFadeRoute(
          child:
              widget.loggedIn ? HomeScreen(true) : AuthenticationScreen(true),
          routeName: widget.loggedIn ? 'HomeScreen' : 'AuthenticationScreen',
        ),
      );
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image(
            image: AssetImage(Images.splashImage),
            fit: BoxFit.fill,
          )),
          Positioned.fill(
            top: 160,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: opacity,
              onEnd: () {
                setState(() {
                  animationCompleted = true;
                });
              },
              child: RotatedBox(
                  quarterTurns: 2,
                  child: animationCompleted ? title(true) : title(false)),
            ),
          )
        ],
      ),
    );
  }

  CurvedText title(bool glow) {
    return CurvedText(
      text: Strings.comboFlix,
      radius: 240,
      textStyle: GoogleFonts.bangers(
        color: Colors.white,
        fontSize: Adapt.px(70),
        letterSpacing: 5,
        fontWeight: FontWeight.w600,
        shadows: <Shadow>[
          Shadow(
            color: Colors.black45,
            offset: Offset(-5, -5),
            blurRadius: 15,
          ),
          Shadow(
            color: Colors.black45,
            offset: Offset(-5, -5),
            blurRadius: 1,
          ),
          if (glow)
            BoxShadow(
              color: Colors.white,
              spreadRadius: 4,
              blurRadius: 10,
            ),
          if (glow)
            BoxShadow(
              color: Colors.white,
              spreadRadius: -4,
              blurRadius: 5,
            ),
          if (glow)
            BoxShadow(
              color: Colors.white.withAlpha(60),
              blurRadius: 6.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                3.0,
              ),
            ),
        ],
      ),
    );
  }
}
