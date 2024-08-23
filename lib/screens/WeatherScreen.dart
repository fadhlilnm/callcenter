import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg for SVG support
import '../services/api_service.dart';
import 'package:callcenter/models/weather.dart';

class WeatherScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: FutureBuilder<List<DailyWeather>>(
        future: apiService.fetchWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No weather data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final weatherData = snapshot.data![index];
                return WeatherCard(weatherData: weatherData);
              },
            );
          }
        },
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final DailyWeather weatherData;

  WeatherCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on the left
            Container(
              width: 80, // Set the width of the image container
              height: 80, // Set the height of the image container
              margin: EdgeInsets.only(
                  right: 16.0), // Add some space between image and text
              child: weatherData.image.endsWith('.svg')
                  ? SvgPicture.network(
                      weatherData.image,
                      fit: BoxFit
                          .cover, // Adjust the image to cover the container
                    )
                  : Image.network(
                      weatherData.image,
                      fit: BoxFit
                          .cover, // Adjust the image to cover the container
                    ),
            ),
            // Text on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weatherData.wilayah, // Display the region
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                      'Date: ${weatherData.localDatetime}'), // Display the date
                  Text(
                      'Temperature: ${weatherData.suhuUdara}'), // Display the temperature
                  Text(
                      'Cloud Coverage: ${weatherData.tutupanAwan}'), // Display cloud coverage
                  Text(
                      'Weather Condition: ${weatherData.kondisiCuaca}'), // Display weather condition
                  Text(
                      'Wind Direction: ${weatherData.arahAngin}'), // Display wind direction
                  Text(
                      'Wind Speed: ${weatherData.kecepatanAngin}'), // Display wind speed
                  Text(
                      'Humidity: ${weatherData.kelembapan}'), // Display humidity
                  Text(
                      'Visibility: ${weatherData.jarakPandang}'), // Display visibility
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
