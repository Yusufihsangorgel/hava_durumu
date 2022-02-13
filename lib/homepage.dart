import 'package:flutter/material.dart';

import 'package:hava_durumu/searchpage.dart';
import 'package:hava_durumu/widgets/spinKit.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? temp;
  var sehir;
  var locationData;
  var woeid;
  var weather_state_name;
  var weather_state_abbr;

  Future<void> getLocationData() async {
    locationData = await http
        .get("https://www.metaweather.com/api/location/search/?query=london");
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]['woeid'];
    print('woeid = $woeid');
    sehir = locationDataParsed[0]['title'];
    weather_state_name = locationDataParsed[0]['weather_state_name'];
    weather_state_abbr = locationDataParsed[0]['weather_state_abbr'];
  }

  Future<void> getLocationTemperature() async {
    var response =
        await http.get('https://www.metaweather.com/api/location/$woeid/');
    var temperatureDataParsed = jsonDecode(response.body);
    setState(() {
      temp =
          temperatureDataParsed['consolidated_weather'][0]['the_temp'].round();
      print('Sıcaklık = $temp');
    });
  }

  void yardimciFonksiyon() async {
    await getLocationData();
    getLocationTemperature();
  }

  void initState() {
    yardimciFonksiyon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("images/c.jpg"),
        ),
      ),
      child: temp == null
          ? Center(child: (mySpinKit.spinkit))
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      temp.toString() + "° C",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            sehir.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.search,
                            size: 30,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
