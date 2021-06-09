import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool fromSplash;

  const HomeScreen(this.fromSplash);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double opacity;

  @override
  void initState() {
    if (widget.fromSplash) {
      opacity = 0;
      Timer(Duration(seconds: 1), () {
        opacity = 1;
      });
    } else {
      opacity = 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('UI.home'),
      ),
    );
  }
}
