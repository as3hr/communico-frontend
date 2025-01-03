import '../image_helper.dart';

class AppImages {
  static const _baseDir = "assets";
  static const autumn = "$_baseDir/autumn.gif";
  static const scenery = "$_baseDir/scenery.gif";
  static const rain = "$_baseDir/rain.gif";
  static const mountainous = "$_baseDir/mountainous.gif";
  static const sunset = "$_baseDir/sunset.gif";

  static Future<void> loadImage() async {
    if (!ImageHelper.isImageLoaded(sunset)) {
      ImageHelper.loadAssetImage(sunset);
    }
  }
}
