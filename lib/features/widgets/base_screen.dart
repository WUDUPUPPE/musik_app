import 'package:flutter/material.dart';
import '../animation/sonar_BgAnimation.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final bool showSonar;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const BaseScreen({
    super.key,
    required this.child,
    this.showSonar = true,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xBA0C051B),
              Color(0xBA250B37),
              Color(0xC5341355),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              if (showSonar)
                const Positioned.fill(child: SonarBackground()),
              Positioned.fill(child: child),
            ],
          ),
        ),
      ),
    );
  }
}