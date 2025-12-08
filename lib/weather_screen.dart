import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
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
      String cityName = 'Mangalagiri';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,in&APPID=$openWeatherAPIKey',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.runtimeType);
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
          final icon = currentweatherdata['weather'][0]['icon'];

          return Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${(currentTemp - 273.15).toStringAsFixed(2)}°C',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              WeatherIconWidget(
                                iconCode: icon,
                                height: 150,
                                width: 150,
                              ),
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
          );
        },
      ),
    );
  }
}

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
    //print(icon);
    return SizedBox(
      height: 175,
      width: 150,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              icon,
              SizedBox(height: 8),
              Text(
                '${(double.parse(temp) - 273.15).toStringAsFixed(2)}°C',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalForecast extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalForecast({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(icon, size: 35),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
