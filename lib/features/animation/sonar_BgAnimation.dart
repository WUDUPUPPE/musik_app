import 'dart:math';
import 'package:flutter/material.dart';

/// Animated SONAR background widget.
/// Place it inside a Stack as background layer.
/// Works on any gradient — fully independent.
class SonarBackground extends StatefulWidget {
  const SonarBackground({super.key});

  @override
  State<SonarBackground> createState() => _SonarBackgroundState();
}

class _SonarBackgroundState extends State<SonarBackground>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _floatController;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    // Slow glow pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6200),
    )..repeat(reverse: true);

    // Gentle float movement
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6200),
    )..repeat(reverse: true);

    // Particle drift
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, _) => CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ParticlePainter(_particleController.value),
          ),
        ),

        // ---- SONAR 3D LETTERS ----
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                const letters = ['S', 'O', 'N', 'A', 'R'];

                // Each letter has slightly different timing offset
                final floatOffset = i * 0.10;
                final xOffsets = [2.0, 8.0, -4.0, 12.0, -6.0];
                final rotations = [3, -1.0, 2.2, -2.6, 2.4];

                return AnimatedBuilder(
                  animation: Listenable.merge([_pulseController, _floatController]),
                  builder: (context, child) {

                    // Staggered float per letter
                    final floatVal = sin(
                      (_floatController.value + floatOffset) * pi * 1.76,
                    );
                    final pulseVal = _pulseController.value;

                    return Transform.translate(
                      offset: Offset(
                        xOffsets[i] + floatVal * 1.9, // subtle horizontal sway
                        floatVal * 2.8, // subtle vertical float
                      ),
                      child: Transform.rotate(
                        angle: rotations[i] * pi / 180,
                        child: _GlassLetter(
                          letter: letters[i],
                          pulseValue: pulseVal,
                          index: i,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
        )
        ),
      ],
    );
  }
}

/// Single glass-styled letter with animated glow
class _GlassLetter extends StatelessWidget {
  final String letter;
  final double pulseValue;
  final int index;

  const _GlassLetter({
    required this.letter,
    required this.pulseValue,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    // Glow intensity pulsing subtly
    final glowOpacity = 0.7 + pulseValue * 0.25;
    final glowSpread = 10.0 + pulseValue * 12.0; //16.0 zu hell
    final glowBlur = 22.0 + pulseValue * 15.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow layer behind the letter
          Text(
            letter,
            style: TextStyle(
              height: 0.85,
              fontSize: 150,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(179, 0, 155, glowOpacity * 0.4),
              shadows: [
                Shadow(
                  color: Color.fromRGBO(91, 235, 177, glowOpacity * 0.346),
                  blurRadius: glowBlur,
                ),
                Shadow(
                  color: Color.fromRGBO(91, 235, 177, glowOpacity * 0.317),
                  blurRadius: glowSpread,
                ),
              ],
            ),
          ),
          // Specular highlight (top shine)
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.952,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightGreen.withValues(alpha: 0.48 + pulseValue * 0.1),
                    Colors.lightGreen.withValues(alpha: 0.0),
                  ],
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  letter,
                  style: const TextStyle(
                    height: 0.82,
                    fontSize: 174,
                    fontWeight: FontWeight.w700,
                    color: Colors.lightGreen,
                  ),
                ),
              ),
            ),
          ),
          // Main letter
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF080110),
                Color(0xFF210232),
                Color(0xFF370E47),
                Color(0xFF150D23),
                Color(0xDA005537),
              ],
              stops: [0.0, 0.2, 0.5, 0.78, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              letter,
              style: const TextStyle(
                height: 0.81,
                fontSize: 169,
                fontWeight: FontWeight.w900,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle floating particles
class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles;

  _ParticlePainter(this.progress)
      : _particles = _generateParticles();

  static List<_Particle> _generateParticles() {
    final rng = Random(167);
    return List.generate(30, (i) => _Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: 4.5 + rng.nextDouble() * 1.5,
      speed: 0.2 + rng.nextDouble() * 0.5,
      opacity: 0.02 + rng.nextDouble() * 0.18,
    ));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final x = p.x * size.width;
      // Slow upward drift with wrapping
      final y = ((p.y - progress * p.speed * 0.15) % 0.8) * size.height;

      // Gentle pulse per particle
      final pulse = sin(progress * pi * 2 * p.speed) * 0.5 + 0.5;
      final opacity = p.opacity * (1.1 + pulse * 0.6);

      final paint = Paint()
        ..color = Color.fromRGBO(81,232,166, opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.8);

      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  final double x, y, size, speed, opacity;
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}


// mein lila 179,0,155,
// mein grüne 81,232,166