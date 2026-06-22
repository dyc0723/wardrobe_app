import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class WeatherService {
  static final WeatherService _instance = WeatherService._();
  factory WeatherService() => _instance;
  WeatherService._();

  Future<WeatherResult?> getWeather(String cityName) async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?q=$cityName&appid=${AppConfig.weatherApiKey}&units=metric&lang=zh_cn',
      );
      final response = await http.get(url);
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      return WeatherResult(
        temperature: (data['main']['temp'] as num).toDouble(),
        condition: data['weather'][0]['description'] ?? '',
        icon: data['weather'][0]['icon'] ?? '01d',
        humidity: data['main']['humidity'] ?? 0,
        windSpeed: (data['wind']['speed'] as num?)?.toDouble() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}

class WeatherResult {
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;
  WeatherResult({
    required this.temperature, required this.condition,
    required this.icon, required this.humidity, required this.windSpeed,
  });
}
