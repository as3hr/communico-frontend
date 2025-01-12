import '../image_helper.dart';

class AppImages {
  static const _baseDir =
      "https://as3hr.github.io/Flutter-Notification-Repository";
  static const autumn = "$_baseDir/autumn.gif";
  static const scenery = "$_baseDir/scenery.gif";
  static const rain = "$_baseDir/rain.gif";
  static const mountainous = "$_baseDir/mountainous.gif";
  static const sunset = "$_baseDir/sunset.gif";
  static const cloud = "assets/cloud.png";

  static Future<void> preloadImages() async {
    await NetworkImageHelper.preloadImages([
      autumn,
      scenery,
      rain,
      mountainous,
      sunset,
    ]);
  }
}
