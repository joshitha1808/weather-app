import 'package:flutter/material.dart';

class WeatherIconWidget extends StatefulWidget {
  final String icon;
  const WeatherIconWidget({super.key, required this.icon});

  @override
  State<WeatherIconWidget> createState() => _WeatherIconWidgetState();
}

class _WeatherIconWidgetState extends State<WeatherIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/wn/${widget.icon}@2x.png',
      fit: BoxFit.cover,
      width: 150,
      height: 150,
    );
  }
}
