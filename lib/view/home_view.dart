import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../api_key.dart';
import '../model/current_weather.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  var lat = 23.923456;
  var lon = 90.407608;
  bool isLoading = true;
  late CurrentWeather currentWeather;

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&exclude={part}&appid={API key}
  void getWeatherData() async {
    String url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$myApiKey';
    Response response = await get(Uri.parse(url));
    // print(response.statusCode);

    if(response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      // print(decodedResponse['name']);

      setState(() {
        currentWeather = CurrentWeather.fromJson(decodedResponse);
      });
      isLoading = false;
    }
    else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error fetching data, ${response.statusCode}'),
          backgroundColor: Colors.redAccent,
        ),);
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Weather'),),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade300,
            ]
          )
        ),
        child: Center(
          child: isLoading ? const CircularProgressIndicator(color: Colors.white,) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentWeather.name,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text('Updated: ${DateFormat('h:mma').format(DateTime.now())}'),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(
                      'https://openweathermap.org/img/wn/${currentWeather.weather[0].icon}@2x.png'
                  ),
                  Text('${currentWeather.main.temp}\u2103',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Column(
                    children: [
                      Text('max: ${currentWeather.main.tempMax}\u2103'),
                      Text('min: ${currentWeather.main.tempMin}\u2103'),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8,),
              Text(currentWeather.weather[0].main),
            ],
          ),
        ),
      ),
    );
  }
}
