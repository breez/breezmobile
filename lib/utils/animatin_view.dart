import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VisualView extends StatelessWidget {
  const VisualView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var image = Image.asset(
      'src/images/text_logo.png',
      height: 64.0,
      gaplessPlayback: true,
    ).animate(adapter: ValueAdapter(0.5)).shimmer(
      colors: [
        const Color(0xFF100F0F),
        const Color(0xFF100F0F),
        const Color(0xFFFFFFFF),
        const Color(0xFF100F0F),
        const Color(0xFF100F0F),
        const Color(0xFF100F0F),
        const Color(0xFF100F0F),
      ],
    );

    return Padding(padding: const EdgeInsets.all(24), child: image);
  }
}
