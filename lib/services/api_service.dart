import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:callcenter/models/weather.dart';

class ApiService {
  final String _baseUrlCallData =
      'use your own api';
  final String _baseUrlTicketData =
      'use your own api';
  final String _baseUrlNews =
      'use your own api';
  final String _authUrl = 'https://api-bpbd.jakarta.go.id/api-prod/auth';

  // Function to get current date in 'yyyyMMdd' format
  String getCurrentDate() {
    final DateTime now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }

  String? _token;
  final Map<String, String> _headers = {'x-username': 'BPBD!!'};

  Future<List<dynamic>> fetchCallData() async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrlCallData), headers: _headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load call data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load call data: $e');
    }
  }

  Future<List<dynamic>> fetchTicketData() async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrlTicketData), headers: _headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load ticket data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ticket data: $e');
    }
  }

  Future<List<dynamic>> fetchNews() async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrlNews), headers: _headers);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<List<String>> fetchImageThumbs() async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrlNews), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        // Extract image_thumb URLs
        return List<String>.from(
            data.map((item) => item['image_thumb']).take(5));
      } else {
        throw Exception('Failed to load image thumbs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load image thumbs: $e');
    }
  }

  // Modify this method to use the dynamic date
  Future<List<DailyWeather>> fetchWeatherData() async {
    final String currentDate = getCurrentDate(); // Get current date
    final String _weatherUrl =
        'https://api-bpbd.jakarta.go.id/api-prod/bmkg/prakicu-dki-prov/$currentDate';

    if (_token == null) {
      await _fetchAuthToken();
    }

    final response = await http.post(
      Uri.parse(_weatherUrl),
      headers: {
        'X-Token': _token!,
        'X-Username': 'dev',
        'Content-Type': 'application/json',
      },
    );

    print('Response body: ${response.body}'); // Log response body

    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        try {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          List<dynamic> data = jsonResponse['data'];
          List<DailyWeather> weatherList = [];
          for (var entry in data) {
            List<dynamic> cuaca = entry['cuaca'];
            String wilayah = entry['kabupaten'] ?? 'Tidak Diketahui';
            for (var cuacaEntry in cuaca) {
              DailyWeather weather = DailyWeather.fromJson(cuacaEntry);
              weather.wilayah = wilayah; // Set region here
              weatherList.add(weather);
            }
          }
          return weatherList;
        } catch (e) {
          throw Exception('Error parsing JSON: $e');
        }
      } else {
        throw Exception(
            'Unexpected content type: ${response.headers['content-type']}');
      }
    } else {
      throw Exception(
          'Failed to load weather data, status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchAuthToken() async {
    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {
        'X-Username': 'use your own',
        'X-Password': 'use your own',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _token = responseData['response']['token'];
      print('Token fetched successfully: $_token');
    } else {
      print('Failed to authenticate, status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to authenticate: ${response.statusCode}');
    }
  }
}
