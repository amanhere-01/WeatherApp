import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'additional_info_widget.dart';
import 'hourly_forecast_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      // FETCHING ENVIRONMENT VARIABLES
      await dotenv.load(fileName: "assets/.env");
      final apiKey = dotenv.env['API_KEY'];
      final apiURL = dotenv.env['API_URL'];

      // SENDING REQUEST
      String city= 'Delhi';
      var url= Uri.parse("$apiURL/data/2.5/forecast?q=$city&APPID=$apiKey");
      final response = await http.get(url);
      if(response.statusCode!=200){
        throw 'Error retrieving data';
      }

      final data= jsonDecode(response.body);
      return data;
    }
    catch(e){
      throw e.toString();
    }
  }

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
              onPressed: ()  {
                setState(() {

                });
              } ,
              icon : const Icon(Icons.refresh)
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: RefreshProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return  Center(
              child: Text(snapshot.error.toString())
            );
          }
          // Check if(snapshot.hasData)
          final data = snapshot.data;
          final currentWeather = data?['list'][0];
          final currentTemp=  currentWeather['main']['temp'];
          final currentSky= currentWeather['weather'][0]['main'];
          final humidity= currentWeather['main']['humidity'];
          final wind= currentWeather['wind']['speed'];
          final pressure=currentWeather['main']['pressure'];

          return Padding(
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
                      child:  Column(
                        children: [
                          const SizedBox(height: 20),
                          Text((currentTemp-273).toStringAsFixed(0)+"°C" ,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Icon(
                            currentSky=='Clouds' || currentSky=='Rain'? Icons.cloud : Icons.sunny,
                            size: 64,),
                          const SizedBox(height: 20,),
                          Text(currentSky,
                            style: const TextStyle(
                              fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              const Text('24-hour Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              // SingleChildScrollView(
              //     scrollDirection : Axis.horizontal,
              //   child:  Row(
              //     children: [
              //       for(int i=1; i<=10; i++)
              //         HourlyForecastWidget(
              //           time: data['list'][i]['dt'].toString(),
              //           icon: data['list'][i]['weather'][0]['main']=='Clouds'||data['list'][i]['weather'][0]['main']=='Rain'? Icons.cloud : Icons.sunny ,
              //           temperature: data['list'][i]['main']['temp'].toString(),
              //         ),
              //     ]
              //   ),
              // ),
              // If we use SingleChildScrollView and we have 20 widgets then it will load all the widget at once. To avoid this we use ListView.builder
              SizedBox(   // When we create ListView.builder then it covers the whole screen so we gotta give particular height
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 9,
                  itemBuilder: (context, index){
                    final hourlyForecast = data?['list'][index+1];
                    final hourlySky=hourlyForecast['weather'][0]['main'];
                    final time= DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecastWidget(
                      time: DateFormat.Hm().format(time),
                      icon: hourlySky=='Clouds'|| hourlySky=='Rain'? Icons.cloud : Icons.sunny ,
                      temperature: (hourlyForecast['main']['temp']-273).toStringAsFixed(0)+'°C'
                    );
                  }
                ),
              ),
              const SizedBox(height: 30,),
              const Text('Additional Information',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformationWidget(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '$humidity%',
                  ),AdditionalInformationWidget(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: '$wind km/h',
                  ),AdditionalInformationWidget(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: '$pressure\mbar',
                  ),
                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}