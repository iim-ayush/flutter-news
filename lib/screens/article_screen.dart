import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/screens/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;
  final Image image;
  final WebViewController controller = WebViewController();
  ArticleScreen({super.key, required this.article, required this.image});

  void _launchUrl(Uri url, BuildContext context) async {
    controller.loadRequest(url);
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return AppWebView(
          url: url,
          title: article.title ?? "No Title",
          source: article.source?.name ?? "No Source");
    }));
  }

  @override
  Widget build(BuildContext context) {
    var url = Uri.parse(article.url);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            article.source?.name ?? 'No Source',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _launchUrl(url, context);
              },
              icon: const Icon(
                CupertinoIcons.globe,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            image,
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    article.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.description ?? 'No description',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _launchUrl(url, context);
                      },
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
