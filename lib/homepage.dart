import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'apimodel.dart';


class MyNewsApp extends StatefulWidget {
  @override
  _MyNewsAppState createState() => _MyNewsAppState();
}

class _MyNewsAppState extends State<MyNewsApp> {


  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  void makeRequest() async {
    var url = Uri.parse('https://newsapi.org/v2/everything?q=apple&from=2023-04-17&to=2023-04-17&sortBy=popularity&apiKey=d18c18a219224ef78fddfefb842b1297');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      Newspaper newspaper = Newspaper.fromJson(jsonData);
      setState(() {
        articles = newspaper.articles;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My News App'),
      ),
      body:  ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(articles[index].urlToImage??''))),
                  ),
                ],
              ),
              Text(articles[index].title
                ,overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(fontSize: 30,fontWeight: FontWeight.bold),
              ),
              Text(articles[index].description ?? '',overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ],

          );
        },
      ),
    );
  }
}
