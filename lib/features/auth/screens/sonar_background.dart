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
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    // Gentle float movement
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    )..repeat(reverse: true);

    // Particle drift
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
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

        // SONAR letters
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                const letters = ['S', 'O', 'N', 'A', 'R'];
                // Each letter has slightly different timing offset
                final floatOffset = i * 0.10;
                final xOffsets = [2.0, 15.0, -4.0, 21.0, -8.0];
                final rotations = [3.5, -1.0, 2.5, -4.0, 3.2];

                return AnimatedBuilder(
                  animation: Listenable.merge([_pulseController, _floatController]),
                  builder: (context, child) {
                    // Staggered float per letter
                    final floatVal = sin(
                      (_floatController.value + floatOffset) * pi * 2,
                    );
                    final pulseVal = _pulseController.value;

                    return Transform.translate(
                      offset: Offset(
                        xOffsets[i] + floatVal * 1.7, // subtle horizontal sway
                        floatVal * 2.5, // subtle vertical float
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
    final glowSpread = 20.0 + pulseValue * 12.0;
    final glowBlur = 28.0 + pulseValue * 15.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow layer behind the letter
          Text(
            letter,
            style: TextStyle(
              fontSize: 160,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(71, 235, 127, glowOpacity),
              shadows: [
                Shadow(
                  color: Color.fromRGBO(91, 235, 177, glowOpacity * 0.6),
                  blurRadius: glowBlur,
                ),
                Shadow(
                  color: Color.fromRGBO(91, 235, 177, glowOpacity * 0.4),
                  blurRadius: glowSpread,
                ),
              ],
            ),
          ),

          // Main glass letter
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF080110),
                Color(0xFF210232),
                Color(0xFF370E47),
                Color(0xFF150D23),
                Color(0xFF007B5E),
              ],
              stops: [0.0, 0.2, 0.5, 0.78, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 170,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),

          // Specular highlight (top shine)
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white10.withValues(alpha: 0.35 + pulseValue * 0.1),
                    Colors.white10.withValues(alpha: 0.0),
                  ],
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 162,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurple,
                  ),
                ),
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
    final rng = Random(42);
    return List.generate(30, (i) => _Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: 1.5 + rng.nextDouble() * 3.5,
      speed: 0.3 + rng.nextDouble() * 0.7,
      opacity: 0.08 + rng.nextDouble() * 0.18,
    ));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final x = p.x * size.width;
      // Slow upward drift with wrapping
      final y = ((p.y - progress * p.speed * 0.15) % 1.0) * size.height;

      // Gentle pulse per particle
      final pulse = sin(progress * pi * 2 * p.speed) * 0.5 + 0.5;
      final opacity = p.opacity * (0.6 + pulse * 0.4);

      final paint = Paint()
        ..color = Color.fromRGBO(180, 120, 255, opacity)
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
