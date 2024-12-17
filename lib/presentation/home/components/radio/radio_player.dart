import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RadioPlayer extends StatefulWidget {
  final String videoId;

  const RadioPlayer({required this.videoId, super.key});

  @override
  State<RadioPlayer> createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: false,
        mute: false,
        showFullscreenButton: false,
        loop: false,
      ),
    );
  }

  final _isMuted = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        controller: _controller,
        builder: (context, player) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: _controller.previousVideo,
              ),
              YoutubeValueBuilder(
                controller: _controller,
                builder: (context, value) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                          left: -1000,
                          top: -1000,
                          child: SizedBox(
                              width: 000001, height: 000001, child: player)),
                      IconButton(
                        icon: Icon(
                          value.playerState == PlayerState.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          value.playerState == PlayerState.playing
                              ? _controller.pauseVideo()
                              : _controller.playVideo();
                        },
                      ),
                    ],
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isMuted,
                builder: (context, isMuted, _) {
                  return IconButton(
                    icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                    onPressed: () {
                      _isMuted.value = !isMuted;
                      isMuted ? _controller.unMute() : _controller.mute();
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _controller.nextVideo,
              ),
            ],
          );
        });
  }
}
