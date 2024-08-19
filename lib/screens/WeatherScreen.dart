import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WeatherScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: FutureBuilder<List<dynamic>>(
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
                final weatherData =
                    snapshot.data![index] as Map<String, dynamic>;
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
  final Map<String, dynamic> weatherData;

  WeatherCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weatherData['name'] ?? 'N/A', // Display the name of the area
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Date: ${weatherData['date'] ?? 'N/A'}'), // Display the date
            Text(
                'Temperature: ${weatherData['temp'] ?? 'N/A'}°C'), // Display the temperature
            Text(
                'Humidity: ${weatherData['humidity'] ?? 'N/A'}%'), // Display the humidity
            Text(
                'Weather: ${weatherData['weather'] ?? 'N/A'}'), // Display the weather condition
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
