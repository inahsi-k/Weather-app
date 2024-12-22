//list view() widget-> if you want to make a column scrollable
//if you have a flutter code then you don't need to mention { } while using for loop
//for()...[widget,widget,etc] for more than 1 widgets
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather/additional_info.dart';
import 'package:weather/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  //if you are using it somewhere then you need to assign it before build

  late Future<Map<String, dynamic>> weather;
  //API calling k liye
  //futur dynamic is not goot so genereic as given in json file
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Kolkata';
      //uri is basically uniform resource identifier .url is it's subset
      //API calling takes time
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=5e7670b042121540c66d3db2acac280b'), //? mark k baad things are modifiable
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
      // setState(()
      // });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather =
                    getCurrentWeather(); // reinitializing weather taaki restart button daabne per updated data mile
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      //loading state
      body: FutureBuilder(
        future: weather, //getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //error state matlab if wrong url then an unexpected err...
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!; //data never going to be nullable
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final pressure = data['list'][0]['main']['pressure'];
          final windSpeed = data['list'][0]['wind']['speed'];
          final humidity = data['list'][0]['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp K",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 60,
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  " Hourly Forecast",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                //weather info(scroll view)
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       HourlyForecast(
                //           time: '00:00', icon: Icons.cloud, value: "700"),
                //       SizedBox(
                //         width: 6,
                //       ),
                //       HourlyForecast(
                //           time: '3:00', icon: Icons.cloud, value: "700"),
                //       SizedBox(
                //         width: 6,
                //       ),
                //       HourlyForecast(
                //           time: '6:00', icon: Icons.sunny, value: '678'),
                //       SizedBox(
                //         width: 6,
                //       ),
                //       HourlyForecast(
                //           time: '9:00', icon: Icons.cloud, value: "700"),
                //       SizedBox(
                //         width: 6,
                //       ),
                //       HourlyForecast(
                //           time: '12:00', icon: Icons.sunny, value: '678')
                //     ],
                //   ),
                // ),
                //list view builder for lazy loading
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final time = DateTime.parse(data['list'][index + 1][
                          'dt_txt']); //to convert string to datetime format coz of intl package format
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      return HourlyForecast(
                          time: DateFormat.j().format(time),
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          value: data['list'][index + 1]['main']['temp']
                              .toString());
                    },
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                //Additional info card
                const Text(
                  " Additional Information",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 19),
                Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround, //for even spacing(within screen size)of diff items under row.
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: humidity.toString(),
                      ),
                      AdditionalInfo(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: windSpeed.toString()),
                      AdditionalInfo(
                          icon: Icons.beach_access,
                          label: "pressure",
                          value: pressure.toString())
                    ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
