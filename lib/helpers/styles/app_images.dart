import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppImages {
  static final _baseDir = dotenv.env['STORAGE_PATH']!.toString();
  static final autumn = "$_baseDir/autumn.gif";
  static final scenery = "$_baseDir/scenery.gif";
  static final rain = "$_baseDir/rain.gif";
  static final night = "$_baseDir/night.gif";
  static final sunset = "$_baseDir/sunset.gif";
}
