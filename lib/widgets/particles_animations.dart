import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class Particles extends StatefulWidget {
  final int numberOfParticles;
  final Color color;

  const Particles(
    this.numberOfParticles, {
    this.color = Colors.white,
  });

  @override
  ParticlesState createState() => ParticlesState();
}

class ParticlesState extends State<Particles> {
  final random = Random();
  final startTime = DateTime.now();
  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimationBuilder<int>(
      duration: const Duration(seconds: 1),
      tween: ConstantTween(1),
      builder: (context, animation, child) {
        final time = DateTime.now().difference(startTime);
        _simulateParticles(time);
        return CustomPaint(
          painter: ParticlePainter(particles, time, widget.color),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    for (var particle in particles) {
      particle.maintainRestart(time);
    }
  }
}

class ParticleModel {
  Animatable tween;
  double size;
  AnimationProgress animationProgress;
  Random random;

  ParticleModel(this.random) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 3000 + random.nextInt(6000));

    tween = MovieTween()
      ..tween(
        MyAniPropsEnum.X,
        Tween(
          begin: startPosition.dx,
          end: endPosition.dx,
        ),
        duration: duration,
        curve: Curves.easeInOutSine,
      )
      ..tween(
        MyAniPropsEnum.Y,
        Tween(
          begin: startPosition.dy,
          end: endPosition.dy,
        ),
        duration: duration,
        curve: Curves.easeIn,
      );
    animationProgress = AnimationProgress(
      duration: duration,
      startTime: time,
    );
    size = 0.2 + random.nextDouble() * 0.4;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;
  Color color;

  ParticlePainter(
    this.particles,
    this.time,
    this.color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withAlpha(150);

    for (var particle in particles) {
      var progress = particle.animationProgress.progress(time);
      final Movie animation = particle.tween.transform(progress);
      final position = Offset(
        animation.get(MyAniPropsEnum.X) * size.width,
        animation.get(MyAniPropsEnum.Y) * size.height,
      );
      canvas.drawCircle(
        position,
        size.width * 0.2 * particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(
        MyAniPropsEnum.COLOR1,
        ColorTween(
          begin: const Color(0xff8a113a),
          end: Colors.lightBlue.shade900,
        ),
      )
      ..tween(
        MyAniPropsEnum.COLOR2,
        ColorTween(
          begin: const Color(0xff440216),
          end: Colors.blue.shade600,
        ),
      );

    return CustomAnimationBuilder<dynamic>(
      control: Control.mirror,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                animation.get(MyAniPropsEnum.COLOR1),
                animation.get(MyAniPropsEnum.COLOR2),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum MyAniPropsEnum {
  X,
  Y,
  COLOR1,
  COLOR2,
}

class AnimationProgress {
  final Duration duration;
  final Duration startTime;

  const AnimationProgress({
    this.duration,
    this.startTime,
  });

  double progress(Duration time) => max(
        0.0,
        min(
          (time - startTime).inMilliseconds / duration.inMilliseconds,
          1.0,
        ),
      );
}
