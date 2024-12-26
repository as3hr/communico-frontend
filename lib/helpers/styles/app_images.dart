import 'package:flutter/material.dart';

class AppImages {
  static const _baseDir = "assets/";
  static const aiGif = "$_baseDir/ai.gif";
  static const snowFallGif = "$_baseDir/snowfall.gif";
  static const autumn = "$_baseDir/autumn.gif";
  static const bus = "$_baseDir/bus.gif";
  static const rain = "$_baseDir/rain.gif";
  static const night = "$_baseDir/night.gif";

  static final images = [snowFallGif, autumn, bus, rain, night];

  static Future<void> preCacheImages(BuildContext context) async {
    await Future.wait(
      images.map(
        (image) => precacheImage(AssetImage(image), context),
      ),
    );
  }
}
