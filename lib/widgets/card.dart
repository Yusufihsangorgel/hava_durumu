import 'package:flutter/material.dart';
import 'package:hava_durumu/widgets/sizedbox.dart';

class MyCard extends StatelessWidget {
  late String transportImage;
  late String degree;
  late String date;
  MyCard(
      {Key? key,
      required this.transportImage,
      required this.degree,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];
    var weekDay = weekDays[DateTime.parse(date).weekday - 1];
    return Card(
      elevation: 2,
      color: Colors.transparent,
      child: Container(
        height: 120,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.metaweather.com/static/img/weather/png/${transportImage}.png',
              height: 50,
              width: 50,
            ),
            MySize(size: 20),
            Text('$degree ° C'),
            MySize(size: 20),
            Text('$weekDay')
          ],
        ),
      ),
    );
  }
}
