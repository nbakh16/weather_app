import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../api_key.dart';
import '../model/current_weather.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  var lat = 23.811056;
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
    String url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$myApiKey';
    Response response = await get(Uri.parse(url));
    print(response.statusCode);

    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    print(decodedResponse['name']);

    currentWeather = CurrentWeather.fromJson(decodedResponse);
    print(currentWeather.wind.speed);

    isLoading = false;
    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Flutter Weather'),),
      body: Center(
        child: isLoading ? CircularProgressIndicator() :
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentWeather.name),
            Text(currentWeather.main.temp.toString()),
            Text(currentWeather.weather[0].main),
          ],
        ),
      ),
    );
  }
}
