import 'package:flutter/material.dart';

class AppImages {
  static const _baseDir = "assets/";
  static const autumn = "$_baseDir/autumn.gif";
  static const scenery = "$_baseDir/scenery.gif";
  static const rain = "$_baseDir/rain.gif";
  static const night = "$_baseDir/night.gif";
  static const sunset = "$_baseDir/sunset.gif";

  static final images = [autumn, scenery, rain, sunset, night];

  static Future<void> preCacheImages(BuildContext context) async {
    await Future.wait(
      images.map(
        (image) => precacheImage(AssetImage(image), context),
      ),
    );
  }
}
