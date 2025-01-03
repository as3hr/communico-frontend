import '../image_helper.dart';

class AppImages {
  static const _baseDir = "assets";
  static const autumn = "$_baseDir/autumn.gif";
  static const scenery = "$_baseDir/scenery.gif";
  static const rain = "$_baseDir/rain.gif";
  static const night = "$_baseDir/night.gif";
  static const sunset = "$_baseDir/sunset.gif";

  static const images = [
    autumn,
    scenery,
    rain,
    night,
    sunset,
  ];

  static Future<void> loadImages() async {
    await Future.wait(
      // .where((image) => !ImageHelper.isImageLoaded(image))
      images.map((image) {
        return ImageHelper.loadAssetImage(image);
      }),
    );
  }
}
