import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_news/model/newsmodel.dart';

final newsProvider = FutureProvider((ref) => NewsProvider().getNews());
late List idList = [];
List<NewsModel> newsList = [];

class NewsProvider {
  Future<List<NewsModel>> getNews() async {
    try {
      final dio = Dio();

      final response = await dio.get(
          "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty");
      if (response.statusCode == 200) {
        idList = response.data;
        print(idList.length);
        for (int i = 0; i < 15; i++) {
          int id = idList[i];
          final news = await dio.get(
              "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty");
          Map<String, dynamic> map = news.data;
          final data = NewsModel.fromJson(map);
          newsList.add(data);
        }
      }
      return newsList;
    } catch (e) {
      throw e;
    }
  }
}
