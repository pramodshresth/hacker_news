import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_news/model/newsmodel.dart';
import 'package:hacker_news/provider/commentprovider.dart';

class CommentScreen extends StatelessWidget {
  final NewsModel news;
  CommentScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment"),
        actions: [
          Icon(Icons.search),
          SizedBox(
            width: 6,
          ),
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () {
                  ref.refresh(commentProvider);
                },
                icon: Icon(Icons.refresh),
              );
            },
          ),
          SizedBox(
            width: 6,
          ),
          Icon(Icons.bookmark_add_outlined),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(news.title!),
              subtitle: Text(news.url!),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Comment Section",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.80,
            child: Consumer(
              builder: (context, ref, child) {
                final comment = ref.watch(commentProvider);
                return ListView.builder(
                  itemCount: comment.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(comment[index].by == null
                          ? "Unnknown User"
                          : comment[index].by!),
                      subtitle: Text(comment[index].text == null
                          ? "Nothing"
                          : comment[index].text!),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
