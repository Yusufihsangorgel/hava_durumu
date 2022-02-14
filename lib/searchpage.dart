import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hava_durumu/homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String secilenSehir;
  final myController = TextEditingController();
  var response;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("images/search.jpg"),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  onChanged: (value) {
                    secilenSehir = value;
                    print('Seçilen Şehir = ' + secilenSehir);
                  },
                  decoration: InputDecoration(
                    hintText: "Şehir Seçiniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    response = await http.get(
                        'https://www.metaweather.com/api/location/search/?query=$secilenSehir');
                    jsonDecode(response.body).isEmpty
                        ? showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                  title: Text("Yanlış Şehir Seçimi"),
                                  content: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                SearchPage()),
                                          ),
                                        );
                                      },
                                      child: Text("Geri dön")));
                            })
                        : Navigator.pop(context, secilenSehir);
                  } else {
                    response = await http.get(
                        'https://www.metaweather.com/api/location/search/?query=$secilenSehir');
                    jsonDecode(response.body).isEmpty
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Yanlış Şehir Seçimi"),
                                  content: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                SearchPage()),
                                          ),
                                        );
                                      },
                                      child: Text("Geri dön")));
                            })
                        : Navigator.pop(context, secilenSehir);
                  }
                },
                child: Text(
                  'Onayla',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
