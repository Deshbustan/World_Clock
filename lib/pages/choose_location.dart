import 'package:flutter/material.dart';
import 'package:world_clock/services/world_time.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final apiUrl = Uri.parse('http://api.timezonedb.com/v2.1/list-time-zone?key=MK7Y5VA2LU3P&format=json');
      final response = await get(apiUrl);

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        List<dynamic> zones = data['zones'];

        List<WorldTime> fetchedLocations = [];
        for (var zone in zones) {
          String url = zone['zoneName'];
          String location = url.split('/').last.replaceAll('_', ' ');
          fetchedLocations.add(
            WorldTime(location: location, url: url),
          );
        }

        if (mounted) {
          setState(() {
            locations = fetchedLocations;
            isLoading = false;
          });
        }
      } else {
        print('Failed to load locations');
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      print('An error occurred: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  void updateTime(index) async {
    setState(() {
      isLoading = true;
    });
    WorldTime instance = locations[index];
    await instance.getTime();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, {
        'location': instance.location,
        'time': instance.time,
        'isDayTime': instance.isDayTime,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Choose Location', style: TextStyle(color: Colors.white70)),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                WorldTime location = locations[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      updateTime(index);
                    },
                    title: Text(location.location ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
