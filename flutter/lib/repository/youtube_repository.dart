import 'dart:convert';

import 'package:assembly/const/api.dart';
import 'package:assembly/model/video_model.dart';
import 'package:dio/dio.dart';

class YoutubeRepository {
  static Future<List<VideoModel>> getVideos() async {
    try {
      final resp = await Dio().get(
        YOUTUBE_API_BASE_URL,
        queryParameters: {
          'key': API_KEY,
          'channelId': CF_CHANNEL_ID,
          'part': 'snippet',
          'maxResults': 10,
          'type': 'video',
          'order': 'date',
        },
      );

      print('Response: ${resp.data}'); // 응답 데이터 출력

      if (resp.statusCode == 200) {
        final items = List<Map<String, dynamic>>.from(resp.data['items']);
        
        return items.map((item) => VideoModel(
          id: item['id']['videoId'],
          title: item['snippet']['title'],
          thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
          author: item['snippet']['channelTitle'],
        )).toList();
      }

      throw Exception('Failed to load videos: ${resp.statusCode}');
    } on DioException catch (e) {
      print('Error: ${e.response?.data}'); // DioException의 응답 데이터 출력
      throw Exception('YouTube API Error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e'); // 기타 예외 출력
      throw Exception('Failed to load videos: $e');
    }
  }
}
