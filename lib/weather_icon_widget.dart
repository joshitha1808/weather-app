import 'package:flutter/material.dart';

class WeatherIconWidget extends StatefulWidget {
  final String iconCode;
  final double height;
  final double width;
  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    required this.height,
    required this.width,
  });

  @override
  State<WeatherIconWidget> createState() => _WeatherIconWidgetState();
}

class _WeatherIconWidgetState extends State<WeatherIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/wn/${widget.iconCode}@2x.png',
      fit: BoxFit.cover,
      width: widget.width,
      height: widget.height,
    );
  }
}
