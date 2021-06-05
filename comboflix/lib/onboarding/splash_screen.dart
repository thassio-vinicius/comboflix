import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/curved_text.dart';
import 'package:comboflix/utils/images.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
            child: RotatedBox(
              quarterTurns: 2,
              child: CurvedText(
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
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
