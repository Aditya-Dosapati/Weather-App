import 'package:flutter/material.dart';

class HourlyWeather extends StatelessWidget {
  //final String currSky;
  final String time;
  final IconData icon;
  final String temperature;
  final Color? color;
  const HourlyWeather({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(103, 13, 125, 190),
      elevation: 16,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          //color: Colors.white.withOpacity(0.1),
        ),
        //padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                //color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              temperature + '°C',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                //color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
