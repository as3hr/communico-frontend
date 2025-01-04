import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageHelper {
  static final Map<String, ui.Image> _imageCache = {};

  static bool isImageLoaded(String imagePath) {
    return _imageCache.containsKey(imagePath);
  }

  static Future<ui.Image?> loadAssetImage(String imagePath) async {
    if (_imageCache.containsKey(imagePath)) {
      return _imageCache[imagePath];
    }

    try {
      const config = ImageConfiguration.empty;
      final key = await AssetImage(imagePath).obtainKey(config);

      final completer = Completer<ui.Image>();

      final data = await key.bundle.load(key.name);
      final buffer = await ImmutableBuffer.fromUint8List(
        data.buffer.asUint8List(),
      );

      final imageStreamCompleter = MultiFrameImageStreamCompleter(
        codec: PaintingBinding.instance.instantiateImageCodecWithSize(
          buffer,
          getTargetSize: (_, __) {
            return ui.TargetImageSize(
              height: config.size?.height.toInt(),
              width: config.size?.width.toInt(),
            );
          },
        ),
        scale: key.scale,
        informationCollector: () sync* {
          yield ErrorDescription('Image provider: AssetImage(${key.name})');
        },
      );

      final listener = ImageStreamListener(
        (imageInfo, synchronousCall) {
          _imageCache[imagePath] = imageInfo.image;
          if (!completer.isCompleted) completer.complete(imageInfo.image);
        },
        onError: (exception, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(exception, stackTrace);
          }
        },
      );

      imageStreamCompleter.addListener(listener);

      return await completer.future;
    } catch (e) {
      debugPrint('Error loading asset image: $e');
      return null;
    }
  }

  static void clearCache() {
    _imageCache.clear();
  }

  static void removeFromCache(String imagePath) {
    _imageCache.remove(imagePath);
  }
}
