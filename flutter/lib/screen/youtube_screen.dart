import 'package:assembly/component/custom_youtube_player.dart';
import 'package:assembly/model/video_model.dart';
import 'package:assembly/repository/youtube_repository.dart';
import 'package:flutter/material.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Youtube Player',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<VideoModel>>(
        future: YoutubeRepository.getVideos(), // 유튜브 영상을 가져온다
        builder: (context, snapshot) {
          // 에러가 있을 경우 에러 화면에 표시한다
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData) {
            // 로딩 중일 때 로딩 위젯을 보여준다
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // List<VideoModel>을 CustomYoutubePlayer로 매핑
          return ListView(
            // 아래로 당겨서 스크롤할 때 튕기는 애니메이션 추가
            physics: const BouncingScrollPhysics(),
            children: snapshot.data!
                .map((e) => CustomYoutubePlayer(
                      videoId: e.id,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
