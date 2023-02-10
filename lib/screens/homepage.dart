import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsapp/models/getapidata.dart';
import 'package:newsapp/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../components/search_results.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GetApiData>? filteredNewsList;
  List<Articles>? articles;
  @override
  void initState() {
    super.initState();
    _getNews();
  }

  void _getNews() async {
    String apikey = 'c2a97b1a87204eef8269ef4c8365ac66';
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=$apikey";
    var data = await http.get(Uri.parse(url));

    var jsonData = json.decode(data.body);
    
      setState(() {
        // newsList = jsonData['articles'];
        filteredNewsList = [jsonDecode(data.body)]
            .map((item) => GetApiData.fromJson(item))
            .toList()
            .cast<GetApiData>();
        articles = filteredNewsList![0].articles;
        //print(articles!.length);
      });
    

    // store data in local storage for offline access
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('news', data.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          iconSize: 30,
          padding: EdgeInsets.only(left: 15),
          icon: Icon(Icons.search),
          color: Colors.blue[700],
          tooltip: 'Search News',
          onPressed: () {
            showSearch(
                context: context, delegate: NewsSearchDelegate(articles));
          },
        ),
        title: GestureDetector(
          onTap: () => showSearch(
              context: context, delegate: NewsSearchDelegate(articles)),
          child: Text(
            'Search in feed',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        titleSpacing: 0.0,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                if (GoogleSignIn().currentUser != null)
                  await GoogleSignIn().signOut();
                else {
                  FirebaseAuth.instance.signOut();
                }
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
            color: Colors.blue[700],
          ),
        ],
      ),
      body: articles != null
          ? ListView.builder(
              itemCount: articles!.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                                '${articles![index].title ?? ''}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '${articles![index].description ?? 'No Description'}',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Published At: ${articles![index].publishedAt ?? 'null'}',
                                style: TextStyle(fontSize: 12.0),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Source: ${articles![index].source!.name ?? 'null'}',
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
                              image: NetworkImage(articles![index].urlToImage ??
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
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                  Text('Fetching Data'),
                ],
              ),
            ),
    );
  }
}
