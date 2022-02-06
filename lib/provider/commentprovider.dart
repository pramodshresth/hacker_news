import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_news/model/comment.dart';

final commentCall = Provider((ref) => NewsProvider());

final commentProvider = Provider((ref) => commentList);

List<Comment> commentList = [];

class NewsProvider {
  Future<void> getComment({List? kids}) async {
    try {
      final dio = Dio();

      if (kids != null) {
        for (int i = 0; i < kids.length; i++) {
          int id = await kids[i];

          final news = await dio.get(
              "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty");
          Map<String, dynamic> map = await news.data;
          final data = await Comment.fromJson(map);
          commentList.add(data);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
