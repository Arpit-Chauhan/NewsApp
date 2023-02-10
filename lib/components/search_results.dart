import 'package:flutter/material.dart';

import '../models/getapidata.dart';

class NewsSearchDelegate extends SearchDelegate {
  List<Articles>? searchedArticles;
  NewsSearchDelegate(this.searchedArticles);
  List<Articles>? articles;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          articles = searchedArticles;
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    articles = searchedArticles!
        .where(
            (news) => news.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Future.delayed(Duration.zero, () {
    //   _homePageState.setState(() {
    //     _homePageState.articles = _homePageState.articles!
    //         .where((news) =>
    //             news.title!.toLowerCase().contains(query.toLowerCase()))
    //         .toList();
    //   });
    // });

    print(articles!.length);

    return articles!.length != 0
        ? ListView.builder(
            itemCount: articles!.length,
            itemBuilder: (context, idx) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${articles![idx].title ?? ''}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              '${articles![idx].description ?? 'No Description'}',
                              style: TextStyle(
                                color: Colors.blue[700],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Published At: ${articles![idx].publishedAt ?? 'null'}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Source: ${articles![idx].source!.name ?? 'null'}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(articles![idx].urlToImage ??
                                'https://w7.pngwing.com/pngs/422/126/png-transparent-newspaper-computer-icons-symbol-news-icon-text-logo-news.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : Container(
            child: Center(child: Text('No results found')),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
