import 'package:communico_frontend/helpers/styles/app_images.dart';

class Background {
  String title;
  String image;
  Background({required this.image, required this.title});

  static final backgrounds = [
    Background(image: AppImages.snowFallGif, title: "SnowFall"),
    Background(image: AppImages.bus, title: "Bus"),
    Background(image: AppImages.rain, title: "Rain"),
    Background(image: AppImages.autumn, title: "Autumn"),
  ];
}
