import 'package:flutter/material.dart';

class AdditionalForecast extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const AdditionalForecast({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(icon, size: 35, color: color ?? Colors.white),

          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
