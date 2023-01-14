import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/components/custom_list_tile.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/screens/home.dart';
import 'package:flutter_news/services/api_service.dart';
import 'package:flutter_news/utils/settings_data.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchText = "";
  ArticleFetchingState state = ArticleFetchingState.initial;
  List<Article> articles = [];
  ApiService client = ApiService();

  void onCompleted(String value, ThemeSettings settings) async {
    setState(() {
      state = ArticleFetchingState.loading;
    });
    articles = await client.getArticles(
      endpoint:
          "https://newsapi.org/v2/top-headlines?${settings.country == "all" ? "" : "country=${settings.country}&"}apiKey=7efe0b249f6a4bfdb673e3ecc3f9524e&pageSize=100&q=$value",
    );
    setState(() {
      state = ArticleFetchingState.loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeSettings settings = Provider.of<ThemeSettings>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(children: const [
                Icon(
                  FluentSystemIcons.ic_fluent_search_regular,
                  size: 30,
                ),
                SizedBox(width: 15),
                Text("Search",
                    style:
                        TextStyle(fontSize: 35, fontWeight: FontWeight.w500)),
              ])),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 17),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: const OutlineInputBorder().copyWith(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      onCompleted(_searchText, settings);
                    },
                    icon: const Icon(
                      FluentSystemIcons.ic_fluent_search_regular,
                    )),
              ),
              cursorHeight: 20,
              cursorColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              onFieldSubmitted: (value) {
                onCompleted(value, settings);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (state == ArticleFetchingState.initial) {
                  return const Center(
                    child: Text("Search for something"),
                  );
                } else if (state == ArticleFetchingState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == ArticleFetchingState.loaded) {
                  if (articles.isEmpty) {
                    return const Center(
                      child: Text("No Results"),
                    );
                  }
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return customListTile(articles[index], context);
                    },
                  );
                } else {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
