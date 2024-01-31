import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/provider/theme_changer_provider.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherServices = WeatherServices('f5783e1fee68d6228723ecc46804ee40');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherServices.getCurrentCity();

    try {
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/weather-partly cloudy.json';
      case 'clouds night':
        return 'assets/cloudy(night).json';
      case 'smoke':
        return 'assets/weather-day smoke.json';
      case 'storm':
        return 'assets/storm.json';
      case 'thunder':
        return 'assets/weather-thunder.json';
      case 'windy':
        return 'assets/weather-windy.json';
      case 'mist':
        return 'assets/mist.json';
      case 'clear':
        return "assets/weather-sunny.json";
      case 'rainy':
        return "assets/rainy.json";
      case 'rainy night':
        return "assets/rainy(night).json";
      case 'shower':
        return "assets/weather-partly shower.json";
      default:
        return "assets/weather-sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Switch(
                        value: themeChanger.themeMode == ThemeMode.dark,
                        onChanged: (bool newValue) {
                          themeChanger.setTheme(
                              newValue ? ThemeMode.dark : ThemeMode.light);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.020),
                  Text(
                    _weather?.cityName ?? 'Loading city...',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition),
                    width: media.width * 0.6,
                    height: media.height * 0.3,
                  ),
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _weather?.mainCondition ?? "",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(children: [
                            Row(
                              children: [
                                _buildWeatherDetail(
                                    'Humidity', '${_weather?.humidity ?? 0}%'),
                                const VerticalDivider(),
                                _buildWeatherDetail('Pressure',
                                    '${_weather?.pressure ?? 0} hPa'),
                                const VerticalDivider(),
                                _buildWeatherDetail('Wind Speed',
                                    '${_weather?.windSpeed ?? 0} m/s'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildWeatherDetail('Visibilty',
                                    '${_weather?.visibility ?? 0} m/s'),
                                const VerticalDivider(),
                                _buildWeatherDetail('Feels Like',
                                    '${_weather?.feelsLike ?? 0}'),
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildWeatherDetail(
                              'longitude', _weather?.longitude?.toString()),
                          const SizedBox(
                            width: 30,
                          ),
                          _buildWeatherDetail(
                              'latitude', _weather?.latitude?.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildWeatherDetail(
                              'Sunrise', _weather?.sunrise ?? DateTime.now()),
                          const SizedBox(width: 30),
                          _buildWeatherDetail(
                              'Sunset', _weather?.sunset ?? DateTime.now())
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, dynamic value) {
    print("Label: $label, Value: $value");

    String formatTime(DateTime dateTime) {
      String formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return formattedTime;
    }

    String formattedValue = '';

    print("Label: $label, Value: $value");

    if (value is double) {
      formattedValue = value.toString();
    } else if (value is DateTime) {
      print("Processing DateTime for label: $label");
      if (label.toLowerCase() == 'sunrise' || label.toLowerCase() == 'sunset') {
        DateTime localTime = value.toLocal();
        formattedValue = formatTime(localTime);
        print("Processing DateTime for label: $label");
        print("Formatted Time: $formattedValue");
      } else {
        formattedValue = value.toString();
      }
    } else if (value is int) {
      formattedValue = value.toString();
    } else if (value is String) {
      formattedValue = value;
    }

    print("Formatted Value: $formattedValue");
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label == 'Feels Like' ? '$formattedValue °C' : formattedValue,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
