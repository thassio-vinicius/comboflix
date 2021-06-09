import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/UI/onboarding/splash_screen.dart';
import 'package:comboflix/services/authentication_provider.dart';
import 'package:comboflix/services/firestore_provider.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ComboFlix());
}

class ComboFlix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          print('app created');

          return MultiProvider(
            providers: [
              Provider(
                create: (_) => AuthenticationProvider(
                  firebaseAuth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                ),
              ),
              Provider<FirestoreProvider>(
                create: (_) => FirestoreProvider(
                  FirebaseFirestore.instance,
                  FirebaseAuth.instance,
                ),
              ),
            ],
            child: MaterialApp(
              theme: ThemeData(
                textTheme: TextTheme(
                  headline1: GoogleFonts.openSans(
                    color: HexColor('4D44A3'),
                    fontSize: Adapt.px(36),
                    fontWeight: FontWeight.w600,
                  ),
                  headline2: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: Adapt.px(36),
                    fontWeight: FontWeight.w600,
                  ),
                  headline3: GoogleFonts.openSans(
                    color: HexColor('4D44A3'),
                    fontSize: Adapt.px(24),
                    fontWeight: FontWeight.w600,
                  ),
                  headline4: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: Adapt.px(24),
                    fontWeight: FontWeight.w600,
                  ),
                  headline5: GoogleFonts.openSans(
                    color: HexColor('4D44A3'),
                    fontSize: Adapt.px(18),
                    fontWeight: FontWeight.w500,
                  ),
                  headline6: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: Adapt.px(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: HexColor('#4D44A3'),
                buttonColor: HexColor('#202250'),
                cardColor: HexColor('A57BC4'),
                indicatorColor: HexColor('4D44A3'),
              ),
              home: SplashScreen(false),
            ),
          );
        }
      },
    );
  }
}
