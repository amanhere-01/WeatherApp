import 'package:flutter/material.dart';

class AdditionalInformationWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInformationWidget({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(icon, size: 32,),
        SizedBox(height: 8,),
        Text(label,),
        SizedBox(height: 8,),
        Text(value,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        )
      ],
    );
  }
}