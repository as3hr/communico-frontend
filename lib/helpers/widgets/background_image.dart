import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image(
          image: AssetImage(image),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 70.0,
                  fontFamily: 'Canterbury',
                ),
                child: AnimatedTextKit(
                  pause: const Duration(seconds: 3),
                  animatedTexts: [
                    ScaleAnimatedText('Applying your background...'),
                    ScaleAnimatedText('building it up...'),
                    ScaleAnimatedText('almost done...'),
                  ],
                ),
              ),
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: frame == null ? const SizedBox.shrink() : child,
            );
          }),
    );
  }
}
