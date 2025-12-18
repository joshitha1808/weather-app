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
  (Color, String) getBackgroundColor(double temp) {
    if (temp < 20) {
      return (
        const Color(0xFFFF64D4),
        'Now it feels like +15°. It feels cool because of the rains. Today, the temperature is felt in the range from +20° to +15°.',
      );
    } else if (temp >= 20 && temp < 30) {
      return (
        const Color(0xFF42C6FF),
        'Now it feels like +25°. It feels humid now because of the heavy rain. Today, the temperature is felt in the range from +22° to +28°.',
      );
    } else {
      return (
        const Color(0xFFFFE142),
        'Now it feels like +30°. It feels hot because of the direct sun. Today, the temperature is felt in the range from +31° to +27°.',
      );
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

        String date = DateFormat('EEEE, dd MMMM').format(DateTime.now());

        return Scaffold(
          backgroundColor: getBackgroundColor(temp).$1,

          appBar: AppBar(
            backgroundColor: getBackgroundColor(temp).$1,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 4,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cityName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 6),
                      //   height: 40,
                      //   width: 80,
                      //   decoration: BoxDecoration(
                      //     color: Colors.black,
                      //     borderRadius: BorderRadius.circular(6),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                date,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(top: 6),
                            height: 40,
                            width: 190,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            currentSky,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.black,
                              height: 1.0,
                            ),
                          ),
                          //SizedBox(height: 8),
                          Text(
                            '${temp.toStringAsFixed(0)}°',
                            //'${(currentTemp - 273.15).toStringAsFixed(2)}°C',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 150,
                              color: Colors.black,
                              height: 1.0,
                            ),
                          ),

                          // WeatherIconWidget(
                          //   iconCode: icon,
                          //   height: 150,
                          //   width: 150,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  'Daily Summary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  getBackgroundColor(temp).$2,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                //Additional information
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalForecast(
                        icon: Icons.waves_outlined,
                        color: getBackgroundColor(temp).$1,
                        value: Text(
                          '${windspeed.toStringAsFixed(0)} km/h', // string interpolation
                          style: TextStyle(
                            color: getBackgroundColor(temp).$1,
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        label: Text(
                          'Wind',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: getBackgroundColor(temp).$1,
                          ),
                        ),
                      ),
                      AdditionalForecast(
                        icon: Icons.water_drop_outlined,
                        color: getBackgroundColor(temp).$1,
                        value: Text(
                          '${humidity.toString()}%', // wrap string in Text
                          style: TextStyle(
                            color: getBackgroundColor(temp).$1,
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        label: Text(
                          'Humidity',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: getBackgroundColor(temp).$1,
                          ),
                        ),
                      ),
                      AdditionalForecast(
                        icon: Icons.beach_access_outlined,
                        color: getBackgroundColor(temp).$1,
                        value: Text(
                          pressure.toString(),
                          style: TextStyle(
                            color: getBackgroundColor(temp).$1,
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        label: Text(
                          'pressure',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: getBackgroundColor(temp).$1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                const Text(
                  'Weekly forecast',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),

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
                SizedBox(height: 4),
                SizedBox(
                  height: 160,

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

                // const Text(
                //   'Additional Information',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                // ),
                // const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
