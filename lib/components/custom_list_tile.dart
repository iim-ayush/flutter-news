import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/models/article.dart';

import '../screens/article_screen.dart';

Widget customListTile(Article article, BuildContext context) {
  var image = Image.network(
    article.urlToImage ??
        'https://cdn.pixabay.com/photo/2015/02/15/09/33/news-636978_960_720.jpg',
    errorBuilder: (context, error, stackTrace) {
      return Image.network(
          'https://cdn.pixabay.com/photo/2015/02/15/09/33/news-636978_960_720.jpg');
    },
  );
  return Container(
    margin: const EdgeInsets.all(12),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: ListTile(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.source?.name ?? 'Random Source',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              article.title ?? 'Random Title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      trailing: image,
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ArticleScreen(
              article: article,
              image: image,
            ),
          ),
        );
      },
    ),
  );
}
