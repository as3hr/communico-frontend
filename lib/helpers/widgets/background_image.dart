import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'shimmer_effect.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.dst,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => const ShimmerEffect(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    // ClipRRect(
    //   borderRadius: BorderRadius.circular(16),
    //   child: Stack(
    //     children: [
    //       Image(
    //         image: NetworkImage(image),
    //         fit: BoxFit.cover,
    //         height: double.infinity,
    //         width: double.infinity,
    //         loadingBuilder: (context, child, loadingProgress) {
    //           if (loadingProgress == null) {
    //             return child;
    //           }
    //           return const SizedBox.expand();
    //         },
    //         frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
    //           if (wasSynchronouslyLoaded) return child;
    //           return AnimatedSwitcher(
    //             duration: const Duration(milliseconds: 300),
    //             child: frame == null ? const SizedBox.shrink() : child,
    //           );
    //         },
    //       ),
    //      ],
    //   ),
    // );
  }
}
