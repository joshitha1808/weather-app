import 'package:flutter/material.dart';

class HourleyForecastItem extends StatelessWidget {
  final String time;
  final Widget icon;
  final String temp;

  const HourleyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 100,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              icon,

              const SizedBox(height: 8),

              Text(
                '${(double.parse(temp) - 273.15).toStringAsFixed(2)}°C',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
