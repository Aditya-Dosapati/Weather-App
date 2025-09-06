import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = 'New Delhi';
  late Future<Map<String, dynamic>> weatherData;
  late TextEditingController _controller;

  Future<Map<String, dynamic>> getCurrWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherapiKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (int.parse(data['cod']) != 200) {
        throw 'An error occurred: ${data['message']}';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weatherData = getCurrWeather();
    _controller = TextEditingController(text: cityName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherData = getCurrWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
        backgroundColor: Color.fromARGB(96, 9, 105, 196),
      ),
      backgroundColor: const Color.fromARGB(66, 18, 46, 170),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Always show the search bar
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter City Name',
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                setState(() {
                  cityName = value;
                  weatherData = getCurrWeather();
                  _controller.text = cityName;
                });
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Forecast of $cityName",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Main weather card
            Expanded(
              child: FutureBuilder(
                future: weatherData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'City not found. Please enter a valid city name.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                    // Show nothing, but search bar remains visible
                    return Container();
                  }

                  final data = snapshot.data!;
                  final currTemp = (data['list'][0]['main']['temp']) - 273.15;
                  final currSky = data['list'][0]['weather'][0]['main'];
                  final currHumidity = data['list'][0]['main']['humidity'];
                  final currWindSpeed = data['list'][0]['wind']['speed'];
                  final currPressure = data['list'][0]['main']['pressure'];
                  final currVisibility =
                      (data['list'][0]['visibility'] / 1000).toString();

                  // Icon logic for today's forecast
                  final now = DateTime.now();
                  final hour = now.hour;
                  IconData mainIcon;
                  Color mainIconColor;
                  if (currSky == 'Clear') {
                    if (hour >= 6 && hour < 18) {
                      mainIcon = Icons.wb_sunny; // Sun for day
                      mainIconColor = Colors.yellow;
                    } else {
                      mainIcon = Icons.nightlight_round; // Moon for night
                      mainIconColor = Colors.blueGrey;
                    }
                  } else if (currSky == 'Clouds' || currSky == 'Rain') {
                    mainIcon = Icons.cloud;
                    mainIconColor = Colors.grey;
                  } else {
                    mainIcon = Icons.wb_sunny;
                    mainIconColor = Colors.yellow;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: const Color.fromARGB(103, 13, 125, 190),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        currTemp.toStringAsFixed(2) + '°C',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Icon(
                                        mainIcon,
                                        size: 56,
                                        color: mainIconColor,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        currSky,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Hourly Weather Forecast',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            itemCount: 9,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final hourlyforecast = data['list'][index + 1];
                              final hourlysky =
                                  hourlyforecast['weather'][0]['main'];
                              final hourlytemp =
                                  (hourlyforecast['main']['temp'] - 273.15)
                                      .toStringAsFixed(1);
                              final time = DateTime.parse(
                                hourlyforecast['dt_txt'],
                              );
                              final hour = time.hour;
                              IconData icon;
                              Color iconColor;
                              if (hourlysky == 'Clear') {
                                if (hour >= 6 && hour < 18) {
                                  icon = Icons.wb_sunny; // Sun for day
                                  iconColor = Colors.yellow;
                                } else {
                                  icon =
                                      Icons.nightlight_round; // Moon for night
                                  iconColor = Colors.blueGrey;
                                }
                              } else if (hourlysky == 'Clouds' ||
                                  hourlysky == 'Rain') {
                                icon = Icons.cloud;
                                iconColor = Colors.grey;
                              } else {
                                icon = Icons.wb_sunny;
                                iconColor = Colors.yellow;
                              }
                              return HourlyWeather(
                                time: DateFormat('E, M/d, ha').format(time),
                                temperature: hourlytemp,
                                color: iconColor,
                                icon: icon,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Additional Information',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInfoItem(
                              icon: Icons.water_drop,
                              color: Colors.blue,
                              label: 'Humidity',
                              value: '$currHumidity %',
                            ),
                            AdditionalInfoItem(
                              icon: Icons.air,
                              color: Colors.grey,
                              label: 'Wind Speed',
                              value: '$currWindSpeed km/h',
                            ),
                            AdditionalInfoItem(
                              icon: Icons.beach_access,
                              color: Colors.red,
                              label: 'Pressure',
                              value: '$currPressure hPa',
                            ),
                            AdditionalInfoItem(
                              icon: Icons.remove_red_eye,
                              color: Colors.orange,
                              label: 'Visibility',
                              value: '$currVisibility km',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
