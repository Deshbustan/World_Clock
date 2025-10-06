import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:world_clock/models/world_time.dart';
import 'package:world_clock/utils/constants.dart';

class ApiService {
  Future<List<WorldTime>> getLocations() async {
    final uri = Uri.parse('${Constants.API_BASE_URL}/list-time-zone?key=${Constants.API_KEY}&format=json');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final List<dynamic> zones = data['zones'];
        return zones.map((zone) => WorldTime.fromZoneJson(zone)).toList();
      } else {
        throw Exception('API Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load locations from API.');
    }
  }

  // This method is now much simpler. It only gets the time.
  Future<WorldTime> getTime(WorldTime worldTime) async {
    final uri = Uri.parse('${Constants.API_BASE_URL}/get-time-zone?key=${Constants.API_KEY}&format=json&by=zone&zone=${worldTime.url}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        worldTime.updateTime(data['formatted']);
        return worldTime;
      } else {
        throw Exception('API Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load time from API.');
    }
  }
}