import 'dart:math';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../helpers/utils.dart';
import 'components/radio/station.dart';

class HomeState {
  bool isLoading;
  String currentQuote;
  Station currentStation;
  YoutubePlayerController controller;

  HomeState({
    this.isLoading = true,
    required this.currentQuote,
    required this.currentStation,
    YoutubePlayerController? controller,
  }) : controller = controller ??
            YoutubePlayerController.fromVideoId(
              autoPlay: false,
              videoId: "jfKfPfyJRdk",
              params: const YoutubePlayerParams(
                showControls: false,
                mute: false,
                showFullscreenButton: false,
                loop: false,
              ),
            )
          ..loadPlaylist(
            list: Station.playListIds,
            startSeconds: 1,
            listType: ListType.playlist,
          );

  factory HomeState.empty() => HomeState(
        currentQuote: quotes[Random().nextInt(quotes.length)],
        currentStation: Station.stations
            .firstWhere((station) => station.id == "jfKfPfyJRdk")
            .copyWith(isPlaying: true),
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
