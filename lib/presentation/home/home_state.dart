import 'dart:math';

import '../../helpers/utils.dart';
import 'components/radio/station.dart';

class HomeState {
  bool isLoading;
  String currentQuote;
  Station? currentStation;

  HomeState({
    this.isLoading = true,
    required this.currentQuote,
    this.currentStation,
  });

  factory HomeState.empty() => HomeState(
        currentQuote: quotes[Random().nextInt(quotes.length)],
      );

  copyWith({
    bool? isLoading,
    String? currentQuote,
    Station? currentStation,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        currentQuote: currentQuote ?? this.currentQuote,
        currentStation: currentStation ?? this.currentStation,
      );
}
