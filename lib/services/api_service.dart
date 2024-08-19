import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrlCallData =
      'https://sim-bpbd.jakarta.go.id/api-cc/3-day-call';
  final String _baseUrlTicketData =
      'https://sim-bpbd.jakarta.go.id/api-cc/3-day-tiketing';
  final String _baseUrlNews =
      'https://sim-bpbd.jakarta.go.id/api-cc/view-berita';
  final String _authUrl = 'https://api-bpbd.jakarta.go.id/api-prod/auth';
  final String _weatherUrl =
      'https://api-bpbd.jakarta.go.id/api-prod/bmkg/prakicu-dki-prov/20240816';
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

  Future<List<dynamic>> fetchWeatherData() async {
    // Ensure token is fetched before making any requests
    if (_token == null) {
      await _fetchAuthToken();
    }

    try {
      final response = await http.get(
        Uri.parse(_weatherUrl),
        headers: {
          'X-Token': _token!, // Use the token obtained from the auth API
        },
      );

      if (response.statusCode == 200) {
        print('Weather Data Response: ${response.body}');
        return json.decode(response.body)['data'];
      } else {
        print(
            'Failed to load weather data, status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<void> _fetchAuthToken() async {
    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {
        'X-Username': 'dev',
        'X-Password': 'BpbDD3v!!##',
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
