import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrlCallData =
      'https://sim-bpbd.jakarta.go.id/api-cc/3-day-call';
  final String _baseUrlTicketData =
      'https://sim-bpbd.jakarta.go.id/api-cc/3-day-tiketing';
  final String _baseUrlNews =
      'https://sim-bpbd.jakarta.go.id/api-cc/view-berita';
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
}
