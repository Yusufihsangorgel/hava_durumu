import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:hava_durumu/pages/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Metods extends StatefulWidget {
  int? temp;
  String sehir = '';
  var arkaPlan = '';
  String userCountry = '';
  Metods(
      {Key? key,
      required this.temp,
      required this.sehir,
      required this.arkaPlan,
      required this.userCountry})
      : super(key: key);

  @override
  State<Metods> createState() => _MetodsState();
}

class _MetodsState extends State<Metods> {
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
      print('burda takıldı yusuf');
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getPosition() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      print('hata : $e');
    }
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

  void konum() async {
    await determinePosition();
  }

  void yardimciFonksiyon() async {
    await getPosition();
    await getLocationData();
    await getLocationTemperature();
  }

  void initState() {
    konum();
    yardimciFonksiyon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}
