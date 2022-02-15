import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/searchpage.dart';
import 'package:hava_durumu/widgets/spinKit.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? temp;
  String sehir = 'London';
  var locationData;
  var woeid;
  var weather_state_name;
  var arkaPlan = 'c';
  late Position position;
  String userCountry = '';

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    await Geolocator.checkPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getPosition() async {
    print('position çağırıldı');
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print('$position  = position döndürüldü');
  }

  Future<void> getLocationData() async {
    if (userCountry == '') {
      locationData = await http.get(
          "https://www.metaweather.com/api/location/search/?lattlong=${position.latitude},${position.longitude}");
    } else {
      locationData = await http.get(
          "https://www.metaweather.com/api/location/search/?query=$userCountry");
    }

    print('location data : $locationData');
    var locationDataParsed = jsonDecode(utf8.decode(locationData.bodyBytes));
    woeid = locationDataParsed[0]['woeid'];
    print('woeid çağrıldı $woeid');

    sehir = locationDataParsed[0]['title'];
    print('şehir çağrıldı $sehir');
    weather_state_name = locationDataParsed[0]['weather_state_name'];
  }

  Future<void> getLocationTemperature() async {
    var response =
        await http.get('https://www.metaweather.com/api/location/$woeid/');
    var temperatureDataParsed = jsonDecode(response.body);
    setState(() {
      temp =
          temperatureDataParsed['consolidated_weather'][0]['the_temp'].round();
      print('Sıcaklık = $temp');
      arkaPlan = temperatureDataParsed['consolidated_weather'][0]
          ["weather_state_abbr"];
      print('hava kısaltması : ' + arkaPlan);
    });
  }

  void yardimciFonksiyon() async {
    await getPosition();
    await getLocationData();
    await getLocationTemperature();
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
          image: AssetImage("images/$arkaPlan.jpg"),
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
                          shadows: <Shadow>[
                            Shadow(
                                color: Colors.black38,
                                blurRadius: 5,
                                offset: Offset(-3, 3))
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: sehir == 'Ä°zmir'
                              ? Text(
                                  'İzmir',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color: Colors.black38,
                                            blurRadius: 5,
                                            offset: Offset(-3, 3))
                                      ]),
                                )
                              : Text(
                                  sehir.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color: Colors.black38,
                                            blurRadius: 5,
                                            offset: Offset(-3, 3))
                                      ]),
                                ),
                        ),
                        IconButton(
                          onPressed: () async {
                            userCountry = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                            yardimciFonksiyon();

                            setState(() {
                              sehir = sehir;

                              temp = null;
                            });
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
