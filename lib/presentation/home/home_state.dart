import 'dart:math';

import '../../helpers/utils.dart';
import 'components/header/background.dart';
import 'components/radio/station.dart';

class HomeState {
  bool isLoading;
  String currentQuote;
  Station? currentStation;
  List<Background> backgrounds;
  Background? currentBackground;

  HomeState({
    this.isLoading = true,
    required this.currentQuote,
    this.currentStation,
    required this.backgrounds,
    this.currentBackground,
  });

  factory HomeState.empty() => HomeState(
        currentQuote: quotes[Random().nextInt(quotes.length)],
        backgrounds: Background.backgrounds,
      );

  copyWith({
    bool? isLoading,
    String? currentQuote,
    Station? currentStation,
    List<Background>? seasons,
    Background? currentBackground,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        currentQuote: currentQuote ?? this.currentQuote,
        currentStation: currentStation ?? this.currentStation,
        backgrounds: seasons ?? this.backgrounds,
        currentBackground: currentBackground ?? this.currentBackground,
      );
}
