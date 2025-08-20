import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
 String? location; // Location name for the UI
 String? time; // Time in that location
 String? url; // Location URL for API endpoint
 bool? isDayTime;

 WorldTime({this.location, this.url});

  // Method to fetch the time from the API  

 Future<void> getTime() async {
    try {
     
      final apiUrl = Uri.parse('http://api.timezonedb.com/v2.1/get-time-zone?key=MK7Y5VA2LU3P&format=json&by=zone&zone=$url');
      // Making a GET request to the API
      final response = await get(apiUrl);

      if (response.statusCode == 200) {
        // Successful request
        Map data = jsonDecode(response.body);
        // print('SUCCESS: API response received -> $data');
        // print(  'SUCCESS: API response received -> ${data['formatted']}');

        // Extracting the required data from the response
        if(data['formatted'] == null) {
          
          print('ERROR: No formatted time found in the response.');
          time = 'Could not get time data';
          
        } else {
        DateTime now = DateTime.parse(data['formatted']);
        isDayTime = now.hour > 6 && now.hour < 20; // Check if it's daytime
        time = DateFormat().add_jm().format(now);
        }
        

      } else {
        // Request failed
        print(
            'ERROR: Request failed with status code: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Catch any other errors
      print('ERROR: An exception occurred -> $e');
    }
  } 
  
}

