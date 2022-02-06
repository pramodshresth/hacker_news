import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hacker_news/provider/commentprovider.dart';
import 'package:hacker_news/provider/newsprovider.dart';
import 'package:hacker_news/screen/comment.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text("Hacker News"),
          actions: [
            Icon(Icons.search),
            SizedBox(
              width: 6,
            ),
            Consumer(
              builder: (context, ref, child) {
                return IconButton(
                  onPressed: () {
                    ref.refresh(newsProvider);
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
        body: Consumer(
          builder: (context, ref, child) {
            final data = ref.watch(newsProvider);
            return data.when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(data[index].title!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data[index].url == null
                                ? "No Url"
                                : data[index].url!),
                            data[index].kids?.length == null
                                ? Text("")
                                : TextButton(
                                    onPressed: () async {
                                      await ref
                                          .read(commentCall)
                                          .getComment(kids: data[index].kids);
                                      Get.to(
                                          () =>
                                              CommentScreen(news: data[index]),
                                          transition: Transition.downToUp);
                                    },
                                    child: Text("View Comment ->"),
                                  ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Icon(Icons.comment),
                            Text(data[index].kids?.length == null
                                ? '0'
                                : data[index].kids!.length.toString()),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              error: (err, stack) => Center(child: Text("$err")),
              loading: () => Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
