class Weather {
  final double clouds;
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double pressure;
  final int visibility;
  final double windSpeed;
  final String mainCondition;
  final DateTime sunrise;
  final DateTime sunset;
  final double longitude;
  final double latitude;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.feelsLike,
      required this.mainCondition,
      required this.humidity,
      required this.pressure,
      required this.visibility,
      required this.windSpeed,
      required this.clouds,
      required this.sunrise,
      required this.sunset,
      required this.longitude,
      required this.latitude});

  @override
  String toString() {
    return 'Weather(cityName: $cityName, temperature: $temperature, feelsLike: $feelsLike, visibility: $visibility, )';
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        feelsLike: json['main']['feels_like'].toDouble(),
        temperature: json['main']['temp'].toDouble(),
        humidity: json['main']['humidity'].toDouble(),
        pressure: json['main']['pressure'].toDouble(),
        visibility: json['visibility'],
        windSpeed: json['wind']['speed'].toDouble(),
        clouds: json['clouds']['all'].toDouble(),
        sunrise: DateTime.fromMillisecondsSinceEpoch(
            json['sys']['sunrise'] * 1000,
            isUtc: true),
        sunset: DateTime.fromMillisecondsSinceEpoch(
            json['sys']['sunset'] * 1000,
            isUtc: true),
        longitude: json['coord']['lon'].toDouble(),
        latitude: json['coord']['lat'].toDouble(),
        mainCondition: json['weather'][0]['main']);
  }
}
