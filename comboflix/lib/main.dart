import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/UI/onboarding/splash_screen.dart';
import 'package:comboflix/UI/shared_widgets/loading_screen.dart';
import 'package:comboflix/services/authentication_provider.dart';
import 'package:comboflix/services/firestore_provider.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ComboFlix());
}

class ComboFlix extends StatelessWidget {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
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
              fontSize: Adapt.px(22),
              fontWeight: FontWeight.w600,
            ),
            headline4: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: Adapt.px(22),
              fontWeight: FontWeight.w600,
            ),
            headline5: GoogleFonts.openSans(
              color: HexColor('4D44A3'),
              fontSize: Adapt.px(15),
              fontWeight: FontWeight.w500,
            ),
            headline6: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: Adapt.px(15),
              fontWeight: FontWeight.w500,
            ),
            button: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: HexColor('#4D44A3'), //purple
          buttonColor: HexColor('#202250'), //darker purple
          cardColor: HexColor('A57BC4'), // light purple
          indicatorColor: HexColor('4D44A3'), //dark purple
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            } else {
              return SplashScreen(snapshot.hasData);
            }
          },
        ),
      ),
    );
  }
}
