import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:weather_app/utils/get_current_position.dart';
import 'package:weather_app/weather_icon_widget.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final position = await getCurrentPosition();

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (int.parse(data['cod']) != 200) {
        //or if(data['cod]!='200){}
        throw 'An unexpeted error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  //Background colour
  Color getBackgroundColor(double temp) {
    if (temp < 20) {
      return const Color(0xFFFF64D4);
    } else if (temp >= 20 && temp < 30) {
      return const Color(0xFF42C6FF);
    } else {
      return const Color(0xFFFFE142);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentWeather(),
      builder: (context, snapshot) {
        //print(snapshot);
        //print(snapshot.runtimeType);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        //if(snapshot.hasData!=null){} to check if data is null or not

        final data = snapshot.data!;

        final currentweatherdata = data['list'][0];

        final double currentTemp = currentweatherdata['main']['temp'];
        final currentSky = currentweatherdata['weather'][0]['main'];
        final pressure = currentweatherdata['main']['pressure'];
        final windspeed = currentweatherdata['wind']['speed'];
        final humidity = currentweatherdata['main']['humidity'];
        //final icon = currentweatherdata['weather'][0]['icon'];
        final double temp = currentTemp - 273.15;
        final cityName = data['city']['name'];
        //final displayCity = cityName.isEmpty ? '' : cityName;

        return Scaffold(
          backgroundColor: getBackgroundColor(temp),

          appBar: AppBar(
            title: Center(
              child: Text(
                cityName,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: getBackgroundColor(temp),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh, color: Colors.black),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            temp.toStringAsFixed(2),
                            //'${(currentTemp - 273.15).toStringAsFixed(2)}°C',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),

                          // WeatherIconWidget(
                          //   iconCode: icon,
                          //   height: 150,
                          //   width: 150,
                          // ),
                          Text(
                            currentSky,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Hourley Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                const SizedBox(height: 16),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 30; i++)
                //         HourleyForecastItem(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           icon: WeatherIconWidget(
                //             iconCode: data['list'][i + 1]['weather'][0]['icon'],
                //             height: 70,
                //             width: 70,
                //           ),
                //           temp: data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                //Additional Information
                SizedBox(
                  height: 175,

                  child: ListView.builder(
                    itemCount: 6,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourleyForecast = data['list'][index + 1];
                      final time = DateTime.parse(hourleyForecast['dt_txt']);
                      return HourleyForecastItem(
                        time: DateFormat.j().format(time),
                        icon: WeatherIconWidget(
                          iconCode: hourleyForecast['weather'][0]['icon'],
                          height: 70,
                          width: 70,
                        ),
                        temp: hourleyForecast['main']['temp'].toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalForecast(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: humidity.toString(),
                    ),
                    //SizedBox(width: 60),
                    AdditionalForecast(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: windspeed.toString(),
                    ),
                    //SizedBox(width: 60),
                    AdditionalForecast(
                      icon: Icons.beach_access,
                      label: 'pressure',
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
