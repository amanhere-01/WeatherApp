import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'additional_info_widget.dart';
import 'hourly_forecast_widget.dart';


class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Weather',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions:  [
          IconButton(
              onPressed: () {if (kDebugMode) {
                print('refresh');
              } },
              icon : const Icon(Icons.refresh)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,   // to make components start from left
          children: [
            SizedBox(     // for setting the width of card
              width: double.infinity,   
              child: Card(
                color: Colors.white10,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ClipRRect(   // this will clip the card borders. If we don't use this then the card elevation will be 0 due to Backdrop filter.( For clarification remove this widget then see)
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(      // It is used for applying filter in the background 
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),   // It will make the background blur except the successor column children
                    child: const Column(
                      children: [
                        SizedBox(height: 20),
                        Text('40°C',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32
                          ),
                        ),
                        SizedBox(height: 20,),
                        Icon(Icons.cloud, size: 64,),
                        SizedBox(height: 20,),
                        Text('Sunny',
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30,),

            const Text('Weather Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 10,),

            const SingleChildScrollView(
                scrollDirection : Axis.horizontal,
              child:  Row(
                children: [
                  HourlyForecastWidget(
                    time: '10:00',
                    icon: Icons.cloud,
                    temperature: '32',
                  ),HourlyForecastWidget(
                    time: '13:00',
                    icon: Icons.sunny,
                    temperature: '40',
                  ),HourlyForecastWidget(
                    time: '16:00',
                    icon: Icons.cloud,
                    temperature: '45',
                  ),HourlyForecastWidget(
                    time: '19:00',
                    icon: Icons.sunny,
                    temperature: '38',
                  ),HourlyForecastWidget(
                    time: '21:00',
                    icon: Icons.nightlight,
                    temperature: '30',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30,),

            const Text('Additional Information',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            )
            ,
            const SizedBox(height: 10,),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInformationWidget(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '92',
                ),AdditionalInformationWidget(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '92',
                ),AdditionalInformationWidget(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '92',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}




// making class of Widget instead of variable UI of hourly forecast widget

