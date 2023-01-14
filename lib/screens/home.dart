import 'package:flutter/material.dart';
import 'package:flutter_news/components/custom_list_tile.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/services/api_service.dart';
import 'package:flutter_news/utils/settings_data.dart';
import 'package:provider/provider.dart';

enum ArticleFetchingState {
  initial,
  loading,
  loaded,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];
  int selectedCategory = 0;
  List<Article> articles = [];
  ArticleFetchingState state = ArticleFetchingState.initial;
  late String endpoint;
  ApiService client = ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeSettings settings = Provider.of<ThemeSettings>(context);
    endpoint =
        "https://newsapi.org/v2/top-headlines?${settings.country == "all" ? "" : "country=${settings.country}&"}apiKey=7efe0b249f6a4bfdb673e3ecc3f9524e&pageSize=${settings.page}&category=${_categories[selectedCategory]}";
    return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedCategory == index
                            ? Colors.blue
                            : Colors.transparent),
                    child: TextButton(
                      onPressed: (() async {
                        state = ArticleFetchingState.loading;
                        setState(() {});
                        selectedCategory = index;
                        endpoint =
                            "https://newsapi.org/v2/top-headlines?${settings.country == "all" ? "" : "country=${settings.country}&"}apiKey=7efe0b249f6a4bfdb673e3ecc3f9524e&pageSize=100&category=${_categories[selectedCategory]}";

                        articles = await client.getArticles(endpoint: endpoint);
                        state = ArticleFetchingState.loaded;
                        setState(() {});
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                              color: selectedCategory == index
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: client.getArticles(endpoint: endpoint),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.hasData) {
                    if (state == ArticleFetchingState.initial) {
                      articles = snapshot.data!;
                      state = ArticleFetchingState.loaded;
                    }
                    if (state == ArticleFetchingState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return customListTile(articles[index], context);
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            state = ArticleFetchingState.loading;
            setState(() {});
            articles = await client.getArticles(
                endpoint: endpoint, forceRefresh: true);
            state = ArticleFetchingState.loaded;
            setState(() {});
          },
          child: const Icon(Icons.refresh),
        ));
  }
}
