import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecastWidget({super.key, required this.time, required this.icon, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 120,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(time,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8,),
              Icon(icon, size: 32,),
              const SizedBox(height: 8,),
              Text(temperature,),
            ],
          ),
        ),
      ),
    );
  }
}