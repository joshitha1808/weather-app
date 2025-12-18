import 'package:flutter/material.dart';

import 'utils/get_background_color.dart';

class HourleyForecastItem extends StatelessWidget {
  final String time;
  final Widget icon;
  final double temp;

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
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(6.0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 4),
            color: getBackgroundColor(temp).$1,
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              //const SizedBox(height: 4),
              icon,

              //const SizedBox(height: 4),
              Text(
                '${(temp).toStringAsFixed(2)}°C',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
