import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// 유튜브 재생기를 사용하기 위해 피키지를 불러온다
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// 유튜브 동영상 재생기가 될 위젯
class CustomYoutubePlayer extends StatefulWidget {
  // 상위 위젯에서 입력받을 동영상 정보
  final String videoId;

  const CustomYoutubePlayer({
    required this.videoId,
    super.key,
  });

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      // 컨트롤러를 선언한다
      initialVideoId: widget.videoId, // 처음 실행할 동영상의 ID
      flags: const YoutubePlayerFlags(
        autoPlay: false, // 자동 실행하지 않도록 한다
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      // 유튜브 재생기 렌더링
      controller: controller,
      showVideoProgressIndicator: true,
    );
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose(); // State 폐기 시에 컨트롤러도 폐기한다
  }
}
