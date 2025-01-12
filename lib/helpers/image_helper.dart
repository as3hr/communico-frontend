import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkImageHelper {
  static final Map<String, ui.Image> _imageCache = {};

  static bool isImageLoaded(String imageUrl) {
    return _imageCache.containsKey(imageUrl);
  }

  static Future<ui.Image?> loadNetworkImage(String imageUrl) async {
    if (_imageCache.containsKey(imageUrl)) {
      return _imageCache[imageUrl];
    }

    try {
      final completer = Completer<ui.Image>();

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load image from network');
      }

      final codec = await ui.instantiateImageCodec(response.bodyBytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      _imageCache[imageUrl] = image;
      completer.complete(image);

      return image;
    } catch (e) {
      debugPrint('Error loading network image: $e');
      return null;
    }
  }

  static void clearCache() {
    _imageCache.clear();
  }

  static void removeFromCache(String imageUrl) {
    _imageCache.remove(imageUrl);
  }

  static Future<List<ui.Image?>> preloadImages(List<String> imageUrls) async {
    final futures = imageUrls.map((url) => loadNetworkImage(url));
    return await Future.wait(futures);
  }
}
