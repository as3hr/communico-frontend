import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    final isImageLoaded = ValueNotifier<bool>(false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image(
            image: AssetImage(image),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                Future.microtask(() => isImageLoaded.value = true);
                return child;
              }
              return const SizedBox.expand();
            },
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: frame == null ? const SizedBox.shrink() : child,
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isImageLoaded,
            builder: (context, loaded, child) {
              if (loaded) return const SizedBox.shrink();
              return Center(
                child: SizedBox(
                  width: 250.0,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 70.0,
                      fontFamily: 'Montserrat',
                    ),
                    child: AnimatedTextKit(
                      repeatForever: false,
                      isRepeatingAnimation: false,
                      pause: const Duration(milliseconds: 800),
                      totalRepeatCount: 1,
                      onFinished: () {
                        isImageLoaded.value = true;
                      },
                      animatedTexts: [
                        FadeAnimatedText(
                          'Applying your background, this may take some time...',
                          duration: const Duration(seconds: 10),
                          textAlign: TextAlign.center,
                          textStyle: Styles.boldStyle(
                            fontSize: 15,
                            color: context.colorScheme.onPrimary,
                            family: FontFamily.montserrat,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
